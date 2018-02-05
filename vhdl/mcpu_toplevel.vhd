library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_toplevel is
generic (CLK_DIVISOR :  POSITIVE := 100);
port(
	clk     : in std_logic;
	clksel  : in std_logic;   -- Tells wheter to use plain clock or divided one
	reset   : in std_logic;
	address : out std_logic_vector(5 downto 0)
);
end entity mcpu_toplevel;

architecture behaviour of mcpu_toplevel is

-- Clock divider
signal clk_div_cnt    : unsigned (31 downto 0) := (others => '0');

-- MCPU signals
signal r_data      : std_logic_vector (7 downto 0) := (others => '0');
signal r_datain    : std_logic_vector (7 downto 0) := (others => '0');
signal r_dataout   : std_logic_vector (7 downto 0) := (others => '0');
signal r_adress    : std_logic_vector (5 downto 0) := (others => '0');
signal r_oe        : std_logic := '0';
signal r_we        : std_logic := '0';
signal sram_we     : std_logic := '0';
signal div_clk     : std_logic := '0';
signal r_clk       : std_logic := '0';
signal r_rst       : std_logic := '0';

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
	adress	=> r_adress,
	oe	    => r_oe,
	we      => r_we,	
	rst     => r_rst,	
	clk	    => r_clk
	);
    
    -- Instantiate SRAM
    SRAM: entity work.mcpu_ram
    port map(
	a => r_adress,
	d => r_datain,
	clk => r_clk,
	we => sram_we,
	spo => r_dataout
    );
        	
    -- Manage data mux
   	r_datain <= r_data when (r_we = '0') else "ZZZZZZZZ";
	r_data   <= r_dataout when (r_oe = '0') else "ZZZZZZZZ";
    
    -- MCPU WE is active low, SRAM WE is active high
    sram_we <= '1' when (r_oe = '1' and r_we = '0') else '0';

	-- Debug address
    address <= r_adress;
    
    -- Reset
    r_rst <= reset;
    
    -- Clock selection: if clksel = 1 use divided clock otherwise use original clock
    r_clk <= clk when (clksel = '0') else div_clk;
    
end architecture behaviour;
