--------------------------------
-- Logic BIST block for RI5CY 
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_lbist is
	port(
		clk, rst_n, normal_test	: in std_logic;
		pis			: in std_logic_vector(266 downto 0);
		pos			: in std_logic_vector(239 downto 0);
		go_nogo			: out std_logic );
end riscv_lbist;

architecture structure of 

	-- BIST CONTROLLER
	component bist_controller
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
	end component;

	-- TEST COUNTER
	component test_counter is
		generic( 
			TEST_DURATION 	: integer := 1000;
			TEST_START	: integer := 4
		);
		port
		(	clk, en, rst_n			: in std_logic;
			test_started, test_finished	: out std_logic
		);
	end component;
	
	-- MULTIPLEXER
	component mux2to1_n
		generic(
			N : integer := 269
		);
		port(
			sel	: in std_logic;
			d0,d1	: in std_logic_vector(N-1 downto 0);
			dout	: out std_logic_vector(N-1 downto 0)
		);
	end component;

	-- TEST PATTERN GENERATOR
	component lfsr
		generic( 
			N : integer := 20;
			SEED : integer := 1;
		);
		port(
			clk, rst_n, en	: in std_logic;
			dout		: out std_logic_vector(N-1 downto 0)
		);
	end component;

	component phase_shifter
		generic(
			N_IN : integer := 24,
			N_OUT : integer := 267
		);
		port(
			din	: in std_logic_vector(N_IN-1 downto 0);
			dout	: out std_logic_vector(N_OUT-1 downto 0);
		);
	end component;

	-- OUTPUT EVALUATOR
	component output_evaluator 
		generic(
			N 			: integer := 239;
			EXPECTED_SIGNATURE 	: std_logic_vector(N-1 downto 0) := (others=>'0') 
		);
		port(
			clk, rst_n, en	: in std_logic;
			din		: in std_logic_vector(N-1 downto 0);
			dout		: out std_logic_vector(N downto 0);
			sign_ok			: out std_logic
		);
	end component;
	
begin
		
