library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gpio is
port(
	clk     : in std_logic;
	reset   : in std_logic;
	address : in std_logic_vector(5 downto 0);
	data    : in std_logic_vector(7 downto 0);
	gpo     : out std_logic_vector(7 downto 0);
	we      : in std_logic
);
end entity gpio;

architecture behaviour of gpio is

signal r_data : std_logic_vector (7 downto 0) := "10101010";

begin
    gpio_clk: process(clk)
    begin
	if(falling_edge(clk)) then
		if(reset = '0') then
			r_data <= "00000000";
		-- If accessing 0x3c emit data. Cannot put condition on WE as it is asynchronous
		elsif(address = "111100") then
			r_data <= data;
		end if;
	end if;
    end process gpio_clk;

gpo <= r_data;

end architecture behaviour;
