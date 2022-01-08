vlib work

#vcom -93 -work ./work ../lfsr.vhd
vlog -work ./work ../lfsr.v
vcom -93 -work ./work ../clk_gen.vhd
vlog -work ./work ../tb_lfsr.v

vsim work.tb_lfsr

add wave *
add wave sim:/tb_lfsr/DUT/*
run 50 ns
