rm -r work
vlib work

#vcom -93 -work ./work ../lfsr.vhd
vlog -work ./work ../lfsr/lfsr.v
vlog -work ./work ../phase_shifter/phase_shifter.v
vcom -93 -work ./work ../../tb/clk_gen.vhd
vlog -work ./work ../tb_tpg.v

vsim work.tb_tpg

add wave *
run 200 ns
