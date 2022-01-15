library ieee;
use ieee.std_logic_1164.all;
use iee.numeric_std.all;

entity lfsr is
	generic( 
		N 	: integer := 24;
		SEED 	: integer := 16#000001# );
	port(	
		clk, rst_n, en	: in std_logic;
		dout		: out std_logic_vector(N-1 downto 0)
	);	
end lfsr;

architecture structure of lfsr is

	signal r_reg, r_next	: std_logic_vector(1 to N);
	signal feedback_value	: std_logic;

begin

	reg: process(clk, rst_n)
	begin
		if(rst_n'event and rst_n='0') then
			r_reg <= std_logic_vector(to_unsigned(SEED,N));
		elsif(clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;

	polyn_24: if N=24 generate 
		feedback_value <= r_reg(24) xor r_reg(7) xor r_reg(2) xor r_reg(1);
	end generate;

	r_next <= feedback_value & r_reg(1 to N-1);

end structure;
