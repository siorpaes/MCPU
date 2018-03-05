library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_toplevel is
generic (CLK_DIVISOR :  POSITIVE := 1000);
--generic (CLK_DIVISOR :  POSITIVE := 4000000);

port(
  clk     : in std_logic;
  reset   : in std_logic;
  gpio    : out std_logic_vector(7 downto 0);
  debug   : out std_logic_vector(2 downto 0);
  o_Segment1_A : out std_logic;
  o_Segment1_B : out std_logic;
  o_Segment1_C : out std_logic;
  o_Segment1_D : out std_logic;
  o_Segment1_E : out std_logic;
  o_Segment1_F : out std_logic;
  o_Segment1_G : out std_logic;
  o_Segment2_A : out std_logic;
  o_Segment2_B : out std_logic;
  o_Segment2_C : out std_logic;
  o_Segment2_D : out std_logic;
  o_Segment2_E : out std_logic;
  o_Segment2_F : out std_logic;
  o_Segment2_G : out std_logic
);
end entity mcpu_toplevel;

architecture behaviour of mcpu_toplevel is

-- Clock divider
signal clk_div_cnt : unsigned (31 downto 0) := (others => '0');
signal div_clk     : std_logic := '0';

signal mcpu_clk     : std_logic := '0';
signal sram_clk     : std_logic := '0';

signal delay          : unsigned (31 downto 0) := (others => '0');

-- Address
signal s_address : std_logic_vector (5 downto 0) := (others => '0');
signal mcpu_datain  : std_logic_vector (7 downto 0) := (others => '0');
signal mcpu_dataout : std_logic_vector (7 downto 0) := (others => '0');
signal s_we : std_logic := '1';
signal s_oe : std_logic := '0';

signal ssdval : std_logic_vector (7 downto 0) := (others => '0');
signal s_gpio : std_logic_vector (7 downto 0) := (others => '0');
begin

-- Clock divider
clk_divider: process(clk)
begin
if(rising_edge(clk)) then
  if clk_div_cnt = (CLK_DIVISOR-1) then
    clk_div_cnt <= (others => '0');
    div_clk <= not div_clk;
  else
    clk_div_cnt <= clk_div_cnt + 1;
    delay <= delay + 1;
  end if;
end if;
end process clk_divider;


  -- Instantiate MCPU  
  MCPU: entity work.mcpu
    port map(
    clock    => mcpu_clk,
    reset    => reset,
    dataout  => mcpu_dataout,
    datain   => mcpu_datain,
    address  => s_address,
    we       => s_we,
    oe	 => s_oe
  );


-- Instantiate SRAM
  SRAM: entity work.ssram
  port map(
	a   => s_address,
	d   => mcpu_dataout,
	clk => sram_clk,
	we  => s_we,
	oe  => s_oe,
	spo => mcpu_datain
  );

-- Instantiate double SSD
  DIGITS: entity work.ssd_two_digits
  port map(
    i_Clk        => div_clk,
    i_Binary_Num => ssdval,
    o_Segment_1A => o_Segment1_A,
    o_Segment_1B => o_Segment1_B,
    o_Segment_1C => o_Segment1_C,
    o_Segment_1D => o_Segment1_D,
    o_Segment_1E => o_Segment1_E,
    o_Segment_1F => o_Segment1_F,
    o_Segment_1G => o_Segment1_G,
    o_Segment_2A => o_Segment2_A,
    o_Segment_2B => o_Segment2_B,
    o_Segment_2C => o_Segment2_C,
    o_Segment_2D => o_Segment2_D,
    o_Segment_2E => o_Segment2_E,
    o_Segment_2F => o_Segment2_F,
    o_Segment_2G => o_Segment2_G
    );

-- Instantiate GPIO peripheral
   M_GPIO: entity work.gpio
   port map(
   clk => div_clk,
   reset => reset,
   address => s_address,
   data => mcpu_dataout,
   gpo => s_gpio,
   we => s_we
   );

-- MCPU clock
mcpu_clk <= div_clk when (delay >= x"09") else '0';

-- SRAM clock
sram_clk <= not div_clk;

-- Debug addres on display
ssdval <= "00" & std_logic_vector(s_address);

-- Debug other signals
debug(0) <= div_clk;
debug(1) <= s_we;


-- GPIO peripheral
gpio <= s_gpio;

end behaviour;
