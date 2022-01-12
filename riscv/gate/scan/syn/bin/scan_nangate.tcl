##################### RI5CY SCAN INSERTION - Version 2 ##########################################
# Script that inserts scan chains to the RI5CY gate-level netlist.				#	
# This version is based on the template and the directory structure provided.			#
#												#
# Output files:	riscv_core_scan.v		Top-level entity with scan insertion		#
# 		riscv_core_scan.spf		STIL procedure for scan design			#
# 		riscv_core_scancompress.spf	STIL procedure for scan-compressed design	#
#################################################################################################

set GATE_PATH			../output
set REPORT_PATH			../rpt
set LOG_PATH			../log

set TECH 			NangateOpenCell
set TOPLEVEL			riscv_core

set search_path [ join "../techlib/ $search_path" ]
set search_path [ join "$GATE_PATH $search_path" ]

source ../bin/$TECH.dc_setup_scan.tcl

##########################################
# VARIABLES for SCAN INSERTION
# Change it here

set scanChains 7
set scanCompress 25

##########################################

read_ddc $TOPLEVEL.ddc
#link
#check_design
compile_ultra -incremental -gate_clock -scan -no_autoungroup


set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE


report_area > ${REPORT_PATH}/area_pre_dft.txt
set_dft_configuration -scan_compression enable

set test_default_scan_style multiplexed_flip_flop

### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i 


set_scan_element false NangateOpenCellLibrary/DLH_X1


set_scan_configuration -chain_count $scanChains
#set_scan_compression_configuration -chain_count $scanCompress
set_scan_compression_configuration -max_length 100

create_test_protocol -infer_asynch -infer_clock
dft_drc
preview_dft > ${REPORT_PATH}/scan_dft.txt
insert_dft

streaming_dft_planner

change_names -rules verilog -hierarchy

report_scan_path -test_mode all > ${REPORT_PATH}/chains.txt

report_area > ${REPORT_PATH}/area_post_dft.txt

write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_scan.v"
write_file -format ddc -hierarchy -output "${GATE_PATH}/${TOPLEVEL}_scan.ddc" 
write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_scan.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}_scan.sdc"
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scan.spf" -test_mode Internal_scan
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scancompress.spf" -test_mode ScanCompression_mode

#quit
