-- Complete reimplementation of Minimal 8 Bit CPU                              
-- david.siorpaes@gmail.com                                                 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mcpu is
	port (
		clock    :  in std_logic;
		reset    :  in std_logic;
		dataout  :	out	std_logic_vector(7 downto 0);
		datain   :  in  std_logic_vector(7 downto 0);
		address  :	out	std_logic_vector(5 downto 0);
		we       :  out	std_logic
		);
end;

architecture rtl of mcpu is
	signal addr       :	std_logic_vector(5 downto 0);
	signal accumulator:	std_logic_vector(8 downto 0);
	signal pc:         	std_logic_vector(5 downto 0);
	signal opcode:     	std_logic_vector(1 downto 0);
	
	type state is (F1, F2, EX);
	signal mcpustate : state;

begin
	process(clock, reset)
	begin
	if (reset = '0') then 
		addr	<= (others => '0');	-- start execution at memory location 0 
		accumulator <= (others => '0');
		pc   <= (others => '0');
		mcpustate <= F1;
		we <= '0';
	elsif rising_edge(clock) then
		case mcpustate is
			when F1 =>
				we <= '0';
				addr <= pc;
				mcpustate <= F2;
			when F2 =>
				opcode <= datain(7 downto 6); -- Get opcode
				addr <= datain(5 downto 0);   -- Fetch instruction operand. Data will be ready in EX
				mcpustate <= EX;
			when EX =>
				if (opcode = "00") then -- NOR
					accumulator(7 downto 0) <= accumulator(7 downto 0) nor datain;
					pc <= pc + 1;
					mcpustate <= F1;
				elsif (opcode = "01") then -- ADD
					accumulator <= accumulator + datain;
					pc <= pc + 1;
					mcpustate <= F1;
				elsif (opcode = "10") then --STA
					dataout <= accumulator(7 downto 0);
					we <= '1';
					pc <= pc + 1;
					mcpustate <= F1;
				else -- JCC
					if (accumulator(8) = '0') then
						pc <= addr;
					else
						accumulator(8) <= '0';
						pc <= pc + 1;
					end if;
					mcpustate <= F1;
				end if;
		end case;
	end if;
end process;

address <= addr;

end rtl;

