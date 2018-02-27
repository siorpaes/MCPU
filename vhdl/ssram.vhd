-- Simple SRAM implementation
-- See iCEcube2_userguide.pdf


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssram is
port(
	a   : in  std_logic_vector(5 downto 0); -- Address
	d   : in  std_logic_vector(7 downto 0); -- Data In
	clk : in  std_logic;                    -- Clock
	we  : in  std_logic;                    -- Write Enable, active low
	oe  : in  std_logic;                    -- Output Enable, active low
	spo : out std_logic_vector(7 downto 0)  -- Data Out
);
end ssram;

architecture Behavioral of ssram is

type memory_array is array(0 to 63) of std_logic_vector(7 downto 0);
signal memory : memory_array := (
--	x"0a",x"0b",x"88",x"0d",x"0e",x"c0",x"7f",x"ba",x"39",x"bc",x"c0",x"c0",x"00",x"00",x"00",x"00", -- STA test
	x"3e",x"7f",x"bb",x"c1",x"3e",x"7a",x"7f",x"ba",x"39",x"bc",x"c0",x"c0",x"00",x"00",x"00",x"00", -- blinky
--	x"3e",x"7f",x"bc",x"c1",x"c0",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00", -- gpio
--	x"3e",x"46",x"7e",x"86",x"c0",x"c5",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00", -- rwloop
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"fe",x"00",x"00",x"00",x"00",x"ff",x"01"
);

-- Infer Block RAM for iCE40 Lattice FPGA
attribute syn_ramstyle : string;
attribute syn_ramstyle of memory : signal is "block_ram";

--Infer Block RAM for Xilinx FPGA                   
attribute ram_style : string;
attribute ram_style of memory : signal is "block";
   
begin

process(clk, we, a, d)
begin
	if rising_edge(clk) then
		if(we = '0') then
			memory(to_integer(unsigned(a))) <= d;
		end if;
		
		if(oe = '0') then
			spo <= memory(to_integer(unsigned(a)));
		end if;
	end if;
end process;

end Behavioral;
