#!/bin/bash

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

cd ${root_dir}/run

#tmax -s ../riscv_atpg_scan_stuck.tcl
#tmax -s ../riscv_atpg_scan_tdf.tcl
#tmax -s ../riscv_atpg_scancompress_stuck.tcl
#tmax -s ../riscv_atpg_scancompress_tdf.tcl

#tmax -s ../riscv_atpg_scan.tcl
tmax -s ../riscv_atpg_scancompress.tcl
