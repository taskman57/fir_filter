#include <fstream>
#include <string>
#include <iostream>
using namespace std;
#include "../ref/inp.h"
#include "fir.h"

int main () {
	const int    SAMPLES=30;

	data_t output;
	data_ut Signal;

	coef_t taps[N] = {
	-4,     19,     25,     39,     59,     85,    118,    158,    205,
	261,    324,    395,    473,    558,    647,    741,    837,    933,
	1028,   1119,   1204,   1282,   1350,   1407,   1451,   1481,   1496,
	1496,   1481,   1451,   1407,   1350,   1282,   1204,   1119,   1028,
	933,    837,    741,    647,    558,    473,    395,    324,    261,
	205,    158,    118,     85,     59,     39,     25,     19,     -4};

	int i;
	Signal = 0;
	ofstream fp("../../../../ref/out.dat");
	for (i=0;i<SAMPLES;i++) {
		Signal = inpsig[i];
		cout << " Signal: " << hex << Signal << endl;  // Print as hex

		// Execute the function with latest input
		fir(&output,taps,Signal);

		// Save the results
		fp << i << " " << Signal << " " << output << endl;
	}
	fp.close();
	return 0;

//  printf ("   Comparing against output data \n");
//  if (system("  diff -w ../../../../ref/out.dat ../../../../ref/Myout.dat")) {
//
//	fprintf(stdout, "*******************************************\n");
//	fprintf(stdout, "FAIL: Output DOES NOT match the golden output\n");
//	fprintf(stdout, "*******************************************\n");
//     return 1;
//  } else {
//	fprintf(stdout, "*******************************************\n");
//	fprintf(stdout, "PASS: The output matches the golden output!\n");
//	fprintf(stdout, "*******************************************\n");
//     return 0;
//  }
}
