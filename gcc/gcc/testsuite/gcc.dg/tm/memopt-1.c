/* { dg-do compile } */
/* { dg-options "-fgnu-tm -O -fdump-tree-tmmemopt" } */

long g, xxx, yyy;
extern george() __attribute__((transaction_callable));
extern ringo(long int);
int i;

f()
{
  __transaction_relaxed {
    g = 666;
    george();
    if (i == 9)
      goto bye;
    xxx=8;
    yyy=9;
    for (i=0; i < 10; ++i)
      ringo(g);
  bye:
    ringo(g);
  }
}

/* { dg-final { scan-tree-dump-times "transforming: .*_ITM_RaWU\[248\] \\(&g\\);" 1 "tmmemopt" } } */
/* { dg-final { scan-tree-dump-times "transforming: .*_ITM_WaRU4 \\(&i," 1 "tmmemopt" } } */
/* { dg-final { scan-tree-dump-times "transforming: .*_ITM_RaWU4 \\(&i\\);" 1 "tmmemopt" } } */
/* { dg-final { scan-tree-dump-times "transforming: .*_ITM_WaWU4 \\(&i," 1 "tmmemopt" } } */
/* { dg-final { cleanup-tree-dump "tmmemopt" } } */
