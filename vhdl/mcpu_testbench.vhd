library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_testbench is
end entity mcpu_testbench;

architecture behaviour of mcpu_testbench is

signal clk        : std_logic := '0';
signal reset      : std_logic := '0';

begin
	MCPUTOP: entity work.mcpu_toplevel
	port map(
	clk => clk,
	reset => reset
	);
	
	-- Clock
	process                                              
	begin      
	      loop                                           
	        clk <= '0';                                  
	        WAIT FOR 10 ns;                              
	        clk <= '1';                                  
	        WAIT FOR 10 ns;
	      end loop;                        
	end process;
	
	-- Reset
	process
	begin
		reset <= '1';
		wait for 1ms;
		reset <= '0';
		wait for 2ms;
		reset <= '1';
		wait;
	end process;	
	
end architecture behaviour;
