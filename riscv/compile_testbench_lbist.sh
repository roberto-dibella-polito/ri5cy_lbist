#!/bin/bash

cd $( dirname $0)
root_dir=${PWD}
cd - &>/dev/null

run_dir=${root_dir}/run

mkdir -p ${run_dir}

cd ${run_dir}

### GATE LEVEL VERSION #########

#rm -rf work_gate

vlib work_gate
vlog -work work_gate +define+functional ${root_dir}/gate/NangateOpenCellLibrary.v
vcom -93 -work work_gate \
	${root_dir}/rtl/lbist_blocks/mux2to1.vhd \
	${root_dir}/rtl/lbist_blocks/out_eval/out_eval.vhd \
	${root_dir}/rtl/lbist_blocks/test_counter/counter.vhd \
	${root_dir}/rtl/lbist_blocks/test_counter/test_counter.vhd \
	${root_dir}/rtl/lbist_blocks/bist_controller.vhd \
	${root_dir}/rtl/lbist_blocks/lbist_wrapper.vhd \
	${root_dir}/rtl/riscv_scan_core_lbist.vhd 

vlog -work work_gate \
	${root_dir}/rtl/lbist_blocks/tpg/lfsr/lfsr.v \
	${root_dir}/rtl/lbist_blocks/tpg/phase_shifter/phase_shifter.v \
	${root_dir}/rtl/lbist_blocks/out_eval/misr.v \
	${root_dir}/gate/scan/syn/output/riscv_core_scan.v 

vlog -sv -work work_gate -cover t -novopt -timescale "1 ns/ 1 ps"  -suppress 2577 -suppress 2583  \
	${root_dir}/rtl/include/riscv_config.sv \
	${root_dir}/tb/core/fpnew/src/fpnew_pkg.sv \
	${root_dir}/rtl/include/apu_core_package.sv \
	${root_dir}/rtl/include/riscv_defines.sv \
	${root_dir}/rtl/include/riscv_tracer_defines.sv \
	${root_dir}/tb/tb_riscv/include/perturbation_defines.sv \
	${root_dir}/tb/tb_riscv/riscv_perturbation.sv \
	${root_dir}/tb/tb_riscv/riscv_random_stall.sv \
	${root_dir}/tb/tb_riscv/riscv_random_interrupt_generator.sv \
	${root_dir}/tb/core/riscv_wrapper_gate_lbist.sv \
	${root_dir}/tb/core/dp_ram.sv \
	${root_dir}/tb/core/cluster_clock_gating.sv \
	${root_dir}/tb/core/tb_top_lbist.sv \
	${root_dir}/tb/core/mm_ram.sv \
	${root_dir}/tb/verilator-model/ram.sv

vopt -work work_gate -debugdb -fsmdebug "+acc" tb_top -o tb_top_vopt

exit #(SKIP RTL)
### RTL VERSION #################

rm -rf work_rtl

vlib  work_rtl

vlog -sv -work work_rtl +acc=rnbpc -cover t +incdir+${root_dir}/rtl/include  -suppress 2577 -suppress 2583 \
	${root_dir}/tb/core/fpnew/src/fpnew_pkg.sv \
	${root_dir}/rtl/include/apu_core_package.sv \
	${root_dir}/rtl/include/riscv_defines.sv \
	${root_dir}/rtl/include/riscv_tracer_defines.sv \
	${root_dir}/tb/tb_riscv/include/perturbation_defines.sv \
	${root_dir}/rtl/riscv_if_stage.sv \
	${root_dir}/rtl/riscv_hwloop_controller.sv \
	${root_dir}/rtl/riscv_tracer.sv \
	${root_dir}/rtl/riscv_prefetch_buffer.sv \
	${root_dir}/rtl/riscv_hwloop_regs.sv \
	${root_dir}/rtl/riscv_int_controller.sv \
	${root_dir}/rtl/riscv_cs_registers.sv \
	${root_dir}/rtl/riscv_register_file.sv \
	${root_dir}/rtl/riscv_load_store_unit.sv \
	${root_dir}/rtl/riscv_id_stage.sv \
	${root_dir}/rtl/riscv_core.sv \
	${root_dir}/rtl/riscv_compressed_decoder.sv \
	${root_dir}/rtl/riscv_fetch_fifo.sv \
	${root_dir}/rtl/riscv_alu_div.sv \
	${root_dir}/rtl/riscv_prefetch_L0_buffer.sv \
	${root_dir}/rtl/riscv_decoder.sv \
	${root_dir}/rtl/riscv_mult.sv \
	${root_dir}/rtl/register_file_test_wrap.sv \
	${root_dir}/rtl/riscv_L0_buffer.sv \
	${root_dir}/rtl/riscv_ex_stage.sv \
	${root_dir}/rtl/riscv_alu_basic.sv \
	${root_dir}/rtl/riscv_pmp.sv \
	${root_dir}/rtl/riscv_apu_disp.sv \
	${root_dir}/rtl/riscv_alu.sv \
	${root_dir}/rtl/riscv_controller.sv \
	${root_dir}/tb/tb_riscv/riscv_random_stall.sv \
	${root_dir}/tb/tb_riscv/riscv_random_interrupt_generator.sv \
	${root_dir}/tb/core/riscv_wrapper.sv \
	${root_dir}/tb/core/dp_ram.sv \
	${root_dir}/tb/core/cluster_clock_gating.sv \
	${root_dir}/tb/core/tb_top.sv \
	${root_dir}/tb/core/mm_ram.sv

vopt -work work_rtl -debugdb -fsmdebug "+acc=rnbpc" tb_top -o tb_top_vopt

