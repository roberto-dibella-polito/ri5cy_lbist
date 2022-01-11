

library ieee;
use ieee.std_logic_1164.all;

entity riscv_core is
	port(
		-- Core I/O
		
		boot_addr_i 		: in std_logic_vector(31 downto 0);
  		core_id_i		: in std_logic_vector(3 downto 0);
  		cluster_id_i 		: in std_logic_vector(6 downto 0);	
  		instr_addr_o		: out std_logic_vector(31 downto 0);
  		instr_rdata_i		: in std_logic_vector(127 downto 0);
  		data_be_o		: out std_logic_vector(3 downto 0);
  		data_addr_o		: out std_logic_vector(31 downto 0);
  		data_wdata_o		: out std_logic_vector(31 downto 0);
  		data_rdata_i		: in std_logic_vector(31 downto 0);
  		apu_master_operands_o	: out std_logic_vector(95 downto 0);
 		apu_master_op_o		: out std_logic_vector(5 downto 0);
  		apu_master_type_o	: out std_logic_vector(1 to 2);
  		apu_master_flags_o	: out std_logic_vector(14 downto 0);
  		apu_master_result_i	: in std_logic_vector(31 downto 0);
  		apu_master_flags_i	: in std_logic_vector(4 downto 0);
  		irq_id_i		: in std_logic_vector(4 downto 0);
  		irq_id_o		: out std_logic_vector(4 downto 0);
  		ext_perf_counters_i	: in std_logic_vector(1 to 2);
 	 	
		clk_i, rst_ni, clock_en_i, test_mode, fetch_enable_i			: in std_logic;
		
		-- 1-bit primary inputs
		fregfile_disable_i, instr_gnt_i, instr_rvalid_i, data_gnt_i, data_rvalid_i	: in std_logic;
		apu_master_gnt_i, apu_master_valid_i, irq_i, irq_sec_i, debug_req_i		: in std_logic;
	 	
		-- 1-bit primary outputs
		instr_req_o, data_req_o, data_we_o, apu_master_req_o	: out std_logic;
         	apu_master_ready_o, irq_ack_o, sec_lvl_o, core_busy_o	: out std_logic;
		
		go_nogo_o : out std_logic
	);
end riscv_core;

architecture structure of riscv_core is

	component riscv_core_0_128_1_16_1_1_0_0_0_0_0_0_0_0_0_3_6_15_5_1a110800
		port( 
			boot_addr_i 		: in std_logic_vector(31 downto 0);
  			core_id_i		: in std_logic_vector(3 downto 0);
  			cluster_id_i 		: in std_logic_vector(6 downto 0);	
  			instr_addr_o		: out std_logic_vector(31 downto 0);
  			instr_rdata_i		: in std_logic_vector(127 downto 0);
  			data_be_o		: out std_logic_vector(3 downto 0);
  			data_addr_o		: out std_logic_vector(31 downto 0);
  			data_wdata_o		: out std_logic_vector(31 downto 0);
  			data_rdata_i		: in std_logic_vector(31 downto 0);
  			apu_master_operands_o	: out std_logic_vector(95 downto 0);
 			apu_master_op_o		: out std_logic_vector(5 downto 0);
  			apu_master_type_o	: out std_logic_vector(1 to 2);
  			apu_master_flags_o	: out std_logic_vector(14 downto 0);
  			apu_master_result_i	: in std_logic_vector(31 downto 0);
  			apu_master_flags_i	: in std_logic_vector(4 downto 0);
  			irq_id_i		: in std_logic_vector(4 downto 0);
  			irq_id_o		: out std_logic_vector(4 downto 0);
  			ext_perf_counters_i	: in std_logic_vector(1 to 2);
			
			-- Signals for the top-level entity
 	 		clk_i, rst_ni, clock_en_i, test_en_i, test_mode, fetch_enable_i			: in std_logic;
			
			-- 1-bit primary inputs
			fregfile_disable_i, instr_gnt_i, instr_rvalid_i, data_gnt_i, data_rvalid_i	: in std_logic;
			apu_master_gnt_i, apu_master_valid_i, irq_i, irq_sec_i, debug_req_i		: in std_logic;
         		
			-- Input scan ports
			test_si1, test_si2, test_si3, test_si4, test_si5, test_si6, test_si7 		: in std_logic;
         		
			-- 1-bit primary outputs
	 		instr_req_o, data_req_o, data_we_o, apu_master_req_o	: out std_logic;
         		apu_master_ready_o, irq_ack_o, sec_lvl_o, core_busy_o	: out std_logic; 
			
			-- Output scan ports						
			test_so1, test_so2, test_so3, test_so4, test_so5, test_so6, test_so7	: out std_logic
		);
	end component;

	component  riscv_lbist is
		port(
			clk, rst_n, normal_test	: in std_logic;
			pis			: in std_logic_vector(266 downto 0);
			pos			: in std_logic_vector(238 downto 0);
			pi_selected		: out std_logic_vector(266 downto 0);
			go_nogo			: out std_logic );
	end component;

	-- Internal signals
	signal pis_i, pis_selected_i	: std_logic_vector(266 downto 0);
	signal pos_i			: std_logic_vector(238 downto 0);
	signal test_select		: std_logic;

begin

	lbist: riscv_lbist port map(
		clk 		=> clk_i,
		rst_n		=> rst_ni,
		normal_test	=> test_select,
		pis		=> pis_i,
		pos		=> pos_i,
		pi_selected	=> pis_selected_i
		go_nogo		=> go_nogo_o	);
	
	-- Connect together all primary inputs into pis_i
	
	pis_i(31 downto 0) 	<= boot_addr_i;
  	pis_i(35 downto 32)	<= core_id_i;
  	pis_i(42 downto 36)	<= cluster_id_i;	
  	pis_i(170 downto 43)	<= instr_rdata_i;
  	pis_i(202 downto 171)	<= data_rdata_i;
  	pis_i(234 downto 203)	<= apu_master_result_i;
  	pis_i(239 downto 235)	<= apu_master_flags_i;
  	pis_i(244 downto 240) 	<= irq_id_i;
  	pis_i(245 to 247)	<= ext_perf_counters_i;
	pis_i(256 downto 247)	<= fregfile_disable_i & instr_gnt_i & instr_rvalid_i & data_gnt_i & data_rvalid_i & apu_master_gnt_i & apu_master_valid_i & irq_i & irq_sec_i & debug_req_i;
	
	-- This signals will enter the mux of the LBIST and eventually coming out in the same position from pis_selected
	--> Reconnect everything to the DUT


	-- Connect together all primary outputs into pos_i
	
	
	-- connect the selected_pis in the same way of the input + add the scan signals


end structure;
