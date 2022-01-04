# Set of the libraries
# source NangateBlablabla.dc_setup_synthesis.tcl

# Set the target and the link library
set synthetic_library dw_foundation.sldb
set target_library {../techlib/NangateOpenCellLibrary_typical_ccs_scan.db}
set link_library [list $target_library $synthetic_library]
#set link_library {../techlib/NangateOpenCellLibrary_typical_ccs_scan.db}
read_db ../techlib/NangateOpenCellLibrary_typical_ccs_scan.db

set DFF_CELL DFF_X2
set LIB_DFF_D NangateOpenCellLibrary/DFF_X2/D
set OPER_COND typical

##############################################
# VARIABLES for SCAN CONFIGURATION
# Change it here

set scanChains 3
set scanCompress 50

##############################################

# Read the netlist
#read_verilog ../riscv_core.v
#current_design riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
#link

# From now on, the top-level is the entire core (name retrieved from netlist)
#
# Now, how to optimize?

# Read DDC
read_ddc riscv_core.ddc 

# How to insert multiple scan clocks?
# TRY 1:
# - Create the ports for clocks
# - Create the clocks
# - With set_dft_signals, declare them as SCAN CLOCK
#
# THEN
# - Can the insert_dft or set_scan_configuration automatically connect 
# scan chains and clock ports?
# - Do I have to set the scan chains manually AFTER the dft insertion?

####################### TRY 1: MANUAL PORT INSERTION ##########################
# 1. Manual port definition
# 2. AFTER insert_dft, connect clocks to the different scan chains
###############################################################################

create_port -direction "in" {sclk1 sclk2 sclk3}
create_clock sclk1 -period 2 -name SCAN_CLOCK_1
create_clock sclk2 -period 2 -name SCAN_CLOCK_2
create_clock sclk3 -period 2 -name SCAN_CLOCK_3

# Compile ULTRA
compile_ultra -incremental -gate_clock -scan -no_autoungroup

set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE

report_area
set_dft_configuration -scan_compression enable

set test_default_scan_style multiplexed_flip_flop

set_dft_signal -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal -view spec -type ScanEnable -port test_en_i

###############################################################################
# Scan Clock ports definition

#set_dft_signal -view existing_dft -type ScanClock -port sclk1
set_dft_signal -view spec -type ScanClock -port sclk1

#set_dft_signal -view existing_dft -type ScanClock -port sclk2
set_dft_signal -view spec -type ScanClock -port sclk2

#set_dft_signal -view existing_dft -type ScanClock -port sclk3
set_dft_signal -view spec -type ScanClock -port sclk3
###############################################################################

set_scan_configuration -chain_count $scanChains
set_scan_compression_configuration -chain_count $scanCompress

create_test_protocol -infer_asynch -infer_clock
dft_drc
preview_dft
insert_dft

change_names -rules verilog -hierarchy

report_scan_path -test_mode all
report_area

write -hierarchy -format verilog -output "riscv_scan.v"
write_sdf -version 3.0 "riscv_scan.sdf"
write_sdc "riscv_scan.sdc"
write_test_protocol -output "riscv_scan.spf" -test_mode Internal_scan
write_test_protocol -output "riscv_scancompress.spf" -test_mode ScanCompression_mode
