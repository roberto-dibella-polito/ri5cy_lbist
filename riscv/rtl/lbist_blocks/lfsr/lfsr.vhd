----------------------------------------------------------------------------------
-- 24-BIT LFSR																	--
-- At reset (rst_n = 0)  and when the LFSR is active ( en = 1 ),				--
-- the register is preloaded with the value specified on the seed input port.	--
-- If rst_n = 1, the value is updated ad each clock by a new value				--
-- given by the feedback loops, which implements the 24-degree 					--
-- characteristic polynomial.													--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lfsr_24 is
	generic	( N : integer := 24);
	port(	clk		: in std_logic;
			rst_n	: in std_logic;
			en		: in std_logic;
			seed	: in std_logic_vector(N downto 1);
			dout	: out std_logic_vector(N downto 1));
end lfsr_24;

architecture structure of lfsr_24 is

	signal feedback : std_logic;
	signal reg: std_logic_vector(N downto 1);
	
begin
	
	-- REGISTER
	reg_update: process(clk)
	begin
		if clk'event and clk = '1' then
			if( en = '1' ) then
				if(rst_n = '0') then
					reg <= seed;
				else
					reg <= reg(N-1 downto 1) & feedback;
				end if;
			end if;
		end if;
	end process;

	-- Combinational generation of the feedback
	feedback <= reg(N) xor reg(7) xor reg(2) xor reg(1);

	dout <= reg;

end structure;	
