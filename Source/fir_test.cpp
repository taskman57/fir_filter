#include <fstream>
#include <string>
#include <iostream>
#include <cstring>
using namespace std;
#include "../ref/inp.h"
#include <hls_stream.h>
#include "fir.h"

int main (int argc, char **argv) {
	const int    SAMPLES=2000;

	hls::stream<data_t> yout;
	hls::stream<data_t> xin;
	data_t temp, out;
	int i;
	const char* fname = "../../../../../ref/out.dat"; // default: C simulation
	// Check if "cosim" argument is passed
	if (argc > 1 && strcmp(argv[1], "cosim") == 0) {
		fname = "../../../../../ref/out_cosim.dat";
	}
	ofstream fp(fname);
	for (i=0;i<SAMPLES;i++) {
		temp = (data_t)((int)inpsig[i] - 32768);
		xin.write(temp);
		cout << " xin: " << hex << temp << "\n";  // Print as hex

		// Execute the function with latest input
		fir(yout/*,taps*/,xin);
		out = yout.read();

		// Save the results
		fp << i << " " << temp << " " << out << endl;
	}
	fp.close();
	if (argc > 1 && strcmp(argv[1], "cosim") == 0) {
		printf ("   Comparing against output data \n");
		if (system("  diff -w ../../../../../ref/golden_output.dat ../../../../../ref/out_cosim.dat")) {
			fprintf(stdout, "*******************************************\n");
			fprintf(stdout, "FAIL: Output DOES NOT match the golden output\n");
			fprintf(stdout, "*******************************************\n");
			return 1;
		} else {
			fprintf(stdout, "*******************************************\n");
			fprintf(stdout, "PASS: The output matches the golden output!\n");
			fprintf(stdout, "*******************************************\n");
			return 0;
		}
	}
	return 0;
}
