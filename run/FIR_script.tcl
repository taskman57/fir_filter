##############################################
##                                          ##
##      FIR script for Vitis HLS 2023.1     ##
##                                          ##
##############################################

set top_name FIR
set solution_name "solution1"
open_project -reset ${top_name}
set_top ${top_name}
add_files ../source/fir.cpp
add_files -tb ../source/fir_test.cpp -cflags "-Wno-unknown-pragmas"
open_solution ${solution_name} -flow_target vivado
set_part {xc7z010clg400-2}
create_clock -period 5 -name Synth_Clk

set_clock_uncertainty 0.5
source "directives1.tcl"

# config_compile -no_signed_zeros -pipeline_style flp -unsafe_math_optimizations

# csim_design -clean -O

csynth_design -dump_post_cfg

# replicating of Synthesis report files
file mkdir ../Sync_report/
exec cp -f ${top_name}/${solution_name}/syn/report/FIR_csynth.rpt ../Sync_report/FIR_csynth.rpt
exec cp -f ${top_name}/${solution_name}/syn/report/csynth.rpt ../Sync_report/csynth.rpt

# Dump Trace could be either of port, all or none!
# config_cosim -O -tool xsim -trace_level port

# export_design -flow impl -rtl vhdl -format ip_catalog

# uncommenting this line will open the project in GUI mode, otherwise it will run in batch mode
# vitis_hls -p FIR

exit
