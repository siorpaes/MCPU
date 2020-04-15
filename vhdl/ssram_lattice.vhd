-- SSRAM inference as of Lattice documentation
-- See iCEcube201708UserGuide.pdf

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity ram is
generic (
    addr_width : natural := 16;
    data_width : natural := 8);

port (
     addr : in std_logic_vector (addr_width - 1 downto 0);
     write_en : in std_logic;
     clk : in std_logic;
     din : in std_logic_vector (data_width - 1 downto 0);
     dout : out std_logic_vector (data_width - 1 downto 0));
end ram;

architecture rtl of ram is
    type mem_type is array ((2** addr_width) - 1 downto 0) of std_logic_vector(data_width - 1 downto 0);
    signal mem : mem_type;

    -- Define RAM as an indexed memory array.
    begin
        process (clk)
        begin
            if (clk'event and clk = '1') then
            -- Control with clock edge
                if (write_en = '1') then -- Control with a write enable.
                    mem(conv_integer(addr)) <= din;
                end if;
                dout <= mem(conv_integer(addr));
            end if;
        end process;
        
    --dout <= mem(conv_integer(addr));
end rtl;
