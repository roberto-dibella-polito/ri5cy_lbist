vlib work

#vcom -93 -work ./work ../lfsr.vhd
vlog -work ./work ../tpg.v
vcom -93 -work ./work ../../clk_gen.vhd
vlog -work ./work ../tb_tpg.v

vsim work.tb_tpg

add wave *
run 200 ns
