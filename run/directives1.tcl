##############################################
##                                          ##
##      directives for solution1            ##
##                                          ##
##############################################
set_directive_pipeline -II 1 "fir"
set_directive_interface -mode ap_vld "fir" y
set_directive_bind_storage -type rom_1p -impl bram "fir" c
set_directive_interface -mode ap_vld "fir" x
set_directive_array_partition -dim 1 -type complete "fir" c
set_directive_array_partition -dim 1 -type complete "fir" shift_reg
