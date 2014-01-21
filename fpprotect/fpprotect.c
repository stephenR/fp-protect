#include <ldsodefs.h>
#include <bits/libc-lock.h>

#ifndef SHARED
static struct ptr_region * const volatile _fpp_region_list __attribute__((section(".rodata"))) = NULL;
static struct ptr_region *_fpp_defer_list;
#endif

__rtld_lock_define_initialized_recursive (, _dl_fpp_lock)

struct ptr_region **__dl_fpp_region_list(void)
{
  return &GLRO(fpp_region_list);
}

struct ptr_region **__dl_fpp_defer_list(void)
{
  return &GL(fpp_defer_list);
}

void __dl_fpp_mutex_lock(void)
{
#ifdef SHARED
  GLRO(fpp_rtld_lock_recursive) (&(GL(dl_fpp_lock)).mutex);
#else
  __libc_maybe_call (__pthread_mutex_lock, (&(GL(dl_fpp_lock)).mutex), 0);
#endif
}

void __dl_fpp_mutex_unlock(void)
{
#ifdef SHARED
  GLRO(fpp_rtld_unlock_recursive) (&(GL(dl_fpp_lock)).mutex);
#else
  __libc_maybe_call (__pthread_mutex_unlock, (&(GL(dl_fpp_lock)).mutex), 0);
#endif
}

