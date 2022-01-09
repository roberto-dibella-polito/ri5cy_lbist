/**************************************************
 * TESTBENCH for TEST-PATTERN GENERATOR
 **************************************************/

module tb_tpg( sc_dout_i, pi_dout_i );
	
	wire clk_i;
	reg en_i, rst_n_i, end_sim_i;

	output wire [6:0] sc_dout_i;
	output wire [259:0] pi_dout_i;

	clk_gen CG(
		.END_SIM(end_sim_i),	
		.CLK(clk_i) );
	
	tpg DUT(
		.clk(clk_i),
		.en(en_i),
		.rst_n(rst_n_i),
		.pi_dout(pi_dout_i),
		.sc_dout(sc_dout_i) );

	initial begin
		end_sim_i = 0;
		en_i = 1;
		rst_n_i = 0; #6
		rst_n_i = 1; 
	end
endmodule
