############################################
# LOGIC BIST for RISC-V Simulation Script #
# Mainly to verify all the connections    #
###########################################

rm -r work

vlib work

vcom -93 -work ./work ../mux2to1.vhd
vlog -work ./work ../tpg/lfsr/lfsr.v
vlog -work ./work ../tpg/phase_shifter/phase_shifter.v
vlog -work ./work ../out_eval/misr.v
vcom -93 -work ./work ../out_eval/out_eval.vhd
vcom -93 -work ./work ../test_counter/counter.vhd
vcom -93 -work ./work ../test_counter/test_counter.vhd
vcom -93 -work ./work ../bist_controller.vhd
vcom -93 -work ./work ../lbist_wrapper.vhd

vsim work.riscv_lbist 
