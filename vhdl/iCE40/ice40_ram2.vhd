-- Simple SRAM miplementation
-- See iCEcube2_userguide.pdf


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ice40_ram2 is
port(
	a   : in  std_logic_vector(5 downto 0);
	d   : in  std_logic_vector(7 downto 0);
	clk : in  std_logic;
	we  : in  std_logic;
	spo : out std_logic_vector(7 downto 0)
);
end ice40_ram2;

architecture Behavioral of ice40_ram2 is

type memory_array is array(0 to 63) of std_logic_vector(7 downto 0);
--signal memory : memory_array := (others => (others => '0'));
signal memory : memory_array := ( x"3e",x"7f",x"bc",x"c1",x"c0",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
			x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
			x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
		  	x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"ff",x"01"
);


-- Infer Block RAM for Lattice FPGA
attribute syn_ramstyle : string;
attribute syn_ramstyle of memory : signal is "block_ram";

begin

process(clk)
begin
	if falling_edge(clk) then
		if(we = '1') then
			memory(to_integer(unsigned(a))) <= d;
		else
			spo <= memory(to_integer(unsigned(a)));
		end if;
	end if;
end process;

end Behavioral;
