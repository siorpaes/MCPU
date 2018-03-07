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
    gpio_clk: process(clk, we)
    begin
	if(rising_edge(clk)) then
		if(reset = '0') then
			r_data <= "00000000";
		-- If writing to 0x3c emit data on GPIO port
		elsif(address = "111100" and we = '1') then
			r_data <= data;
		end if;
	end if;
    end process gpio_clk;

gpo <= r_data;

end architecture behaviour;
