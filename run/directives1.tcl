##############################################
##                                          ##
## directives for FIR Core in HLS 2023.1    ##
##                                          ##
##############################################
set_directive_top -name FIR "fir"

set_directive_interface -mode ap_vld "fir" y
set_directive_bind_storage -type rom_1p -impl bram "fir" c
set_directive_interface -mode ap_vld "fir" x
