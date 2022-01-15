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
(	input wire clk, en, rst_n,
	output wire [266:0] dout 
 );
	
	wire [266:0] tmp_dout;
	// Generate the LFSRs for PI
	
	genvar i;
	generate
		for(i=0; i<260; i=i+24) begin : gen_block_1
			lfsr #( .N(24), .SEED(i) )
			lfsr_i (
				.clk(clk),
				.en(en),
				.rst_n(rst_n),
				.dout( tmp_dout[i+23:i] )
			);
		end
	endgenerate

	generate
		for(i=0; i<3; i=i+1) begin : gen_block_2
			assign tmp_dout[264+i] = tmp_dout[263] ~^ tmp_dout[262-i];
		end
	endgenerate		
 
	assign dout = tmp_dout; 
endmodule
