##################### RISC-V ATPG #######################
# Version:	Basic scan				#
# Faults:	Stuck-at				#
#########################################################

read_netlist ../../syn/techlib/NangateOpenCellLibrary.v -library -insensitive
read_netlist ../../syn/output/riscv_core_scan.v -master
run_build_model riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800

run_drc ../../syn/output/riscv_core_scancompress.spf

set_patterns -random
set_random_patterns -length 99
#run_simulation -sequential
add_faults -all

run_fault_simulation

# Reports
set_faults -summary verbose -fault_coverage
report_summaries > ../rpt/scancompress_summary.txt
write_faults ../rpt/scancompress_faults.txt -all -uncollapsed -replace

quit