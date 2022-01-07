##################### RI5CY - SCAN INSERTION ############################################
# Script that inserts scan chains to the RI5CY gate-level synthesis.			#
# 											#
# Input files: 	riscv_core.v		RI5CY Gate-level description (provided)		#
# 		library			NangateOpenCell Library				#
# 											#
# Output files:	riscv_scan.v		RI5CY gate-level with scan insertion		#
#		riscv_scan.spf		STIL procedure file				#
#########################################################################################

############ TO-DO LIST #################################################
# - Find the optimum scanChain/scanCompress ratio
# - Understand if there are violations and how to eliminate them
#########################################################################

# Set of the libraries
# source NangateBlablabla.dc_setup_synthesis.tcl

# Set the target and the link library
set synthetic_library dw_foundation.sldb
set target_library {../techlib/NangateOpenCellLibrary_typical_ccs_scan.db}
set link_library [list $target_library $synthetic_library]
#set link_library {../techlib/NangateOpenCellLibrary_typical_ccs_scan.db}
read_db $target_library

set DFF_CELL DFF_X2
set LIB_DFF_D NangateOpenCellLibrary/DFF_X2/D
set OPER_COND typical

##############################################
# VARIABLES for SCAN CONFIGURATION
# Change it here

set scanChains 5
set scanCompress 20

##############################################

# Read the netlist
#read_verilog ../riscv_core.v
#current_design riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
#link

# Read DDC -> if the synthesis was already run.
# In this case, it is chosen to do everything in the "classic" way
read_ddc ../riscv_core.ddc 

# Create the clock -> the compiler knows that there is a clock signal
#set CLOCK_SPEED 2
#create_clock      [get_ports clk_i] -period $CLOCK_SPEED -name REF_CLK

# Compile ULTRA
compile_ultra -incremental -gate_clock -scan -no_autoungroup

############################### Design For Testability configurations ########################################

set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE

report_area > ../rpt/area_pre_dft.txt
set_dft_configuration -scan_compression enable

set test_default_scan_style multiplexed_flip_flop

set_dft_signal -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal -view spec -type ScanEnable -port test_en_i

set_dft_configuration -testability enable

set_scan_element false NangateOpenCellLibrary/DLH_X1

set_scan_configuration -chain_count $scanChains
set_scan_compression_configuration -chain_count $scanCompress

create_test_protocol -infer_asynch -infer_clock
dft_drc
preview_dft > ../rpt/scan_dft.txt
insert_dft

change_names -rules verilog -hierarchy

report_scan_path -test_mode all
report_scan_path -view existing -chain all > chains.txt
report_area > area_post_dft.txt

write -hierarchy -format verilog -output "../riscv_scan.v"
write_file -format ddc -hierarchy -output "../riscv_scan.ddc"
write_sdf -version 3.0 "riscv_scan.sdf"
write_sdc "riscv_scan.sdc"
write_test_protocol -output "riscv_scan.spf" -test_mode Internal_scan
write_test_protocol -output "riscv_scancompress.spf" -test_mode ScanCompression_mode
