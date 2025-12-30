#include "fir.h"

void fir (
  hls::stream<data_t> &y,
  hls::stream<data_t> &x
  )
{
	static data_t shift_reg[N];
	acc_t acc,temp;
	data_t data, dat2, temp_x;
	int i;
	acc=0;
	temp_x = x.read();
	Shift_Accum_Loop:
	for (i=N-1;i>=0;i--) {
		if (i==0) {
			shift_reg[0]=temp_x;
		}
		else {
			shift_reg[i]=shift_reg[i-1];
		}
	}
	Mirroring_Accum_Loop:
	for (i=N/2-1;i>=0;i--) {
		if (i==0) {
			data = temp_x;
			dat2 = shift_reg[N-1];
		}
		else {
			data = shift_reg[i];
			dat2 = shift_reg[N-i-1];
		}
		temp = (data + dat2)*taps[i];
		acc+=temp;
	}
	Shifting_Part:
	y.write(acc>>16);
}
