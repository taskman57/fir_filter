::::::::::::::::::::::::::::::::::::
::      Project:   FIR Core       ::
::::::::::::::::::::::::::::::::::::

@echo off
@echo ""

@echo  calling Vitis settings and ..
@echo  running Vitis HLS in batch mode
@echo  to open the project run: vitis_hls -p FIR

set MODE=%1
if "%MODE%"=="" set MODE=sim

call settings64.bat
vitis_hls -f FIR_Script.tcl

::  to open project comment above line, uncomment below line!

::   vitis_hls -p FIR