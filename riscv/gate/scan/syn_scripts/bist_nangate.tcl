##################### RI5CY SCAN INSERTION with LBIST  ##########################################
#################################################################################################

set GATE_PATH			../output
set REPORT_PATH			../rpt
set LOG_PATH			../log

set TECH 			NangateOpenCell
set TOPLEVEL			riscv_core

set search_path [ join "../techlib/ $search_path" ]
set search_path [ join "$GATE_PATH $search_path" ]

source ../bin/$TECH.dc_setup_scan.tcl

analyze -format vhdl -work work ../../../../rtl/lbist_blocks/mux2to1.vhd
analyze -format vhdl -work work ../../../../rtl/lbist_blocks/bist_controller.vhd
analyze -format verilog -work work ../../../../rtl/lbist_blocks/tpg/lfsr/lfsr.v
analyze -format verilog -work work ../../../../rtl/lbist_blocks/tpg/phase_shifter/phase_shifter.v
analyze -format vhdl -work work ../../../../rtl/lbist_blocks/test_counter/counter.vhd
analyze -format vhdl -work work ../../../../rtl/lbist_blocks/test_counter/test_counter.vhd
analyze -format verilog -work work ../../../../rtl/lbist_blocks/out_eval/misr.v
analyze -format vhdl -work work ../../../../rtl/lbist_blocks/out_eval/out_eval.vhd
analyze -format vhdl -work work ../../../../rtl/lbist_blocks/lbist_wrapper.vhd
analyze -format vhdl -work work ../../../../rtl/riscv_scan_core_lbist.vhd

#current_design 


#link
#check_design
#compile

#write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_lbist.v"
#write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_lbist.sdf"
#write_sdc "${GATE_PATH}/${TOPLEVEL}_lbist.sdc"
#quit
