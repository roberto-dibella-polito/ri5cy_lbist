

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1_n is
	generic(
		N : integer := 269 
	);
	port(
		sel	: in std_logic;
		d0, d1	: in std_logic_vector(N-1 downto 0);
		dout	: out std_logic_vector(N-1 downto 0)
	);
end mux2to1_n;

architecture bhv of mux2to1_n is

begin

	mux: process( d0, d1, sel )
	begin
		if sel = '0' then
			dout <= d0;
		else	
			dout <= d1;
		end if;
	end process;
end bhv;
