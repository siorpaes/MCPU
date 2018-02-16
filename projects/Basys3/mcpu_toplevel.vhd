library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_toplevel is
generic (CLK_DIVISOR :  POSITIVE := 10000);
port(
	clk     : in std_logic;
	reset   : in std_logic;
	mgpio   : out std_logic_vector(7 downto 0);  -- GPIO
	debug   : out std_logic_vector(7 downto 0)   -- Debug port
);
end entity mcpu_toplevel;

architecture behaviour of mcpu_toplevel is

-- Clock divider
signal clk_div_cnt    : unsigned (31 downto 0) := (others => '0');

signal delay          : unsigned (31 downto 0) := (others => '0');


-- MCPU signals
signal r_datain  : std_logic_vector (7 downto 0) := (others => '0');
signal r_dataout : std_logic_vector (7 downto 0) := (others => '0');
signal r_address    : std_logic_vector (5 downto 0) := (others => '0');
signal r_oe         : std_logic := '0';
signal r_we         : std_logic := '0';
signal div_clk      : std_logic := '0';
signal r_clk        : std_logic := '0';
signal mcpu_clk     : std_logic := '0';
signal r_reset      : std_logic := '0';
signal r_gpio       : std_logic_vector (7 downto 0) := (others => '0');

begin

    clock: process(clk)
    begin
	if(rising_edge(clk)) then
		if clk_div_cnt = (CLK_DIVISOR-1) then
			clk_div_cnt <= (others => '0');
			div_clk <= not div_clk;
			delay <= delay + 1;
		else
			clk_div_cnt <= clk_div_cnt + 1;
		end if;
	end if;
    end process clock;

    
	-- Instantiate MCPU peripheral
	MCPU: entity work.mcpu
	port map(
	clock    => mcpu_clk,
    reset    => r_reset,
    dataout  => r_dataout,
    datain   => r_datain,
    address  => r_address,
    we       => r_we
	);
    
    
    -- Instantiate SRAM
	SRAM: entity work.ssram
    port map(
	a => r_address,
	d => r_dataout,
	clk => r_clk,
	we => r_we,
	spo =>r_datain
    );
    
    GPIO: entity work.gpio
    port map(
    clk => r_clk,
    reset => r_reset,
    address => r_address,
    data => r_dataout,
    gpo => r_gpio,
    we => r_we
    );

    
	-- Debug address, clock and WE
    debug <= r_address & r_we & r_clk;
    
    -- Reset
    r_reset <= reset;
    
    -- Assign clocks
    r_clk <= div_clk;
    
    mcpu_clk <= r_clk when (delay >= x"07") else '0';
    
    -- GPIO
    mgpio <= r_gpio;
    
end architecture behaviour;
