--/****************************************************************************
-- * TEST PATTERN GENERATOR (267 bits)
-- ****************************************************************************/

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--module tpg
--(	input wire clk, en, rst_n,
--	output wire [266:0] dout 
-- );

entity tpg is
	port(
		clk, rst_n, en 	: in std_logic;
		dout		: out std_logic_vector(266 downto 0)
	);
end entity;

architecture structure of tpg is
	
	signal	tmp_dout	: std_logic_vector(266 downto 0);
	--wire [266:0] tmp_dout;
	--// Generate the LFSRs for PI

	component lfsr 
		generic(
                	SEED    : integer := 16#000001# );
        	port(
                	clk, rst_n, en  : in std_logic;
                	dout            : out std_logic_vector(23 downto 0)
        	);
	end component;

	
begin	
	--genvar i;
	--generate
	--	for(i=0; i<260; i=i+24) begin : gen_block_1
	--		lfsr #( .N(24), .SEED(i) )
	--		lfsr_i (
	--			.clk(clk),
	--			.en(en),
	--			.rst_n(rst_n),
	--			.dout( tmp_dout[i+23:i] )
	--		);
	--	end
	--endgenerate
	lfsr_gen : for i in 0 to 10 generate
		lfsr_i : lfsr generic map( SEED => i ) port map
			(	clk 	=> clk,
				rst_n	=> rst_n,
				en	=> en,
				dout	=> tmp_dout(24*i+23 downto 24*i) );
	end generate;

	-- @ i = 9	=> tmp_dout(239 downto 216)	
	-- @ i = 10 	=> tmp_dout(24*10+23 downto 24*10) => tmp_dout(263 downto 240)

	-- Last three bits -> generated using XORs
	last_bits: for i in 0 to 2 generate
		--for(i=0; i<3; i=i+1) begin : gen_block_2
		--	assign tmp_dout[264+i] = tmp_dout[263] ~^ tmp_dout[262-i];
		--end
		tmp_dout(264+i) <= tmp_dout(263) xor tmp_dout(262-i);
	end generate;		
 
	dout <= tmp_dout;
 
end structure;
