-- UP COUNTER

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity counter is 
    generic(
		N			: integer := 7;
		RST_VALUE 	: integer := 0
	);
    port(
		clk, rst_n, en	: in std_logic;
		count			: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture beh of counter is 

	signal	cnt	: std_logic_vector(N-1 downto 0);

begin 

	process(clk, rst_n, en)

		variable tmp: std_logic_vector(N-1 downto 0);

	begin

		if (rst_n = '0') then 
			tmp := std_logic_vector(to_unsigned(rst_value, N));
		elsif (clk'event and clk = '1') then
    		if (en = '1') then
	    		tmp := tmp +'1';
			end if;
		end if;
		
		count <= tmp;
	end process;

end beh;
