set GATE_PATH			../output
set LOG_PATH			../log
set REPORT_PATH			../rpt

set TECH 			NangateOpenCell
set TOPLEVEL			riscv_core

set search_path [ join "../techlib/ $search_path" ]
set search_path [ join "$GATE_PATH $search_path" ]

source ../bin/$TECH.dc_setup_scan.tcl


read_ddc $TOPLEVEL.ddc
#link
#check_design
create_logic_port -direction in test_mode_tp
compile_ultra -incremental -gate_clock -scan -no_autoungroup


set_dft_clock_gating_pin [get_cells * -hierarchical -filter "@ref_name =~ SNPS_CLOCK_GATE*"] -pin_name TE

report_area > ${REPORT_PATH}/area_pre_dft.txt
set_dft_configuration -scan_compression enable
set_dft_configuration -testability enable

set test_default_scan_style multiplexed_flip_flop
set_scan_element false NangateOpenCellLibrary/DLH_X1


### Set pins functionality ###
set_dft_signal  -view existing_dft -type ScanEnable -port test_en_i
set_dft_signal  -view spec -type ScanEnable -port test_en_i 

set_dft_signal -view existing_dft -type Constant -active_state 1 -port test_mode_tp
set_dft_signal -view spec -type TestMode -active_state 1 -port test_mode_tp

# Global automatic test point insertion
set_testability_configuration -control_signal test_mode_tp -test_points_per_scan_cell 16

set_testability_configuration -target core_wrapper

set_testability_configuration -target random_resistant -random_pattern_count 1024

set_testability_configuration -target x_blocking


set_scan_configuration -chain_count 7
set_scan_compression_configuration -max_length 100

create_test_protocol -infer_asynch -infer_clock
dft_drc
run_test_point_analysis
preview_dft > ${REPORT_PATH}/preview_dft.txt
insert_dft

streaming_dft_planner

change_names -rules verilog -hierarchy

report_scan_path -test_mode all > ${REPORT_PATH}/chains.txt

report_area > ${REPORT_PATH}/area_post_dft.txt

write -hierarchy -format verilog -output "${GATE_PATH}/${TOPLEVEL}_scan.v"
write_file -hierarchy -format ddc -output "${GATE_PATH}/${TOPLEVEL}_scan.ddc"
write_sdf -version 3.0 "${GATE_PATH}/${TOPLEVEL}_scan.sdf"
write_sdc "${GATE_PATH}/${TOPLEVEL}_scan.sdc"
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scan.spf" -test_mode Internal_scan
write_test_protocol -output "${GATE_PATH}/${TOPLEVEL}_scancompress.spf" -test_mode ScanCompression_mode
#quit
