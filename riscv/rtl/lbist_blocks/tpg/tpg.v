/****************************************************************************
 * TEST PATTERN GENERATOR
 * Generates random patterns for the 267 inputs of the RI5CY.
 * The implementation considered has 
 * - 260 primary inputs
 * - 7 scan chains input
 * It is decided to use thirteen 19-degree LFSR for the primary inputs and
 * a 7-degree LFSR for the scan chains inputs.
 * The latest will require a randomizer block before being connected to the
 * RI5CY.
 ****************************************************************************/

module tpg
(	input wire clk, en, rst_n;
	output wire pi_dout[259:0], sc_dout[6:0] );

	// Generate the LFSRs for PI
	generate
		for(i=0; i < 260; i = i+20) begin
			lfsr #( .N(20), .SEED(i) )
			lfsr_i (
				.clk(clk),
				.en(en),
				.rst_n(rst_n),
				.dout( pi_dout[i+19,i] )
			);
		end
	endgenerate
  
	// LFSR for scan chains
	
	lfsr #( .N(7), .SEED(1) )
	lfsr_sc (
		.clk(clk),
		.en(en),
		.rst_n(rst_n),
		.dout(sc_dout)
	);
endmodule
