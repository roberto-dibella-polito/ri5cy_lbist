library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity counter is 
    generic(
		bit_num	: integer := 7;
		rst_value : integer := 0
		);
    port(
		stop						: out std_logic;
		clock, reset, enable	: in std_logic
		);
end entity;

architecture beh of counter is 

	signal	cnt	: std_logic_vector(bit_num -1 downto 0);
begin 

process(clock, reset, enable)

variable tmp: std_logic_vector(bit_num-1 downto 0);

begin

if (reset = '1') then 
tmp := std_logic_vector(to_unsigned(rst_value, bit_num));
elsif (clock'event and clock = '1') then
    if (enable = '1') then
	    tmp := tmp +'1';
	end if;

end if;

cnt <= tmp;

if(cnt = "101000") then
	stop <= '1';
end if;

end process; 

end architecture;
