# Script Files for Vitis HLS FIR Filter

This repository contains script files and supporting resources for implementing and optimizing a FIR filter using **Vitis HLS**.  
The project was developed using **Vitis HLS v2023.1** and has also been validated with **Vitis HLS v2024.2**.

This project provides a practical framework for exploring and evaluating HLS optimization strategies. Through hands-on experimentation with different directive sets and synthesis configurations, users can gain insight into how design choices affect scheduling, resource utilization, and performance. The focus is on understanding trade-offs and making informed decisions to achieve an efficient balance between throughput, latency, and hardware cost.

## **PROJECT FOLDERS**

## **REF**
This folder contains input sample files used to verify the functional correctness of the FIR algorithm. These samples can be used for both **C simulation** and **RTL co-simulation**.

## **SOURCE**
Contains the FIR source code, synthesis files, and the main testbench used during HLS compilation and simulation.

## **SIM_SCRIPT**
This folder contains the MATLAB/Octave simulation script used to generate **golden reference results** for verification in Vitis HLS.

## **DOCS**
This folder contains documentation artifacts, including snapshots of input and output signals, in-band and out-of-band attenuation measurements, and frequency response plots of the FIR filter.

## **RUN**
This folder contains the script files for defining the project setup and directive configuration used to evaluate optimization techniques.  
Users can modify the existing directive file or add new, independent directive sets to synthesize and compare alternative solutions.

### Running the project

The `runme.bat` script drives `FIR_Script.tcl` in batch mode and supports two modes, selected via an argument:

```
runme.bat sim     :: runs C simulation (default if no argument is given)
runme.bat synth   :: runs synthesis and copies the resulting reports
```

The mode is passed to Vitis HLS through an environment variable (`MODE`), since `vitis_hls -f` does not forward script arguments directly to Tcl's `$argv`.

## **Filter Order**

The filter was reduced from **54 taps to 50 taps**. This reduces logic and memory resource usage (multipliers/adders in the systolic FIR chain, and coefficient storage) while still meeting the required frequency-response and attenuation specifications — see `DOCS` for before/after frequency response and attenuation comparisons.
