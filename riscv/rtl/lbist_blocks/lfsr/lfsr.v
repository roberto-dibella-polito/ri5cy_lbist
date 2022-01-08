// created by : Meher Krishna Patel
// date : 22-Dec-2016
// Modified by : Roberto Di Bella

module lfsr
#(
    parameter N = 20,
    parameter SEED = 1
)

(
    input wire clk, rst_n, en, 
    output wire [N:0] dout
);

reg [N:0] r_reg;
wire [N:0] r_next;
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
3:
	//// Feedback polynomial : x^3 + x^2 + 1
	////total sequences (maximum) : 2^3 - 1 = 7
	assign feedback_value = r_reg[3] ~^ r_reg[2] ~^ r_reg[0];

4:	assign feedback_value = r_reg[4] ~^ r_reg[3] ~^ r_reg[0];

5:  //maximum length = 28 (not 31)
	assign feedback_value = r_reg[5] ~^ r_reg[3] ~^ r_reg[0];

7:	assign feedback_value = r_reg[7] ~^ r_reg[3] ~^ r_reg[0];

9:	assign feedback_value = r_reg[9] ~^ r_reg[5] ~^ r_reg[0];

10:	assign feedback_value = r_reg[10] ~^ r_reg[7] ~^ r_reg[0];

16: 	assign feedback_value = r_reg[16] ~^ r_reg[15] ~^ r_reg[13] ~^ r_reg[4] ~^ r_reg[0];

20: 	assign feedback_value = r_reg[20] ~^ r_reg[3] ~^ r_reg[0];


default: 
	begin
		 initial
			$display("Missing N=%d in the LFSR code, please implement it!", N);
		//illegal missing_case("please implement");
	end		
endcase
endgenerate


assign r_next = {feedback_value, r_reg[N:1]};
assign dout = r_reg;
endmodule
