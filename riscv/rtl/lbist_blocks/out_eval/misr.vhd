library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity misr is
	generic( 
		N	: integer := 24;
		SEED	: integer := 1
	);
	port(
		clk, rst_n, en	: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end entity;

architecture structure of misr is
	
	signal r_reg, r_next	: std_logic_vector(1 to N);

begin

	reg: process(clk, rst_n)
	begin
		if(rst_n'event and rst_n='0') then
			r_reg <= std_logic_vector(to_unsigned(SEED,N));
		elsif(clk'event and clk='1') then
			r_reg <= r_next;
		end if;
	end process;

	r_next(1) <= din(0) xor r_reg(N);
	
	gen: for i in 2 to N-1 generate
		
		if i=5 generate 
			r_next(i) <= 
