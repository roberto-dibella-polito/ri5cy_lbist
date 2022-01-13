##################### RISC-V ATPG #######################
# Version:	Basic scan				#
# Faults:	Stuck-at				#
#########################################################

read_netlist ../../syn/techlib/NangateOpenCellLibrary.v -library -insensitive
read_netlist ../../syn/output/riscv_core_scan.v -master -insensitive
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

run_drc ../../syn/output/riscv_core_scan.spf

# STUCK-AT FAULTS
#set_faults -model stuck
add_faults -all

set_patterns -internal
set_atpg -full_seq_atpg
run_atpg -auto_compression

# Reports
set_faults -summary verbose -fault_coverage
report_summaries > ../rpt/scan_summary_basic.txt
write_faults ../rpt/scan_faults.txt -all -uncollapsed -replace

quit
