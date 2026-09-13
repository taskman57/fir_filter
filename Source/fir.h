#ifndef FIR_H_
#define FIR_H_
#include <hls_stream.h>
#define N	50

typedef short			coef_t;
typedef short			data_t;
typedef int				acc_t;

static coef_t taps[N] = {
    59, 55, 79, 108, 143, 184, 232, 285, 345, 410,
    480, 553, 630, 709, 788, 866, 942, 1015, 1082, 1143,
    1195, 1239, 1273, 1295, 1274, 1274, 1295, 1273, 1239, 1195,
    1143, 1082, 1015, 942, 866, 788, 709, 630, 553, 480,
    410, 345, 285, 232, 184, 143, 108, 79, 55, 59
	};

void fir (
  hls::stream<data_t> &y,
  hls::stream<data_t> &x
  );

#endif
