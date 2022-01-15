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
		pos			: in std_logic_vector(238 downto 0);
		pi_selected		: out std_logic_vector(266 downto 0);
		go_nogo			: out std_logic;
		test_over		: out std_logic;
		testing			: out std_logic);
end riscv_lbist;

architecture structure of riscv_lbist is 

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
			
			--OUTPUTS
			test_mux_sel		: out std_logic;	-- primary input mux selector
			out_eval_en		: out std_logic;	-- output evaluator enable
			tpg_en			: out std_logic;	-- Test Pattern Generator enable
			count_enable		: out std_logic;	-- enables the Test Counter
			rst_test_counter_n	: out std_logic;
			rst_tpg_n		: out std_logic;
			rst_out_eval_n		: out std_logic;
			
			test_over		: out std_logic;
			go_nogo			: out std_logic;
			testing			: out std_logic
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
	--component lfsr
	--	generic( 
	--		N : integer := 20;
	--		SEED : integer := 1
	--	);
	--	port(
	--		clk, rst_n, en	: in std_logic;
	--		dout		: out std_logic_vector(N-1 downto 0)
	--	);
	--end component;

	--component phase_shifter
	--	generic(
	--		N_IN : integer := 24;
	--		N_OUT : integer := 267
	--	);
	--	port(
	--		din	: in std_logic_vector(N_IN-1 downto 0);
	--		dout	: out std_logic_vector(N_OUT-1 downto 0)
	--	);
	--end component;

	--module tpg
	--(     input wire clk, en, rst_n,
        --	output wire [266:0] dout    
	--	 );
	component tpg
        	port(
                	clk, rst_n, en  : in std_logic;
                	dout            : out std_logic_vector(266 downto 0)
        	);
	end component;

	-- OUTPUT EVALUATOR
	component output_evaluator 
		generic(
			N 			: integer := 239
			--EXPECTED_SIGNATURE 	: std_logic_vector(N-1 downto 0) := (others=>'0') 
		);
		port(
			clk, rst_n, en	: in std_logic;
			din		: in std_logic_vector(N-1 downto 0);
			--dout		: out std_logic_vector(N downto 0);
			sign_ok		: out std_logic
		);
	end component;

	-- CONNECTION SIGNALS
	signal clk_i 	: std_logic;
	
	-- Data
	--signal lfsr_patterns_i		: std_logic_vector(23 downto 0);
	signal test_patterns_i		: std_logic_vector(266 downto 0);
	signal signature_i		: std_logic_vector(239 downto 0);
	
	-- LBIST controls
	-- Test Counter
	signal test_started_i		: std_logic; 
	signal test_finished_i		: std_logic;
	signal signature_check_i	: std_logic;
	signal rst_count_i		: std_logic;
	signal count_en_i		: std_logic;
	
	-- Test Pattern selection & generation
	signal pi_test_sel_i		: std_logic;
	signal tpg_en_i			: std_logic;
	signal tpg_rst_n_i		: std_logic;
	
	-- Output evaluation
	signal out_eval_en_i		: std_logic;
	signal signature_rst_i		: std_logic;
	signal sign_ok_i		: std_logic;
begin

	clk_i <= clk;

	-- Multiplexer instantiation
	mux: mux2to1_n generic map( N => 267 ) port map(
		sel	=> pi_test_sel_i,
		d0	=> pis,
		d1	=> test_patterns_i,
		dout	=> pi_selected 
	);		
	
	-- LFSR
	--lfsr_i: lfsr generic map( N => 24, SEED => 1) port map(
	--	clk	=> clk_i,
	--	rst_n	=> tpg_rst_n_i,
	--	en	=> tpg_en_i,
	--		dout	=> lfsr_patterns_i
	--);
	
	-- Phase Shifter
	--phsh: phase_shifter generic map( N_IN => 24, N_OUT => 267 ) port map (
	--	din	=> lfsr_patterns_i,
	--	dout	=> test_patterns_i
	--);

	-- TEST PATTERN GENERATOR
	patterns_generator: tpg port map(
		clk	=> clk_i, 
		rst_n	=> tpg_rst_n_i,
		en	=> tpg_en_i,
		dout	=> test_patterns_i );

	-- BIST CONTROLLER
	controller: bist_controller port map(
		clk	=> clk_i,
		rst	=> rst_n,
		normal_test 	=> normal_test,
		test_over	=> test_over,
		go_nogo		=> go_nogo,
		
		signature_check		=> signature_check_i,
		test_finished		=> test_finished_i,
		test_started		=> test_started_i,
		
		-- OUTPUTS
		test_mux_sel		=> pi_test_sel_i,
		out_eval_en		=> out_eval_en_i,
		tpg_en			=> tpg_en_i,
		count_enable		=> count_en_i,
		rst_test_counter_n	=> rst_count_i,
		rst_tpg_n		=> tpg_rst_n_i,
		rst_out_eval_n		=> signature_rst_i,
		testing			=> testing	);
		
	
	-- TEST COUNTER
	test_cnt: test_counter generic map( TEST_DURATION => 16#002B5C#, TEST_START => 98 ) port map (
		clk		=> clk_i,
		rst_n		=> rst_count_i,
		en		=> count_en_i,
		test_started	=> test_started_i,
		test_finished	=> test_finished_i	);

	-- OUTPUT EVALUATOR
	out_eval: output_evaluator generic map( N => 239 ) port map(
		clk	=> clk_i,
		rst_n	=> signature_rst_i,
		en	=> out_eval_en_i,
		din	=> pos,
		--dout	=> signature_i,
		sign_ok => signature_check_i
	);
end structure;
