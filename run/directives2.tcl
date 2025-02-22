##############################################
##                                          ##
##      directive for solution2             ##
##                                          ##
##############################################
set_directive_top -name FIR "fir"

set_directive_interface -mode ap_vld "fir" y
set_directive_bind_storage -type rom_1p -impl bram "fir" c
set_directive_interface -mode ap_vld "fir" x

set_directive_top -name fir "fir"
set_directive_unroll "fir/Shift_Accum_Loop"
set_directive_pipeline -II 1 -style flp "fir"
