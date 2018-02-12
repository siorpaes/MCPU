library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mcpu_toplevel is
generic (CLK_DIVISOR :  POSITIVE := 10000);
port(
  clk     : in std_logic;
  reset   : in std_logic;
  gpio    : out std_logic_vector(7 downto 0);
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

-- Address
signal s_address : std_logic_vector (5 downto 0) := (others => '0');
signal data : std_logic_vector (7 downto 0) := (others => '0');
signal mcpu_datain  : std_logic_vector (7 downto 0) := (others => '0');
signal mcpu_dataout : std_logic_vector (7 downto 0) := (others => '0');
signal s_oe : std_logic := '0';
signal s_we : std_logic := '0';
signal sram_we : std_logic := '0';

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
  end if;
end if;
end process clk_divider;


-- Instantiate MCPU
  mcpu: entity work.CPU8BIT2
  port map(
	data => data,
	adress => s_address,
	oe => s_oe,
	we => s_we,
	rst => reset,
	clk => div_clk
  );


-- Instantiate SRAM
  SRAM: entity work.ice40_ram2
  port map(
	a   => s_address,
	d   => mcpu_dataout,
	clk => div_clk,
	we  => sram_we,
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


-- Write Enable is opposite
sram_we <= not s_we;

-- Route data
data <= mcpu_datain when s_oe = '0' else "ZZZZZZZZ";
mcpu_dataout <= data;

-- Debug address
ssdval <= "00" & std_logic_vector(s_address);

-- GPIO peripheral
gpio <= s_gpio;

end behaviour;
