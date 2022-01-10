--------------------------------------------------
-- OUTPUT EVALUATOR for RI5CY IMPLEMENTATION
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_evaluator is
	generic(
		N : integer := 239;
		EXPECTED_SIGNATURE : std_logic_vector(N-1 downto 0) := (others=>'0') 
	);
	port(
		clk, rst_n, en	: in std_logic;
		din				: in std_logic_vector(N-1 downto 0);
		dout			: out std_logic_vector(N downto 0);
		sign_ok			: out std_logic
	);
end output_evaluator;

architecture structure of output_evaluator is

	signal tmp_in, tmp_out : std_logic_vector(N downto 0);
	
	component misr
		generic(
			N		: integer := 24;
			SEED	: integer := 10
		);
		port(
			clk, en, rst_n	: in std_logic;
			din				: in std_logic_vector(N-1 downto 0);
			dout			: out std_logic_vector(N-1 downto 0) );
	end component;
	
begin
	
	tmp_in <= din(N-1) & din;	
	
	misr_gen: for i in 9 generate
		misr_i: misr generic map( N => 24, SEED => 1 ) port map
		(	clk 	=> clk,
			en 		=> en,
			rst_n	=> rst_n,
			din		=> tmp_in(24*i+23 downto 24*i),
			dout	=> dout(24*i+23 downto 24*i) );
	end generate;

	compare: process(tmp_out)
	begin
		if( tmp_out = EXPECTED_SIGNATURE ) then sign_ok <= '1';
		else sign_ok <= '0';
		end if;
	end process;

end structure;		
