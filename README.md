# Script Files for Vitis HLS FIR Filter

This repository contains script files and supporting resources for implementing and optimizing a FIR filter using **Vitis HLS**.  
The project was developed using **Vitis HLS v2023.1** and has also been validated with **Vitis HLS v2024.2**.

This project provides a practical framework for exploring and evaluating HLS optimization strategies. Through hands-on experimentation with different directive sets and synthesis configurations, users can gain insight into how design choices affect scheduling, resource utilization, and performance. The focus is on understanding trade-offs and making informed decisions to achieve an efficient balance between throughput, latency, and hardware cost.

## **PROJECT FOLDERS**

## **REF**
This folder contains input sample files used to verify the functional correctness of the FIR algorithm. These samples can be used for both **C simulation** and **RTL co-simulation**.

## **SOURCE**
Contains the FIR source code, synthesis files, and the main testbench used during HLS compilation and simulation.

## **M FILE**
This folder contains MATLAB/Octave scripts used to run simulations and generate **golden reference results** for verification in Vitis HLS.

## **DOCS**
This folder contains documentation artifacts, including snapshots of input and output signals, in-band and out-of-band attenuation measurements, and frequency response plots of the FIR filter.

## **RUN**
This folder contains script file for defining the project setup and directive configuration used to evaluate optimization techniques.  
Users can modify existing directive file or add new, independent directive sets to synthesize and compare alternative solutions.