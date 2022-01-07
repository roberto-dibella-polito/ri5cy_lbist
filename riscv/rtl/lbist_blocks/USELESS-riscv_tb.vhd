library std;
use std.env.all;
use std.textio.all;
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity riscv_testbench is
end riscv_testbench;


architecture tb of riscv_testbench is

	component bist_controller
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
	end component;

    component riscv
	
		generic ( 	N_EXT_PERF_COUNTERS =  0,
					INSTR_RDATA_WIDTH   = 32,
					PULP_SECURE         =  0,
					N_PMP_ENTRIES       = 16,
					PULP_CLUSTER        =  1,
					FPU                 =  0,
					SHARED_FP           =  0,
					SHARED_DSP_MULT     =  0,
					SHARED_INT_DIV      =  0,
					SHARED_FP_DIVSQRT   =  0,
					WAPUTYPE            =  0,
					APU_NARGS_CPU       =  3,
					APU_WOP_CPU         =  6,
					APU_NDSFLAGS_CPU    = 15,
					APU_NUSFLAGS_CPU    =  5,
					SIMCHECKER          =  0);
		port ( 	
			-- QUESTI SONO INPUT E OUTPUT ESTERNI DEL RISC.
			-- E' GIUSTO TESTARE QUESTI?
			-- Clock and Reset
			clk_i : in std_logic,
			rst_ni : in std_logic,

			clock_en_i : in std_logic,    -- enable clock, otherwise it is gated
			test_en_i : in std_logic,     -- enable all clock gates for testing
			fregfile_disable_i : in std_logic,  -- disable the fp regfile, using int regfile instead
			
			-- INIZIO A CONSIDERARE VALORI TESTABILI DA QUI IN AVANTI VISTO CHE I PRECEDENTI SERVONO ANCHE PER TEST

			-- Core ID, Cluster ID and boot address are considered more or less static
			boot_addr_i : in std_logic_vector(31 downto 0),
			core_id_i : in std_logic_vector(3 downto 0),
			cluster_id_i : in std_logic_vector(5 downto 0),

			-- Instruction memory interface
			instr_req_o: out std_logic,
			instr_gnt_i : in std_logic,
			instr_rvalid_i: in std_logic,
			instr_addr_o : out std_logic_vector(31 downto 0),
			instr_rdata_i : in std_logic_vector(INSTR_RDATA_WIDTH-1 downto 0),

			-- Data memory interface
			data_req_o : out std_logic,
			data_gnt_i : in std_logic,
			data_rvalid_i : in std_logic,
			data_we_o : out std_logic,
			data_be_o : out std_logic_vector(3 downto 0),
			data_addr_o : out std_logic_vector(31 downto 0),
			data_wdata_o : out std_logic_vector(31 downto 0),
			data_rdata_i : out std_logic_vector(31 downto 0),
			-- apu-interconnect
			-- handshake signals
			apu_master_req_o : out std_logic,
			apu_master_ready_o : out std_logic,
			apu_master_gnt_i : in std_logic,
			-- request channel
			apu_master_operands_o_2 : out std_logic_vector (31 downto 0),
			apu_master_operands_o_1 : out std_logic_vector (31 downto 0);
			apu_master_operands_o_0 : out std_logic_vector (31 downto 0);
			apu_master_op_o : out std_logic_vector(APU_WOP_CPU-1 downto 0),
			apu_master_type_o : out std_logic_vector(WAPUTYPE-1 downto 0),
			apu_master_flags_o : out std_logic_vector(APU_NDSFLAGS_CPU-1 downto 0),
			-- response channel
			apu_master_valid_i : in std_logic,
			apu_master_result_i : in std_logic_vector(31 downto 0),
			apu_master_flags_i : in std_logic_vector(APU_NUSFLAGS_CPU-1 downto 0),

			-- Interrupt inputs
			irq_i : in std_logic,                 --level sensitive IR lines
			irq_id_i : in std_logic_vector(4 downto 0),
			irq_ack_o : out std_logic,
			irq_id_o : out std_logic_vector(4 downto 0),
			irq_sec_i : in std_logic,

			sec_lvl_o : out std_logic,

			-- Debug Interface
			debug_req_i : in std_logic,
			debug_gnt_o : out std_logic,
			debug_rvalid_o : out std_logic,
			debug_addr_i : in std_logic_vector(14 downto 0),
			debug_we_i : in std_logic,
			debug_wdata_i : in std_logic_vector (31 downto 0),
			debug_rdata_o : out std_logic_vector(31 downto 0),
			debug_halted_o : out std_logic,
			debug_halt_i : in std_logic,
			debug_resume_i : in std_logic,

			-- CPU Control Signals
			fetch_enable_i : in std_logic,
			core_busy_o : out std_logic,

			--ext_perf_counters_i : in std_logic_vector(N_EXT_PERF_COUNTERS-1 downto 0)
			)
    end component;
	
	

    component lfsr
        generic (N    : integer;
                 SEED : std_logic_vector(N downto 0));
        port (clk   : in std_logic;
              reset : in std_logic;
              q     : out std_logic_vector(N downto 0));
    end component;

	constant clock_t1      : time := 50 ns;
	constant clock_t2      : time := 30 ns;
	constant clock_t3      : time := 20 ns;
	constant apply_offset  : time := 0 ns;
	constant apply_period  : time := 100 ns;
	constant strobe_offset : time := 40 ns;
	constant strobe_period : time := 100 ns;


	signal tester_clock : std_logic := '0';

    signal lfsr_out   : std_logic_vector(174 downto 0);
    signal lfsr_clock : std_logic := '0';
    signal lfsr_reset : std_logic;
    signal dut_clock  : std_logic := '0';
    signal dut_reset  : std_logic;

    -- signature
    --signal signature      : std_logic_vector(296 downto 0);	--DIPENDONO DAGLI SCANOUT

begin

    stimuli : lfsr
    generic map (N => 175, -- SPERO DI AVER CONTATO GIUSTO
                 SEED => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001")
    port map (clk => lfsr_clock,
              reset => lfsr_reset,
              q => lfsr_out);

    dut : riscv
	generic map ( 	N_EXT_PERF_COUNTERS =>  0,
				INSTR_RDATA_WIDTH   => 32,
				PULP_SECURE         =>  0,
				N_PMP_ENTRIES       => 16,
				PULP_CLUSTER        =>  1,
				FPU                 =>  0,
				SHARED_FP           =>  0,
				SHARED_DSP_MULT     =>  0,
				SHARED_INT_DIV      =>  0,
				SHARED_FP_DIVSQRT   =>  0,
				WAPUTYPE            =>  0,
				APU_NARGS_CPU       =>  3,
				APU_WOP_CPU         =>  6,
				APU_NDSFLAGS_CPU    => 15,
				APU_NUSFLAGS_CPU    =>  5,
				SIMCHECKER          =>  0);
		port map ( 	
			-- Clock and Reset
			clk_i => dut_clock,
			rst_ni => dut_reset,

			--SETTO A 1. NON SO SE VADANO FATTI SEGNALI APPOSITI
			clock_en_i => '1',    -- enable clock, otherwise it is gated
			test_en_i => '1',     -- enable all clock gates for testing
			fregfile_disable_i => '1',  -- disable the fp regfile, using int regfile instead
			
			-- INIZIO A CONSIDERARE VALORI TESTABILI DA QUI IN AVANTI VISTO CHE I PRECEDENTI SERVONO ANCHE PER TEST

			-- Core ID, Cluster ID and boot address are considered more or less static
			boot_addr_i => lfsr_out(31 downto 0),
			core_id_i => lfsr_out(35 downto 32),
			cluster_id_i => lfsr_out(40 downto 35),

			-- Instruction memory interface
			instr_req_o : out std_logic,
			instr_gnt_i => lfsr_out(41),
			instr_rvalid_i=> lfsr_out(42),
			instr_addr_o : out std_logic_vector(31 downto 0),
			instr_rdata_i => lfsr_out(74 downto 43),

			-- Data memory interface
			data_req_o : out std_logic,
			data_gnt_i => lfsr_out(75),
			data_rvalid_i => lfsr_out(76),
			data_we_o : out std_logic,
			data_be_o : out std_logic_vector(3 downto 0),
			data_addr_o : out std_logic_vector(31 downto 0),
			data_wdata_o : out std_logic_vector(31 downto 0),
			data_rdata_i : out std_logic_vector(31 downto 0),
			-- apu-interconnect
			-- handshake signals
			apu_master_req_o : out std_logic,
			apu_master_ready_o : out std_logic,
			apu_master_gnt_i => lfsr_out(77),
			-- request channel
			apu_master_operands_o_2 : out std_logic_vector (31 downto 0),
			apu_master_operands_o_1 : out std_logic_vector (31 downto 0);
			apu_master_operands_o_0 : out std_logic_vector (31 downto 0);
			apu_master_op_o : out std_logic_vector(APU_WOP_CPU-1 downto 0),
			apu_master_type_o : out std_logic_vector(WAPUTYPE-1 downto 0),
			apu_master_flags_o : out std_logic_vector(APU_NDSFLAGS_CPU-1 downto 0),
			-- response channel
			apu_master_valid_i => lfsr_out(78),
			apu_master_result_i => lfsr_out(110 downto 79),
			apu_master_flags_i => lfsr_out(115 downto 111),

			-- Interrupt inputs
			irq_i => lfsr_out(116),                 --level sensitive IR lines
			irq_id_i => lfsr_out(121 downto 117),
			irq_ack_o : out std_logic,
			irq_id_o : out std_logic_vector(4 downto 0),
			irq_sec_i => lfsr_out(122),

			sec_lvl_o : out std_logic,

			-- Debug Interface
			debug_req_i => lfsr_out(123),
			debug_gnt_o : out std_logic,
			debug_rvalid_o : out std_logic,
			debug_addr_i => lfsr_out(138 downto 124),
			debug_we_i => lfsr_out(139),
			debug_wdata_i => lfsr_out (171 downto 140),
			debug_rdata_o : out std_logic_vector(31 downto 0),
			debug_halted_o : out std_logic,
			debug_halt_i => lfsr_out(172),
			debug_resume_i => lfsr_out(173),

			-- CPU Control Signals
			fetch_enable_i => lfsr_out(174),
			core_busy_o : out std_logic,

			--ext_perf_counters_i : in std_logic_vector(N_EXT_PERF_COUNTERS-1 downto 0)
			);

-- ***** CLOCK/RESET ***********************************

	clock_generation : process
	begin
		loop
			wait for clock_t1; tester_clock <= '1';
			wait for clock_t2; tester_clock <= '0';
			wait for clock_t3;
		end loop;
	end process;

-- dut  ___/----\____ ___/----\____ ___/----\____ ___
-- lfsr /----\____ ___/----\____ ___/----\____ ___/--

    dut_clock <= transport tester_clock after apply_period;
    lfsr_clock <= transport tester_clock after apply_period - clock_t1 + apply_offset;

    dut_reset <= '0', '1' after clock_t1, '0' after clock_t1 + clock_t2;
    lfsr_reset <= '1', '0' after clock_t1 + clock_t2;



-- ***** MONITOR **********
/*
    monitor : process(nl, nloss, speaker)
		function vec2str( input : std_logic_vector ) return string is
			variable rline : line;
		begin
			write( rline, input );
			return rline.all;
		end vec2str;
    begin
        std.textio.write(std.textio.output, "nl:" & vec2str(nl) & " nloss:" & std_logic'image(nloss) & " speaker:" & std_logic'image(speaker) & LF);
    end process;
*/
end tb;



/*
#(
  parameter N_EXT_PERF_COUNTERS =  0,
  parameter INSTR_RDATA_WIDTH   = 32,
  parameter PULP_SECURE         =  0,
  parameter N_PMP_ENTRIES       = 16,
  parameter PULP_CLUSTER        =  1,
  parameter FPU                 =  0,
  parameter SHARED_FP           =  0,
  parameter SHARED_DSP_MULT     =  0,
  parameter SHARED_INT_DIV      =  0,
  parameter SHARED_FP_DIVSQRT   =  0,
  parameter WAPUTYPE            =  0,
  parameter APU_NARGS_CPU       =  3,
  parameter APU_WOP_CPU         =  6,
  parameter APU_NDSFLAGS_CPU    = 15,
  parameter APU_NUSFLAGS_CPU    =  5,
  parameter SIMCHECKER          =  0
)
(
  // Clock and Reset
  input  logic        clk_i,
  input  logic        rst_ni,

  input  logic        clock_en_i,    // enable clock, otherwise it is gated
  input  logic        test_en_i,     // enable all clock gates for testing

  input  logic        fregfile_disable_i,  // disable the fp regfile, using int regfile instead

  // Core ID, Cluster ID and boot address are considered more or less static
  input  logic [31:0] boot_addr_i,
  input  logic [ 3:0] core_id_i,
  input  logic [ 5:0] cluster_id_i,

  // Instruction memory interface
  output logic                         instr_req_o,
  input  logic                         instr_gnt_i,
  input  logic                         instr_rvalid_i,
  output logic                  [31:0] instr_addr_o,
  input  logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_i,

  // Data memory interface
  output logic        data_req_o,
  input  logic        data_gnt_i,
  input  logic        data_rvalid_i,
  output logic        data_we_o,
  output logic [3:0]  data_be_o,
  output logic [31:0] data_addr_o,
  output logic [31:0] data_wdata_o,
  input  logic [31:0] data_rdata_i,
  // apu-interconnect
  // handshake signals
  output logic                       apu_master_req_o,
  output logic                       apu_master_ready_o,
                          apu_master_gnt_i,
  // request channel
  output logic [31:0]                 apu_master_operands_o [APU_NARGS_CPU-1:0],
  output logic [APU_WOP_CPU-1:0]      apu_master_op_o,
  output logic [WAPUTYPE-1:0]         apu_master_type_o,
  output logic [APU_NDSFLAGS_CPU-1:0] apu_master_flags_o,
  // response channel
  input logic                        apu_master_valid_i,
  input logic [31:0]                 apu_master_result_i,
  input logic [APU_NUSFLAGS_CPU-1:0] apu_master_flags_i,

  // Interrupt inputs
  input  logic        irq_i,                 // level sensitive IR lines
  input  logic [4:0]  irq_id_i,
  output logic        irq_ack_o,
  output logic [4:0]  irq_id_o,
  input  logic        irq_sec_i,

  output logic        sec_lvl_o,

  // Debug Interface
  input  logic        debug_req_i,
  output logic        debug_gnt_o,
  output logic        debug_rvalid_o,
  input  logic [14:0] debug_addr_i,
  input  logic        debug_we_i,
  input  logic [31:0] debug_wdata_i,
  output logic [31:0] debug_rdata_o,
  output logic        debug_halted_o,
  input  logic        debug_halt_i,
  input  logic        debug_resume_i,

  // CPU Control Signals
  input  logic        fetch_enable_i,
  output logic        core_busy_o,

  input  logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i
);
*/

 /*riscv_wrapper
    #(parameter INSTR_RDATA_WIDTH = 128,
      parameter RAM_ADDR_WIDTH = 20,
      parameter BOOT_ADDR = 'h80,
      parameter PULP_SECURE = 1)
    (input logic         clk_i,
     input logic         rst_ni,

     input logic         fetch_enable_i,
     output logic        tests_passed_o,
     output logic        tests_failed_o,
     output logic [31:0] exit_value_o,
     output logic        exit_valid_o);