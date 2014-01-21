/* This is the sigaction structure from the Linux 2.1.20 kernel.  */

#define HAVE_SA_RESTORER

typedef void (*sa_restorer_t) (void) __attribute__((fpprotect_disable));
typedef __sighandler_t unprotected_sighandler_t __attribute__((fpprotect_disable));

struct old_kernel_sigaction {
	unprotected_sighandler_t k_sa_handler;
	unsigned long sa_mask;
	unsigned long sa_flags;
	sa_restorer_t sa_restorer;
};

/* This is the sigaction structure from the Linux 2.1.68 kernel.  */

struct kernel_sigaction {
	unprotected_sighandler_t k_sa_handler;
	unsigned long sa_flags;
	sa_restorer_t sa_restorer;
	sigset_t sa_mask;
};
