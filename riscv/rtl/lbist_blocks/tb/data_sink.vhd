----------------------------------------------------------------
-- OUTPUT SAVER
-- Modified version of the "data_sink.vhd" example code.
-- Data coming from the output DIN are saved in the file
-- "results_vhdl.vhd" whenever the control signal VIN is high.
-- Each time a new value is saved, it is compared with the 
-- corresponding value coming from the C model.
--
-- Project: Lab 1.1
-- Authors: Group 32 (Chatrasi, Di Bella, Zangeneh)
----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN   : in std_logic_vector(7 downto 0);
	ERR	  : out std_logic);
end data_sink;

architecture bhv of data_sink is

begin  -- bhv
  	
  wrt_file: process (CLK, RST_n)
  
    file res_fp : text open WRITE_MODE is "results_vhd.txt"; --Output file to be written
	variable line_out : line;
	
	file fp_in : text open READ_MODE is "../../testing/resultsc.txt"; --Input file with results from C model
	variable line_in : line;
	variable x : integer;
    
  begin  -- process wrt_file
    if RST_n = '0' then                 -- asynchronous reset (active low)
      ERR <= '0';
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') then
		-- Write DIN in file
        write(line_out, conv_integer(signed(DIN)));
        writeline(res_fp, line_out);

		-- Read line from resultc.txt
		if not endfile(fp_in) then
			readline(fp_in, line_in);
			read(line_in, x);
			
			-- Comparing
			if (conv_signed(x,8) /= signed(DIN)) then
				ERR <= '1';
			end if;			
			
		end if;
      end if;
    end if;
  end process wrt_file;

end bhv;
