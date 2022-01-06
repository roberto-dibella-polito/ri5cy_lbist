##################### RISC-V ATPG #######################
# Version:	Basic scan				#
# Faults:	Transition Delay			#
#########################################################

read_netlist ../../gate/techlib/NangateOpenCellLibrary.v -library -insensitive
read_netlist ../../gate/run/riscv_scan.v -master -insensitive
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

run_drc ../../gate/run/riscv_scan.spf

# TRANSITION DELAY
# At-speed test
set_delay -launch_cycle system_clock
set_delay -pi_changes
set_atpg -capture_cycles 2

set_faults -model transition
add_faults -all

set_patterns -internal
set_atpg -full_seq_atpg
run_atpg -auto_compression

# Reports
set_faults -summary verbose -fault_coverage
report_summaries > ../rpt/scan_summary_tdf_basic.txt
write_faults ../rpt/scan_tdf_faults.txt -all -uncollapsed -replace
