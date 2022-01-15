/***********************************************************
 * GENERIC 2-1 N-BIT MULTIPLEXER
 **********************************************************/

module mux2to1_n
#(	
	parameter N = 269
)

(
	input wire sel,
	input wire [N-1:0] d0,d1,
	output wire [N-1:0] dout
);

	always @ (d0 or d1 or sel)
	begin
		case(sel)
			0:	assign dout = d0;
			1:	assign dout = d1;
		endcase
	end
endmodule
	
