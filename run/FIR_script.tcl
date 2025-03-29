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
    set_part {xc7z010clg400-1}
    create_clock -period 5 -name Synth_Clk
    set_clock_uncertainty 0.5

    source $directf

    csynth_design -dump_post_cfg
    file mkdir ../Sync_report/${solution}
    exec cp -f ${top_name}/${solution}/syn/report/${top_name}_csynth.rpt ../Sync_report/${solution}/${top_name}_csynth.rpt
    exec cp -f ${top_name}/${solution}/syn/report/csynth.rpt ../Sync_report/${solution}/csynth.rpt
}

# config_compile -no_signed_zeros -pipeline_style flp -unsafe_math_optimizations

# csim_design -clean -O

# Dump Trace could be either of port, all or none!
# config_cosim -O -tool xsim -trace_level port

export_design -flow impl -rtl vhdl -format ip_catalog
config_export -flow impl -format ip_catalog -rtl vhdl -vivado_phys_opt all
export_design -rtl vhdl -format ip_catalog -output ../IP/${top_name}.zip
file mkdir ../Impl_report/
# if export has only syn, then uncomment the below line
# exec cp -f ${top_name}/solution1/impl/report/vhdl/export_syn.rpt ../Impl_report/export_syn.rpt
# if export has impl, then uncomment the below lines
exec cp -f ${top_name}/${solution}/impl/report/vhdl/export_impl.rpt ../Impl_report/export_impl.rpt
exec cp -f ${top_name}/${solution}/impl/report/vhdl/${top_name}_export.rpt ../Impl_report/${top_name}_export.rpt

# uncomment the following line to compare 2 solutions
# vitis_hls -p FIR

exit
