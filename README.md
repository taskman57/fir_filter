# Script files for Vitis HLS FIR Filter
This was done with V2023.1
This project offers a compelling opportunity to explore and apply various optimization strategies, providing a deeper understanding of how these techniques work in practice. Through hands-on experimentation and testing of different solutions, participants can uncover effective ways to balance logical efficiency with optimal performance, making informed decisions to achieve the best possible outcomes.

## Project folders:


## ref:
You can put input samples of function in this folder for testing the correctness of algorithm, either for C Simulation or Co/Sim RTL simulation

## source:
contains synthesis and main files

## run:
This folder containes script files for defining project and directive files to test various optimization techniques.
You can change the optimisation directives in directive files or add another independent directive file to compile and compare the results.
For comparing the solutions open the project using below command and go to project-> Compare Reports

vitis_hls -p FIR