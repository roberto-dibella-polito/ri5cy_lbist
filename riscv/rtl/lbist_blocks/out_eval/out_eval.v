/*****************************************************************************
 * OUTPUT EVALUATOR for RI5CY implementation
 * 239 outputs for the current implementation with 7 scan chains is
 * considered.
 * To speed-up the design, it was decided to instantiate ten 24-bit MISRs:
 * for this reason, the last input bit was extendend.
 ****************************************************************************/

module out_eval
#(
    parameter N = 239
)

(
    input wire clk, rst_n, en, 
    input wire [N-1:0] din,
	output wire [N:0] dout
);

	wire [N:0] tmp_in;

	assign tmp_in = {din[N-1],din};
	
	genvar i;
	generate
		for(i=0;i<10;i=i+1)
			misr #(
				.N(24),
				.SEED(1000)
			) misr_i (
				.clk(clk),
				.rst_n(rst_n),
				.en(en),
				.din(tmp_in[24*i+23:24*i]),
				.dout(dout[24*i+23:24*i]));
	endgenerate
endmodule
	
                        
