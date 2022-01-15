/**************************************************
 * TESTBENCH for TEST-PATTERN GENERATOR
 **************************************************/

module tb_tpg( dout_i  );
	
	wire clk_i;
	reg en_i, rst_n_i, end_sim_i;
	
	output wire [266:0] dout_i;

	 clk_gen CG(
                .END_SIM(end_sim_i),
                .CLK(clk_i));


	tpg DUT (
                .clk	( clk_i		), 
		.rst_n	( rst_n_i 	), 
		.en	( en_i		),  
                .dout	( dout_i	)
        );

	
	initial begin
		end_sim_i = 0;
		en_i = 1;
		rst_n_i = 0; #6
		rst_n_i = 1; 
	end
endmodule
