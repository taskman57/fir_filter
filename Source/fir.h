#ifndef FIR_H_
#define FIR_H_
#define N	54

typedef short			coef_t;
typedef short			data_t;
typedef int				acc_t;

static coef_t taps[N] = {
		-4,     19,     25,     39,     59,     85,    118,    158,    205,
		261,    324,    395,    473,    558,    647,    741,    837,    933,
		1028,   1119,   1204,   1282,   1350,   1407,   1451,   1481,   1496,
		1496,   1481,   1451,   1407,   1350,   1282,   1204,   1119,   1028,
		933,    837,    741,    647,    558,    473,    395,    324,    261,
		205,    158,    118,     85,     59,     39,     25,     19,     -4
	};

void fir (
  data_t *y,
//  coef_t c[N],
  data_t *x
  );

#endif
