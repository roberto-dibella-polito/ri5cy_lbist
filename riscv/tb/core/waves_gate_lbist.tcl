#add wave -group "Core" /tb_top/riscv_wrapper_i/riscv_core_i/*

add wave -group "Testbench" \
sim:/tb_top/clk \
sim:/tb_top/rst_n \
sim:/tb_top/cycle_cnt_q \
sim:/tb_top/go_nogo \
sim:/tb_top/test_over \
sim:/tb_top/fetch_enable \
sim:/tb_top/test_mode \
sim:/tb_top/normal_test \
sim:/tb_top/clock_en 

add wave -group "LBIST" \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/controller/CURRENT_STATE \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/clk \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/rst_n \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/normal_test \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/pis \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/pos \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/pi_selected \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/go_nogo \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/test_over \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/testing \
{"ScanInputs" {\
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si1 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si2 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si3 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si4 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si5 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si6 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_si7 }}\
{"ScanOutputs" {\
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so1 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so2 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so3 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so4 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so5 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so6 \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/core/test_so7 }}\
-divider "TestClock" \
sim:/tb_top/riscv_wrapper_i/riscv_core_i/lbist/test_cnt/cnt_i
