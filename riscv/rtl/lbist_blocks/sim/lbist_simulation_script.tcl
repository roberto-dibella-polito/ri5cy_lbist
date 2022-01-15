############################################
# LOGIC BIST for RISC-V Simulation Script #
# Mainly to verify all the connections    #
###########################################

rm -r work

vlib work

vcom -93 -work ./work ../mux2to1.vhd
vcom -93 -work ./work ../tpg_2/lfsr.vhd
vcom -93 -work ./work ../tpg_2/tpg.vhd
vlog -work ./work ../out_eval/misr.v
vcom -93 -work ./work ../out_eval/out_eval.vhd
vcom -93 -work ./work ../test_counter/counter.vhd
vcom -93 -work ./work ../test_counter/test_counter.vhd
vcom -93 -work ./work ../bist_controller.vhd
vcom -93 -work ./work ../lbist_wrapper.vhd

#testbench
vcom -93 -work ./work ../tb/clk_gen.vhd
vlog -work work ../tb/tb_lbist_wrapper.v

vsim work.tb_lbist 

add wave -group "LBIST" sim:/tb_lbist/DUT/*
