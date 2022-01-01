# Set of the libraries
# source NangateBlablabla.dc_setup_synthesis.tcl

# Set the target and the link library
set synthetic_library dw_foundation.sldb
set target_library {NangateOpenCellLibrary_typical_ccs_scan.db}
set link_library [list $target_library $synthetic_library]

set DFF_CELL DFF_X2
set LIB_DFF_D NangateOpenCellLibrary/DFF_X2/D
set OPER_COND typical

# Read the netlist
read_verilog riscv_core.v







