-- Complete reimplementation of Minimal 8 Bit CPU
-- Uses fully synchronous flow-through SRAM
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mcpu is
	port (
		clock    :  in std_logic;
		reset    :  in std_logic;
		dataout  :  out std_logic_vector(7 downto 0);
		datain   :  in std_logic_vector(7 downto 0);
		address  :  out std_logic_vector(5 downto 0);
		we       :  out std_logic
		);

	--  Preserve from synthesis optimization
	--  attribute dont_touch : string;
	--	attribute dont_touch of mcpu : entity is "true";
end;

architecture rtl of mcpu is
	-- Preserve from synthesis optimization
	-- attribute dont_touch of rtl : architecture is "true";
	
	-- As above for Lattice
	attribute syn_hier : string;
	attribute syn_hier of rtl: architecture is "hard";

	signal delay          : unsigned (31 downto 0) := (others => '0');
	signal addr       :	std_logic_vector(5 downto 0) := (others => '0');
	signal accumulator:	std_logic_vector(8 downto 0) := (others => '0');
	signal pc:         	std_logic_vector(5 downto 0) := (others => '0');
	signal opcode:     	std_logic_vector(1 downto 0) := (others => '0');
	signal operand:     std_logic_vector(7 downto 0) := (others => '0');

	type state is (F0, F1, F2, EX);
	signal mcpustate : state := F0;

begin
	process(clock, reset)
	begin
	if (reset = '0') then
		addr	<= (others => '0');
		accumulator <= (others => '0');
		pc   <= (others => '0');
		mcpustate <= F0;
		we <= '1';
	elsif rising_edge(clock) then
		delay <= delay + 1;

		if(delay > x"8") then
			case mcpustate is
				when F0 =>
					we <= '1';
					addr <= pc;
					mcpustate <= F1;
				when F1 =>
					opcode <= datain(7 downto 6);   -- Get opcode
					operand <= "00" & datain(5 downto 0);
					if(datain (7) = '0') then       -- If dealing with NOR/ADD
						addr <= datain(5 downto 0); -- Fetch data from memory
						mcpustate <= F2;
					else
						mcpustate <= EX;
					end if;
				when F2 =>
					operand <= datain;
					mcpustate <= EX;
				when EX =>
					if (opcode = "00") then -- NOR
						accumulator(7 downto 0) <= accumulator(7 downto 0) nor operand;
						pc <= pc + 1;
						mcpustate <= F0;
					elsif (opcode = "01") then -- ADD
						accumulator <= accumulator + operand;
						pc <= pc + 1;
						mcpustate <= F0;
					elsif (opcode = "10") then --STA
						addr <= operand(5 downto 0);
						we <= '0';
						pc <= pc + 1;
						mcpustate <= F0;
					else -- JCC
						-- Branch taken
						if (accumulator(8) = '0') then
							pc <= operand(5 downto 0);
						else
							-- Branch not taken
							accumulator(8) <= '0';
							pc <= pc + 1;
						end if;
						mcpustate <= F0;
					end if;
			 	when others =>
					we <= '1';
					mcpustate <= F0;
			end case;
		end if;
	end if;
end process;

address <= addr;
dataout <= accumulator(7 downto 0);

end rtl;
