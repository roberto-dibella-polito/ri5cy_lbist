/*****************************************************************************
 * MISR - Multi-Input Signature Register
 * Used to compute the signature of the circuit and identifify possible
 * defects.
 *
 ****************************************************************************/

module misr
#(
    parameter N = 24,
    parameter SEED = 100
)

(
    input wire clk, rst_n, en, 
    input wire [N-1:0] din,
	output wire [N-1:0] dout

);

	reg [1:N] r_reg;
	wire [1:N] r_next;
                        
	always @(posedge clk,negedge rst_n)
	begin 
    	if (rst_n == 1'b0)
        	r_reg <= SEED;  // use this or uncomment below two line
    	else if (en == 1'b1)
        	r_reg <= r_next;
	end

	genvar i;

	assign r_next[1] = din[0] ~^ r_reg[N]; 
	generate
		case (N)
			// Cases
			23: 	// x[23]+x[5]+1
				begin : gen_block_1
					for( i=2; i<=N; i=i+1 ) begin : gen_block_1
						if( i==5) begin: gen_block_1
							assign r_next[i] = r_reg[i-1] ~^ din[i-1] ~^ r_reg[N];
						end else begin: gen_block_1
							assign r_next[i] = r_next[i-1] ~^ din[i-1];
						end
					end
				end

 			24: 	// x[24]+x[7]+x[2]+x[1]
				begin: gen_block_1
					for( i=2; i<=N; i=i+1 ) begin : gen_block_1
						if( i==7 | i==2 | i == 1) begin: gen_block_1
							assign r_next[i] = r_reg[i-1] ~^ din[i-1] ~^ r_reg[N];
						end else begin: gen_block_1
							assign r_next[i] = r_reg[i-1] ~^ din[i-1]; 
						end
					end	
				end
 
			default: 
				begin: gen_block_1
		 			initial
						$display("Missing N=%d in the LFSR code, please implement it!", N);
						//illegal missing_case("please implement");
				end		
		endcase
	endgenerate

	//assign r_next = {feedback_value, r_reg[]};
	assign dout = r_reg;

endmodule
