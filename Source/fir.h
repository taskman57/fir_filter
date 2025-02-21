#ifndef FIR_H_
#define FIR_H_
#define N	54

typedef short			coef_t;
typedef short			data_t;
typedef unsigned short	data_ut;
typedef unsigned int	acc_t;

void fir (
  data_t *y,
  coef_t c[N+1],
  data_t x
  );

#endif
