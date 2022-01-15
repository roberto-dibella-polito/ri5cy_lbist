

module tb_lbist( pi_selected_o, go_nogo_o, test_over_o, testing_o  );

        wire clk_i;
        reg en_i, rst_n_i, end_sim_i, normal_test_i;
	reg [238:0] pos_i;

	reg [266:0] pis_i;
	output wire [266:0] pi_selected_o;
	output wire go_nogo_o, test_over_o, testing_o;

        clk_gen CG(
                .END_SIM(end_sim_i),
                .CLK(clk_i));

	/*tpg D0_GEN (
                .clk    ( clk_i         ),
                .rst_n  ( rst_n_i       ),
                .en     ( en_i          ),
                .dout   ( pis_i	        )
        );*/
	

	riscv_lbist DUT (
                .clk		( clk_i			), 
		.rst_n		( rst_n_i		),
		.normal_test 	( normal_test_i		),
                .pis		( pis_i			),
                .pos            ( pos_i			),
                .pi_selected	( pi_selected_o		),
                .go_nogo	( go_nogo_o		),
                .test_over	( test_over_o		),
                .testing	( testing_o		)
	);


        initial begin
                normal_test_i = 0;
		end_sim_i = 0;
                en_i = 1;
                rst_n_i = 0; #6
                rst_n_i = 1; #80
		normal_test_i = 1; #10
		normal_test_i = 0;
        end

	// Random pattern generator for outputs
	always @(posedge clk_i) begin
		pos_i = $urandom;
		pis_i = $urandom;
	end
endmodule

