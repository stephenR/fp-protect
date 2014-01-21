
#ifndef _FPPROTECT_H
#define _FPPROTECT_H 1

extern void *fpp_protect_func_ptr (void *p);
extern void *fpp_protect_func_ptr_perm (void *p);
extern void fpp_free_func_ptr (void *p);

typedef void (*fpp_unprotected_t)(void) __attribute__((fpprotect_disable));

#define FPP_UNPROTECTED(ptr) ((fpp_unprotected_t) (ptr))

#endif /* fpprotect.h */
