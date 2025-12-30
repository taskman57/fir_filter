##############################################
##                                          ##
##      directives for solution1            ##
##                                          ##
##############################################
set_directive_pipeline -II 1 "fir"
set_directive_interface -mode axis -register_mode off "fir" y
set_directive_interface -mode axis -register_mode off "fir" x
set_directive_array_partition -dim 1 -type complete "fir" shift_reg
