/**************************************************
 * TESTBENCH for TEST-PATTERN GENERATOR
 **************************************************/

module tb_tpg(  ti_i, tf_i  );
	
	wire clk_i;
	reg en_i, rst_n_i, end_sim_i;
	wire [23:0] random_i;
	
	output wire ti_i, tf_i;

	clk_gen CG(
		.END_SIM(end_sim_i),	
		.CLK(clk_i) );
	
	test_counter #(
		.TEST_DURATION(8),
		.TEST_START(3)
	) DUT1 (
		.clk(clk_i),
		.en(en_i),
		.rst_n(rst_n_i),
		.test_started(ti_i),
		.test_finished(tf_i) );
	
	initial begin
		end_sim_i = 0;
		en_i = 1;
		rst_n_i = 0; #6
		rst_n_i = 1; 
	end
endmodule
