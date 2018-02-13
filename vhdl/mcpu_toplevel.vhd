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

-- MCPU signals
signal r_data       : std_logic_vector (7 downto 0) := (others => '0');
signal mcpu_datain  : std_logic_vector (7 downto 0) := (others => '0');
signal mcpu_dataout : std_logic_vector (7 downto 0) := (others => '0');
signal r_address    : std_logic_vector (5 downto 0) := (others => '0');
signal r_oe         : std_logic := '0';
signal r_we         : std_logic := '0';
signal sram_we      : std_logic := '0';
signal div_clk      : std_logic := '0';
signal r_clk        : std_logic := '0';
signal r_rst        : std_logic := '0';
signal r_gpio       : std_logic_vector (7 downto 0) := (others => '0');

begin

    mcpu_clk: process(clk)
    begin
	if(rising_edge(clk)) then
		if clk_div_cnt = (CLK_DIVISOR-1) then
			clk_div_cnt <= (others => '0');
			div_clk <= not div_clk;
		else
			clk_div_cnt <= clk_div_cnt + 1;
		end if;
	end if;
    end process mcpu_clk;

    
	-- Instantiate MCPU peripheral
	MCPU: entity work.CPU8BIT2
	port map(
	data	=> r_data,
	adress	=> r_address,
	oe	    => r_oe,
	we      => r_we,	
	rst     => r_rst,	
	clk	    => r_clk
	);
    
    
    -- Instantiate SRAM
    --SRAM: entity work.mcpu_ram
	SRAM: entity work.ssram
    port map(
	a => r_address,
	d => mcpu_dataout,
	clk => r_clk,
	we => sram_we,
	spo => mcpu_datain
    );
    
    GPIO: entity work.gpio
    port map(
    clk => r_clk,
    reset => r_rst,
    address => r_address,
    data => r_data,
    gpo => r_gpio,
    we => r_we
    );

    
    -- Manage data mux MCPU <=> SRAM
   	r_data <= mcpu_datain when (r_oe = '0') else "ZZZZZZZZ";
	mcpu_dataout <= r_data;
    
    -- MCPU WE is active low, SRAM WE is active high
    sram_we <= not r_we;

	-- Debug address, clock and WE
    debug <= r_address & r_we & r_clk;
    
    -- Reset
    r_rst <= reset;
    
    -- Assign clock
    r_clk <= div_clk;
    
    -- GPIO
    mgpio <= r_gpio;
    
end architecture behaviour;
