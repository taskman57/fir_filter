##############################################
##                                          ##
##      FIR script for Vitis HLS 2023.1     ##
##                                          ##
##############################################

set top_name FIR
# Create the project
open_project -reset ${top_name}
set_top ${top_name}
add_files ../source/fir.cpp
add_files -tb ../source/fir_test.cpp -cflags "-Wno-unknown-pragmas"

set all_solutions [list "Solution1" "Solution2"]
set all_directive_files [list "directives1.tcl" "directives2.tcl"]

foreach solution $all_solutions directf $all_directive_files {
    open_solution -reset $solution -flow_target vivado
    # set_directive_name $directe
    set_part {xc7z010clg400-2}
    create_clock -period 5 -name Synth_Clk
    set_clock_uncertainty 0.5

    source $directf

    csynth_design -dump_post_cfg
    file mkdir ../Sync_report/${solution}
    exec cp -f ${top_name}/${solution}/syn/report/FIR_csynth.rpt ../Sync_report/${solution}/FIR_csynth.rpt
    exec cp -f ${top_name}/${solution}/syn/report/csynth.rpt ../Sync_report/${solution}/csynth.rpt
}

# config_compile -no_signed_zeros -pipeline_style flp -unsafe_math_optimizations

# csim_design -clean -O

# Dump Trace could be either of port, all or none!
# config_cosim -O -tool xsim -trace_level port

# export_design -flow impl -rtl vhdl -format ip_catalog

# uncomment the following line to compare 2 solutions
# vitis_hls -p FIR

exit
