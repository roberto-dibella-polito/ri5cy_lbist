/*****************************************************************************
 * PHASE SHIFTER
 * Phase shifter for 24-bit LFSR. 
 * Shuffling is done by XORING together different input ports.
 ****************************************************************************/

module phase_shifter
#(
    parameter N_IN = 24,
	parameter N_OUT = 267
)

(
    input wire [N_IN-1:0] din,
    output wire [N_OUT-1:0] dout
);

	genvar i;

	/*generate
		i = 0;
		for( y = 0; (y < N_IN) & (i < N_OUT); y = y+1 ) begin
			for( x = 0; (x < N_IN) & (i < N_OUT); x = x+1 ) begin 
				assign dout[i] = din[y] ~^ din[x];
				i=i+1;
			end
		end
	endgenerate*/
	
	generate
		for( i=0; i < 23; i=i+1 ) begin	
				assign dout[i] = din[i+1] ~^ din[i];		// 0 - 23		
				assign dout[i+23*1] = din[i] ~^ din[0];		// 24-47
				assign dout[i+23*2] = din[i] ~^ din[2];		// 48-
				assign dout[i+23*3] = din[i] ~^ din[4];
				assign dout[i+23*4] = din[i] ~^ din[6];
				assign dout[i+23*5] = din[i] ~^ din[8];
				assign dout[i+23*6] = din[i] ~^ din[10];
				assign dout[i+23*7] = din[i] ~^ din[12];
				assign dout[i+23*8] = din[i] ~^ din[14];
				assign dout[i+23*9] = din[i] ~^ din[16];
				assign dout[i+23*10] = din[i] ~^ din[18];
				//assign dout[i+23*11] = din[i] ~^ din[20];
		end
		
		for( i=0; i < 14; i = i+1 ) begin 
				assign dout[i+253] = din[i] ~^ din[22];
		end 
	endgenerate
endmodule
