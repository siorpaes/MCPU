library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_testbench is
end entity mcpu_testbench;

architecture behaviour of mcpu_testbench is

signal r_clk        : std_logic := '0';
signal r_reset      : std_logic := '0';

begin
	MCPUTOP: entity work.mcpu_toplevel
	port map(
	clk => r_clk,
	reset => r_reset
	);
	

  process                                              
	begin                                                
	      r_clk <= '0';                                    
	      r_reset <= '1';                                  
	      WAIT FOR 50 ns;                                
	      r_clk <= '0';                                    
	      r_reset <= '0';                                  
	      WAIT FOR 50 ns;                                
	      r_clk <= '1';                                    
	      WAIT FOR 25 ns;                                
	      r_reset <= '1';                                  
	      WAIT FOR 25 ns;                                
	                                                     
	      loop                                           
	        r_clk <= '0';                                  
	        WAIT FOR 50 ns;                              
	        r_clk <= '1';                                  
	        WAIT FOR 50 ns;               -- clock.      
	      end loop;                        
	end process;
end architecture behaviour;
