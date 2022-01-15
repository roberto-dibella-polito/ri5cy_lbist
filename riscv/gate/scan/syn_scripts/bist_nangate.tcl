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

elaborate ${TOPLEVEL} -work work
link
uniquify
check_design

set CLOCK_SPEED 2
create_clock [get_ports clk_i] -period $CLOCK_SPEED
set_ideal_network [get_ports clk_i]

set core_outputs [all_outputs]
set core_inputs  [remove_from_collection [all_inputs] [get_ports clk_i]]
set core_inputs  [remove_from_collection $core_inputs [get_ports rst_ni]]

set INPUT_DELAY  [expr 0.4*$CLOCK_SPEED]
set OUTPUT_DELAY [expr 0.4*$CLOCK_SPEED]

set_input_delay  $INPUT_DELAY  $core_inputs  -clock [get_clock]
set_output_delay $OUTPUT_DELAY [all_outputs] -clock [get_clock]

set_ideal_network       -no_propagate    [all_connected  [get_ports rst_ni]]
set_ideal_network       -no_propagate    [get_nets rst_ni]
set_dont_touch_network  -no_propagate    [get_ports rst_ni]
set_multicycle_path 2   -from            [get_ports   rst_ni]

compile_ultra -no_autoungroup

report_area > "${REPORT_PATH}/${TOPLEVEL}_lbist.txt"

change_names -hierarchy -rules verilog
write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_lbist.v"
write -hierarchy -format ddc -output "${GATE_PATH}/${TOPLEVEL}_lbist.ddc"
write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_lbist.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}_lbist.sdc"
# write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}.spf"
# write_tmax_library -path "${GATE_PATH}"
#
