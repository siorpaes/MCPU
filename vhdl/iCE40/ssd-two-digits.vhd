-- Wraps two SSD single digits

library ieee;
use ieee.std_logic_1164.all;

entity ssd_two_digits is
  port (
    i_Clk        : in  std_logic;
    i_Binary_Num : in  std_logic_vector(7 downto 0);
    o_Segment_1A : out std_logic;
    o_Segment_1B : out std_logic;
    o_Segment_1C : out std_logic;
    o_Segment_1D : out std_logic;
    o_Segment_1E : out std_logic;
    o_Segment_1F : out std_logic;
    o_Segment_1G : out std_logic;
    o_Segment_2A : out std_logic;
    o_Segment_2B : out std_logic;
    o_Segment_2C : out std_logic;
    o_Segment_2D : out std_logic;
    o_Segment_2E : out std_logic;
    o_Segment_2F : out std_logic;
    o_Segment_2G : out std_logic
    );
end entity ssd_two_digits;

architecture RTL of ssd_two_digits is

signal digit1 : std_logic_vector(3 downto 0);
signal digit2 : std_logic_vector(3 downto 0);

begin

  ssd1 : entity work.Binary_To_7Segment
      port map (
        i_Clk    => i_Clk,
        i_Binary_Num => digit1,
        o_Segment_A => o_Segment_1A,
        o_Segment_B => o_Segment_1B,
        o_Segment_C => o_Segment_1C,
        o_Segment_D => o_Segment_1D,
        o_Segment_E => o_Segment_1E,
        o_Segment_F => o_Segment_1F,
        o_Segment_G => o_Segment_1G
        );

  ssd2 : entity work.Binary_To_7Segment
        port map (
        i_Clk    => i_Clk,
        i_Binary_Num => digit2,
        o_Segment_A => o_Segment_2A,
        o_Segment_B => o_Segment_2B,
        o_Segment_C => o_Segment_2C,
        o_Segment_D => o_Segment_2D,
        o_Segment_E => o_Segment_2E,
        o_Segment_F => o_Segment_2F,
        o_Segment_G => o_Segment_2G
       );

digit1 <= i_Binary_Num(7 downto 4);
digit2 <= i_Binary_Num(3 downto 0);

end architecture RTL;
