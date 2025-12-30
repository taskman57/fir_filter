##############################################
##                                          ##
##      FIR script for Vitis HLS 2023.1     ##
##                                          ##
##############################################

set top_name fir
# Create the project
open_project -reset ${top_name}
set_top ${top_name}
add_files ../Source/fir.cpp
add_files -tb ../Source/fir_test.cpp -cflags "-Wno-unknown-pragmas"

open_solution -reset "solution1" -flow_target vivado
config_export -rtl vhdl -vivado_clock 10
set_part {xc7z010clg400-1}
create_clock -period 5 -name Synth_Clk
set_clock_uncertainty 0.5
source directives1.tcl
# If you want to see C simulation, enable this line
# csim_design -clean -O
csynth_design -dump_post_cfg
file mkdir ../Synth_report/solution1
exec cp -f ${top_name}/solution1/syn/report/${top_name}_csynth.rpt ../Synth_report/solution1/${top_name}_csynth.rpt
exec cp -f ${top_name}/solution1/syn/report/csynth.rpt ../Synth_report/solution1/csynth.rpt

# Dump Trace could be either of port, all or none!
config_cosim -argv cosim -tool xsim -trace_level port
cosim_design -tool xsim -trace_level port -argv {cosim}

export_design -rtl vhdl -format ip_catalog -output ../IP/${top_name}.zip

exit
