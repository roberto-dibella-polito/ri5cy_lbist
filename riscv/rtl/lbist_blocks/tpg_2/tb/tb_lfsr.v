/******************************
 * TESTBENCH for 24-bit LFSR
 *****************************/

module tb_lfsr (dout_i);

	wire clk_i;
	reg end_sim_i;
	reg rst_n_i;
	reg en_i;

	//reg [24:1] seed_i;
	output wire [23:0] dout_i;

	clk_gen CG(
		.END_SIM(end_sim_i),
		.CLK(clk_i));

	lfsr #(
		.N(24),
		.SEED(1)
	) DUT (
		
		.clk(clk_i),
		.rst_n(rst_n_i),
		.en(en_i),
		//.seed(seed_i),
		.dout(dout_i));

	//initial reset
	initial begin
		end_sim_i = 0;
		en_i = 1;
		//seed_i = 24'h000001;
		rst_n_i = 0; #6
		rst_n_i = 1; #18
		en_i = 0; #5
		en_i = 1;

	end
endmodule
