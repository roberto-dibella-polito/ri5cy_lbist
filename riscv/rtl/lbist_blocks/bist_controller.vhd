library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
entity bist_controller is
	port(
		clk                	: in  std_logic;	-- Clock
		rst                	: in  std_logic;	-- Reset:Active-Low
			
		-- INPUTS
		normal_test		: in std_logic;	-- 0 for normal mode, 1 for test mode
		signature_check		: in std_logic;	-- receives result of comparison made by output data evaluator
		test_finished		: in std_logic;
		test_started		: in std_logic;
		
		test_mux_sel		: out std_logic;	-- primary input mux selector
		out_eval_en		: out std_logic;	-- output evaluator enable
		tpg_en			: out std_logic;	-- Test Pattern Generator enable
		count_enable		: out std_logic;	-- enables the Test Counter
	
		go_nogo			: out std_logic;
	); 
end entity;

architecture bhv of bist_controller is 
   
	type TYPE_STATE is (
		RESET, IDLE, START_TEST, TEST, EVALUATION
	);
	signal CURRENT_STATE : TYPE_STATE := RESET;
	signal NEXT_STATE : TYPE_STATE := IDLE;

begin

	go_nogo <= signature_check;	

	P_OPC : process(clk, rst)		
	begin
		if Rst='0' then
	        	CURRENT_STATE <= reset;
		elsif (Clk ='1' and Clk'EVENT) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_OPC;
	
	P_NEXT_STATE : process(CURRENT_STATE, normal_test, test_started, test_finished)
	begin
		case CURRENT_STATE is
			when RESET =>
				NEXT_STATE <= IDLE;
			
			when IDLE => 
				if normal_test = '0' then
					NEXT_STATE <= IDLE;
				else
					NEXT_STATE <= START_TEST;
				end if;
			
			when START_TEST => 
				if test_started = '1' then
					NEXT_STATE <= TEST;
				else
					NEXT_STATE <= START_TEST;
				end if;
			
			when TEST =>
				if test_finished = '1' then
					NEXT_STATE <= EVALUATION;
				else
					NEXT_STATE <= TEST;

			when EVALUATION =>
				NEXT_STATE <= IDLE;
			
			when others => 
				NEXT_STATE <= RESET;

		end case;	
	end process P_NEXT_STATE;
	
	P_OUTPUTS: process(CURRENT_STATE)
	begin
		case CURRENT_STATE is	
			when RESET => 
				test_mux_sel	<= '0'; 
				out_eval_en	<= '0';
				tpg_en		<= '0';
				count_enable	<= '0';

			when IDLE => 
				test_mux_sel	<= '0'; 
				out_eval_en	<= '0';
				tpg_en		<= '0';
				count_enable	<= '0';

			when START_TEST => 
				test_mux_sel	<= '1'; 
				out_eval_en	<= '0';
				tpg_en		<= '1';
				count_enable	<= '1';

			when TEST =>
				test_mux_sel	<= '1'; 
				out_eval_en	<= '1';
				tpg_en		<= '1';
				count_enable	<= '1';

			when EVALUATION =>
				test_mux_sel	<= '0'; 
				out_eval_en	<= '0';
				tpg_en		<= '0';
				count_enable	<= '0';

			when others => 
				test_mux_sel	<= '0'; 
				out_eval_en	<= '0';
				tpg_en		<= '0';
				count_enable	<= '0';
		end case; 	
	end process P_OUTPUTS;
end architecture;
