fp-protect
==========

Function pointer protection is an experimental compiler modification
for the C compiler of [GCC](http://gcc.gnu.org/) with the intention to protect function
pointers against malicious overwrites through memory corruption
vulnerabilities. The approach should be fully compliant with the C99
standard. However, in some cases of implementation defined behaviour,
the protection scheme will break some programs, specifically
just-in-time compilers.

A proper README will follow but for now, let me just paste my e-mail
which I wrote to the gcc and oss-security mailing lists, in order to
outline the project (more information can be found in my [master's thesis](http://zero-entropy.de/fpp.pdf).

Note that the current implementation is in an early stage and will only
support GCC on Linux x86_64.

E-mail
------
<pre>
Hi everyone,

I'd like to present you my master's thesis "Malicious Code Execution
Prevention through Function Pointer Protection" [0] and its
proof-of-concept implementation [1] for the gcc+glibc and would
appreciate some feedback.

In my thesis, I tried to find a way to prevent the exploitation of
memory corruption vulnerabilities, in which an attacker is able to
control the content of a function pointer variable and also bypass ASLR
(e.g. by brute force or an information leak). The former is given for
example in use-after-free scenarios comparable to CVE-2013-0170 [2].
In the general case, the attacker can either control parameters to the
function pointer as well and execute e.g. system() directly, or he will
have to call a stack pivoting gadget to have the stack pointer point to
attacker-controlled memory.

Approach:
The basic idea of the thesis is to record all addresses that are
assigned to a function pointer variable at some place in the program (or
in one of the shared libraries) and if a function pointer is called,
verify that the address has been recorded previously. Thus, if an
attacker overwrites the fp variable with either the address of system()
or of a stack pivoting gadget, the fp call will fail, since these
adresses have never been assigned to a function pointer in the program.
The security of the approach relies on the assumption that no function
that can be abused for malicious purposes is ever assigned to a function
pointer, but this requirement will be weakened under future work.

How this works:
The compiler, GCC in my PoC, will register all assignments of function
pointer variables in the source code and will create a global variable
for the assigned function, which is initialized to the function's
address. Then, it replaces the address of the function in the assignment
with the address of the newly created variable:
    fp f = &printf;
becomes:
  printf_var = &printf;
    ...
    fp f = &printf_var;
Further, a global constructor is created that is run before the main
function of the program or before the shared library is loaded. This
constructor allocates a memory area where it stores the address of each
fp address previously registered. The created global variable is then
overwritten to point to the new memory area instead. Finally, the memory
area is mapped read only. Also, the variable where the address of this
area is stored has to be in read only memory as well to prevent
malicious overwrites. Putting it all together, the memory layout looks
like this:
                                    <read only>
 +-------+    +------------+    +------------------+    +----------+
 | fp f  | -> | printf_var | -> | protected memory | -> | printf() |
 +-------+    +------------+    +------------------+    +----------+
Additional instructions are emitted by the compiler before function
pointer calls. They will verify that the global variable (printf_var)
points to the protected memory region, from which it extracts the real
function pointer to be called. If an attacker is able to overwrite
either the function pointer or the global variable, he will only be able
to execute functions contained in the protected memory area (which he
can't overwrite since it is mapped read only during normal execution).

Implementation:
The protection and verification code is moved to a shared library,
libgcc at the moment.
In order to work, the glibc and the runtime linker required some manual
modifications, for example manual protection of code addresses, but most
programs should not need any modifications at all. An exception might be
JIT compilers or any code that wants to call an address that does not
belong to a function.

Performance:
Though my PoC implementation is not free of bugs, I was able to compile
an nginx webserver and have it serve static websites, which I used for a
performance evaluation. On my test system, the number of requests per
second that the nginx could was reduced to 96% compared to a nginx
without the scheme. Handling of a single request included 71 function
pointer calls in this case. (More details can be found in my thesis [0])

Security:
Unfortunately, I already found a way to bypass the scheme if the
attacker controls the first parameter passed to the call of the
overwritten function pointer, but I will present future work that will
prevent this bypass.
The problem is that the glibc uses internal dlopen and dlsym functions
as function pointers. As a consequence, an attacker will be able to
abuse these functions to execute arbitrary code. (dlopen by providing a
shared library with a constructor or by using dlsym to acquire an
arbitrary callable function pointer. section 6.2.2 in my thesis)

Future work:
Through the protected memory area, the possibility exists to store
additional meta information next to the function pointer. This can be
used to a) store the type of the function pointer and only allow calls
using compatible types and b) assign groups to function pointers and
prohibid calls if the groups do not match.
The first approach will further narrow down the possibilities of an
attacker. If he can overwrite a single function pointer variable, he
will only be able to call functions with a matching signature.
The second approach, requires an extension to the C language that is not
standard conformant (e.g. using the gcc __attribute__ syntax) as well as
manual annotation in the source code. But it could be used for example,
to assign a group to the internally used dynamic linking routines and
prevent that they're abused by an attacker.

Feedback and criticism is very welcome, also if anything is unclear feel
free to ask.

Regards,
Stephen

[0] http://zero-entropy.de/fpp.pdf
[1] git://zero-entropy.de/fpp_autobuild.git
[2] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-0170
</pre>
