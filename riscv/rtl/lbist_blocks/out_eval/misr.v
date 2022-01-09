/*****************************************************************************
 * MISR - Multi-Input Signature Register
 * Used to compute the signature of the circuit and identifify possible
 * defects.
 *
 ****************************************************************************/

module lfsr
#(
    parameter N = 20,
    parameter SEED = 1
)

(
    input wire clk, rst_n, en, 
    input wire [N-1:0] din,
	output wire [N-1:0] dout

);


// Register is indexed backwards for compliancy with taps
// indication given during the course.
reg [1:N] r_reg;
wire [1:N] r_next;
wire feedback_value;
                        
always @(posedge clk,negedge rst_n)
begin 
    if (rst_n == 1'b0)
        r_reg <= SEED;  // use this or uncomment below two line
    else if (clk == 1'b1 & en == 1'b1)
        r_reg <= r_next;
end

generate
case (N)

23: 	assign feedback_value = r_reg[19] ~^ r_reg[5] ~^ r_reg[2] ~^ r_reg[1];

24: 	assign feedback_value = r_reg[24] ~^ r_reg[7] ~^ r_reg[2] ~^ r_reg[1];

default: 
	begin
		 initial
			$display("Missing N=%d in the LFSR code, please implement it!", N);
		//illegal missing_case("please implement");
	end		
endcase
endgenerate


assign r_next = {feedback_value, r_reg[1:N-1]};
assign dout = r_reg;
endmodule
