# Setup
set_environment_viewer -instance_names
set_messages -log tmax.log -replace

## Build and DRC
read_netlist ../rtl/lbist_blocks/mux2to1.vhd
read_netlist ../rtl/lbist_blocks/tpg/lfsr/lfsr.v
read_netlist ../rtl/lbist_blocks/tpg/phase_shifter/phase_shifter.v
read_netlist ../rtl/lbist_blocks/out_eval/misr.v
read_netlist ../rtl/lbist_blocks/out_eval/out_eval.vhd
read_netlist ../rtl/lbist_blocks/test_counter/counter.vhd
read_netlist ../rtl/lbist_blocks/test_counter/test_counter.vhd
read_netlist ../rtl/lbist_blocks/bist_controller.vhd
read_netlist ../rtl/lbist_blocks/lbist_wrapper.vhd

read_netlist ../gate/NangateOpenCellLibrary.tlib -library
read_netlist ../gate/scan/syn/output/riscv_core_scan.v
run_build_model riscv_core
run_drc

## Load and check patterns
set_patterns -external dumpports_gate.evcd.fixed  -sensitive -strobe_period { 10 ns } -strobe_offset { 59 ns }
run_simulation -sequential

## Fault list (select one of the following)
#add_faults -all
add_faults ex_stage_i/alu_i
#add_faults ex_stage_i/alu_i/int_div_div_i
#add_faults ex_stage_i/mult_i
#add_faults id_stage_i/registers_i/riscv_register_file_i
#read_faults previous_fsim_faults.txt -force_retain_code -add

## Fault simulation
run_fault_sim -sequential

## Reports
set_faults -fault_coverage
report_faults -level {5 100} > report_faults_hierarchy.txt
report_faults -level {100 1} -verbose > report_faults_verbose.txt
report_summaries > report_summaries.txt
write_faults fsim_faults.txt -replace -all
