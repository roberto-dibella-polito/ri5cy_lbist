-- 24-bit LRlibrary ieee;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr is
	generic(
		SEED 	: integer := 16#000001# );
	port(	
		clk, rst_n, en	: in std_logic;
		dout		: out std_logic_vector(23 downto 0)
	);	
end lfsr;

architecture structure of lfsr is

	signal r_reg, r_next	: std_logic_vector(1 to 24);
	signal feedback_value	: std_logic;

begin

	reg: process(clk, rst_n)
	begin
		if(  rst_n='0') then
			r_reg <= std_logic_vector(to_unsigned(SEED,24));
		elsif(clk'event and clk='1') then 
			if en='1' then
				r_reg <= r_next;
			end if;
		end if;
	end process;

	feedback_value <= r_reg(24) xor r_reg(7) xor r_reg(2) xor r_reg(1);

	r_next <= feedback_value & r_reg(1 to 23);

	dout <= r_reg;

end structure;
