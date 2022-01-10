library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity test_counter is
	generic( 
		TEST_DURATION 	: integer := 1000;
		TEST_START		: integer := 4
	);
	port
	(	clk, en, rst_n				: in std_logic;
		test_started, test_finished	: out std_logic
	);
end entity;

architecture structure of test_counter is

	component counter
		generic(
			N			: integer := 7;
			RST_VALUE	: integer := 0
		);
		port(
			clk,rst_n,en	: in std_logic;
			count			: out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal cnt_i : std_logic_vector(23 downto 0);

begin
	
	counter_1: counter generic map ( N => 24, RST_VALUE => 0 ) port map
	(	clk => clk,
		en 	=> en,
		rst_n	=> rst_n,
		count	=> cnt_i	);
	
	compare: process(cnt_i)
	begin
		if ( cnt_i = std_logic_vector(to_unsigned(TEST_DURATION,24)) ) then	
			test_finished <= '1';
		else
			test_finished <= '0';
		end if;

		if ( cnt_i = std_logic_vector(to_unsigned(TEST_START,24)) ) then	
			test_started <= '1';
		else
			test_started <= '0';
		end if;
	end process;
end structure;	 
