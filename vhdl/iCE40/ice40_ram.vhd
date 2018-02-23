-- See SBT_ICE_Technology_Library.pdf, page 61

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssram is
port(
	a   : in  std_logic_vector(5 downto 0);
	d   : in  std_logic_vector(7 downto 0);
	clk : in  std_logic;
	we  : in  std_logic;
	oe  : in  std_logic;
	spo : out std_logic_vector(7 downto 0)
);
end ssram;

architecture Behavioral of ssram is

component SB_RAM512x8
generic ( 	INIT_0 : std_logic_vector(255 downto 0);
	INIT_1 : std_logic_vector(255 downto 0);
	INIT_2 : std_logic_vector(255 downto 0);
	INIT_3 : std_logic_vector(255 downto 0);
	INIT_4 : std_logic_vector(255 downto 0);
	INIT_5 : std_logic_vector(255 downto 0);
	INIT_6 : std_logic_vector(255 downto 0);
	INIT_7 : std_logic_vector(255 downto 0);
	INIT_8 : std_logic_vector(255 downto 0);
	INIT_9 : std_logic_vector(255 downto 0);
	INIT_A : std_logic_vector(255 downto 0);
	INIT_B : std_logic_vector(255 downto 0);
	INIT_C : std_logic_vector(255 downto 0);
	INIT_D : std_logic_vector(255 downto 0);
	INIT_E : std_logic_vector(255 downto 0);
	INIT_F : std_logic_vector(255 downto 0)
);
Port (
	RDATA: out std_logic_vector(7 downto 0);
	RADDR: in  std_logic_vector(8 downto 0);
	RCLK:  in  std_logic;
	RCLKE: in  std_logic;
	RE:    in  std_logic;
	WADDR: in  std_logic_vector(8 downto 0);
	WCLK:  in  std_logic;
	WCLKE: in  std_logic;
	WDATA: in  std_logic_vector(7 downto 0);
	WE:    in  std_logic
);
end component;

signal RDATA_c : std_logic_vector(7 downto 0) := (others => '0');
signal RADDR_c : std_logic_vector(8 downto 0) := (others => '0');
signal RCLK_c  : std_logic := '1';
signal RE_c    : std_logic := '1';
signal WADDR_c : std_logic_vector(8 downto 0) := (others => '0');
signal WCLK_c  : std_logic := '1';
signal WDATA_c : std_logic_vector(7 downto 0) := (others => '0');
signal WE_c    : std_logic := '0';

begin

ram512x8_inst : SB_RAM512x8

generic map (
	INIT_0 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbc0c0bc39ba7f7a3ec1bb7f3f",
	INIT_1 => X"01ff00000000febbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_2 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_3 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_4 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_5 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_6 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_7 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_8 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_9 => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_A => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_B => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_C => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_D => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_E => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
	INIT_F => X"bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
)

port map (
	RDATA => RDATA_c,
	RADDR => RADDR_c,
	RCLK => RCLK_c,
	RCLKE => '1',
	RE => RE_c,
	WADDR => WADDR_c,
	WCLK=> WCLK_c,
	WCLKE => '1',
	WDATA => WDATA_c,
	WE => WE_c
);

-- SRAM Mapping
spo  <= RDATA_c;
RADDR_c  <= "000" & a;
RCLK_c   <= clk;
RE_c     <= not oe;
WADDR_c  <= "000" & a;
WCLK_c   <= clk;
WDATA_c  <= d;
WE_c     <= not we;

end Behavioral;
