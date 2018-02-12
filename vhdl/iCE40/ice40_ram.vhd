-- See SBT_ICE_Technology_Library.pdf, page 61

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ice40_ram is
port(
	a   : in  std_logic_vector(5 downto 0);
	d   : in  std_logic_vector(7 downto 0);
	clk : in  std_logic;
	we  : in  std_logic;
	spo : out std_logic_vector(7 downto 0)
);
end ice40_ram;

architecture Behavioral of ice40_ram is

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

signal RDATA_c : std_logic_vector(7 downto 0);
signal RADDR_c : std_logic_vector(8 downto 0);
signal RCLK_c  : std_logic;
signal RCLKE_c : std_logic;
signal RE_c    : std_logic;
signal WADDR_c : std_logic_vector(8 downto 0);
signal WCLK_c  : std_logic;
signal WCLKE_c : std_logic;
signal WDATA_c : std_logic_vector(7 downto 0);
signal WE_c    : std_logic;

begin

ram512x8_inst : SB_RAM512x8

generic map (
	INIT_0 => X"0000000000000000000000000000000000000000000000000000c03f3ebc3f3e",
	INIT_1 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_2 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_3 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_4 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_5 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_6 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_7 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_8 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_9 => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_A => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_B => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_C => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_D => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_E => X"0000000000000000000000000000000000000000000000000000000000000000",
	INIT_F => X"0000000000000000000000000000000000000000000000000000000000000000"
)

port map (
	RDATA => RDATA_c,
	RADDR => RADDR_c,
	RCLK => RCLK_c,
	RCLKE => RCLKE_c,
	RE => RE_c,
	WADDR => WADDR_c,
	WCLK=> WCLK_c,
	WCLKE => WCLKE_c,
	WDATA => WDATA_c,
	WE => WE_c
);

-- SRAM Mapping
spo  <= RDATA_c;
RADDR_c  <= "000" & a;
RCLK_c   <= not clk;
RCLKE_c  <= '1';
RE_c     <= not we;
WADDR_c  <= "000" & a;
WCLK_c   <= clk;
WCLKE_c    <= '1';
WDATA_c  <= d;
WE_c     <= we;

end Behavioral;
