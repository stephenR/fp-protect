/* Contributed by Kris Van Hees <kris.van.hees@oracle.com> */
/* Expected errors for char16_t/char32_t in gnu++98. */
/* Ensure u and U prefixes are parsed as separate tokens in gnu++98. */
/* { dg-do compile } */
/* { dg-options "-std=gnu++98" } */

const static char16_t	c0	= 'a';	/* { dg-error "not name a type" } */
const static char32_t	c1	= 'a';	/* { dg-error "not name a type" } */

const unsigned short	c2	= u'a';	/* { dg-error "not declared" } */
const unsigned long	c3	= U'a';	/* { dg-error "not declared" } */

#define u	1 +
#define U	2 +

const unsigned short	c5	= u'a';
const unsigned long	c6	= U'a';

#undef u
#undef U
#define u	"a"
#define U	"b"

const void		*s0	= u"a";
const void		*s1	= U"a";

int main () {}
