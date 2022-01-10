library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
entity bist_controller is
	port(
		--suppongo abbia bisogno di clk and rst
		Clk                	: in  std_logic;	-- Clock
		Rst                	: in  std_logic;	-- Reset:Active-Low
		
		-- INPUTS
		normal_test		: in std_logic;	-- 0 for normal mode, 1 for test mode
		signature_check	: in std_logic;	-- receives result of comparison made by output data evaluator
		start_capture	: in std_logic;
		go_nogo       	: out std_logic;
		test_finished	: out std_logic;
		input_selection	: out std_logic; -- chooses between pi and lfsr
		count_enable	: out std_logic;
		--to_test_pattern		: out std_logic; -- dunno if needed
		--RECONFIGURE?? -- related to scan chains
		); 
end entity;

architecture beh of bist_controller is 
   
		
	type TYPE_STATE is (
		reset, normal, test, capture, go
	);
	signal CURRENT_STATE : TYPE_STATE := reset;
	signal NEXT_STATE : TYPE_STATE := normal;

begin

	P_OPC : process(Clk, Rst)		
	begin
		if Rst='0' then
	        	CURRENT_STATE <= reset;
		elsif (Clk ='1' and Clk'EVENT) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_OPC;
	
	P_NEXT_STATE : process(CURRENT_STATE, normal_test, start_capture)
	begin
		case CURRENT_STATE is
			when reset =>
				NEXT_STATE <= normal;
			when normal => 
				if normal_test = '0' then
					NEXT_STATE <= normal;
				else
					NEXT_STATE <= test;
				end if;
			when test => 
				if start_capture = '1' then
					NEXT_STATE <= capture;
				else
					NEXT_STATE <= normal;
				end if;
			when capture =>
				--IT DEPENDS ON HOW MANY CC NEEDED FOR CAPTURE
				NEXT_STATE <= go;
			when go =>
				NEXT_STATE <= normal;
			when others => 
				NEXT_STATE <= reset;

		end case;	
	end process P_NEXT_STATE;
	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		case CURRENT_STATE is	
			when reset => 
				go_nogo <= '0';
				test_finished <= '0';
				input_selection <= '0';
				count_enable <= '0';
			when normal => 
				go_nogo <= '0';
				test_finished <= '0';
				input_selection <= '0';
				count_enable <= '0';
			when test => 
				go_nogo <= '0';
				test_finished <= '0';
				input_selection <= '1';
				count_enable <= '1';
			when capture =>
				-- dunno, do stuff but don't know what
				go_nogo <= '0';
				test_finished <= '0';
				input_selection <= '0';
				count_enable <= '0';
			when go =>
				-- dunno, do stuff but don't know what
				-- idealmente: trasmetto il signature check e segnale per dire che ho finito
				go_nogo <= signature_check
				test_finished <= '1';
				input_selection <= '0';
				count_enable <= '0';
			when others => 
				go_nogo <= '0';
				test_finished <= '0';
				input_selection <= '0';
				count_enable <= '0';		
		end case; 	
	end process P_OUTPUTS;


end architecture;
