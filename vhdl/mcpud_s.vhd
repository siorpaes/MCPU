-- Complete reimplementation of Minimal 8 Bit CPU
-- Uses fully synchronous flow-through SRAM
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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
	--  attribute dont_touch of mcpu : entity is "true";
end;

architecture rtl of mcpu is
	-- Preserve from synthesis optimization
	-- attribute dont_touch of rtl : architecture is "true";
	
	-- As above for Lattice
	-- attribute syn_hier : string;
	-- attribute syn_hier of rtl: architecture is "hard";

	signal addr       :	std_logic_vector(5 downto 0) := (others => '0');
	signal accumulator:	std_logic_vector(8 downto 0) := (others => '0');
	signal pc:         	std_logic_vector(5 downto 0) := (others => '0');
	signal opcode:     	std_logic_vector(1 downto 0) := (others => '0');
	signal operand:     std_logic_vector(7 downto 0) := (others => '0');

	-- MCPU State Machine. Extra 'M' states are used to strobe correctly SRAM data exchange
	type state is (F0, F0M, F1, F1M, F2, EX, FSTA);
	signal mcpustate : state := F0;

begin
	process(clock, reset)
	begin

	if rising_edge(clock) then
		if (reset = '0') then
			addr	<= (others => '0');
			accumulator <= (others => '0');
			pc   <= (others => '0');
			mcpustate <= F0;
			we <= '0';
		else
		case mcpustate is
			-- First state: put PC on address bus
			when F0 =>
				we <= '0';
				addr <= pc;
				mcpustate <= F0M;

			-- Let SRAM latch the address
			when F0M =>
				mcpustate <= F1;

			-- Get opcode and operand
			when F1 =>
				opcode <= datain(7 downto 6);   -- Get opcode
				operand <= "00" & datain(5 downto 0);
				if(datain (7) = '0') then       -- If dealing with NOR/ADD
					addr <= datain(5 downto 0); -- Fetch data from memory
					mcpustate <= F1M;
				else
					mcpustate <= EX;
				end if;

			-- Let SRAM latch the new address
			when F1M =>
				mcpustate <= F2;

			-- Load actual data
			when F2 =>
				operand <= datain;
				mcpustate <= EX;

			-- Execute operation
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
					we <= '1';
					pc <= pc + 1;
					mcpustate <= FSTA;
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

			-- Let the store occur
			when FSTA =>
				mcpustate <= F0;

			when others =>
				mcpustate <= F0;
		end case;
	end if;
	end if;
end process;

address <= addr;
dataout <= accumulator(7 downto 0);

end rtl;
