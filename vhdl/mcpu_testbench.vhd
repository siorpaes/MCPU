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
	

  process                                              
	begin 
		  -- Send out 10 clock pulses before reset
		  for i in 0 to 10 loop
		  	clk <= '0';                                  
		  	WAIT FOR 10 ns;                              
		  	clk <= '1';                                  
		  	WAIT FOR 10 ns; 
		  end loop;
	      
	      -- Give reset            
	      clk <= '0';                                  
	      reset <= '1';                                
	      WAIT FOR 10 ns;
	      clk <= '0';                                  
	      reset <= '0';                              
	      WAIT FOR 10 ns;
	      clk <= '1';                                 
	      WAIT FOR 5 ns;         
	      reset <= '1';
	      WAIT FOR 5 ns;
	      
	      -- Clock                                              
	      loop                                           
	        clk <= '0';                                  
	        WAIT FOR 10 ns;                              
	        clk <= '1';                                  
	        WAIT FOR 10 ns;               -- clock.      
	      end loop;                        
	end process;
end architecture behaviour;
