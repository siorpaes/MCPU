-- sram64kx8.vhd 
-- standard SRAM vhdl code, 64K*8 Bit,
--                          simplistic model without timing
--                          with startup initialization from file
--
-- (C) 1993,1994 Norman Hendrich, Dept. Computer Science
--                                University of Hamburg
--                                22041 Hamburg, Germany
--                                hendrich@informatik.uni-hamburg.de
--
-- initialization code taken and modified from DLX memory-behaviour.vhdl: 
--                    Copyright (C) 1993, Peter J. Ashenden
--                    Mail:       Dept. Computer Science
--                                University of Adelaide, SA 5005, Australia
--                    e-mail:     petera@cs.adelaide.edu.au
--

use std.textio.all;
Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;


entity sram64kx8 is

  generic (rom_data_file_name: string := "memory_count.dat");

  port (ncs1, cs2: in std_logic;        -- not chip select 1, cs2
        addr     : in std_logic_vector( 15 downto 0 );
        data     : inout std_logic_vector( 7 downto 0 );
        nwe      : in std_logic;        -- not write enable
        noe      : in std_logic        -- not output enable 
       );

end sram64kx8;

architecture sram_behaviour of sram64kx8 is
begin

   mem: process
   
      constant low_address: natural := 0;
      constant high_address: natural := 65535;  -- 64K SRAM

      subtype byte is std_logic_vector( 7 downto 0 );

      type memory_array is
         array (natural range low_address to high_address) of byte;

      variable mem: memory_array;
      variable address : natural;
      variable L : line;



      --
      -- load initial memory contents from text-file
      -- and print a copy to stdout...
      --
      procedure load( mem: out memory_array) is

        file binary_file : text is in rom_data_file_name;
        variable L : line;
        variable add, val, i : natural;
	variable c : character;


      begin
	write( output, "sram initialization:" );
        -- first initialize the RAM array with zeroes
        for add in low_address to high_address loop
           mem(add) := "00000000";
        end loop; 
        -- and now read the data file
        while not endfile(binary_file) loop
           readline(binary_file, L );
           read (L, add);
	   read (L, c ); -- delimiting space
	   val := 0; 
	   for i in 0 to 7 loop
	      val := val + val;
	      read (L, c );
	      if c = '1' then 
		 val := val + 1;
	      end if;
	   end loop;
           --
           write( L, add);
           write( L, ' ' );
           write( L, val);
           writeline( output, L );
           --
           mem( add ) := conv_std_logic_vector( val, 8 );
        end loop;
      end load;

      
      
   begin
      load( mem );
      data <= "ZZZZZZZZ" ;
      --
      --
      -- process memory cycles
      --
      loop
         --
         -- wait for chip-select,
         -- 
         if (ncs1 = '0') and (cs2 = '1') then

            -- decode address
            address := conv_integer( addr );
            -- 
            if nwe = '0' then
               --- write cycle
               mem( address ) := data(7 downto 0);
               data <= "ZZZZZZZZ";
            elsif nwe = '1' then 
               -- read cycle
               if noe = '0' then
                  data <= mem( address );
               else 
                  data <= "ZZZZZZZZ";
               end if;
            else
               data <= "ZZZZZZZZ";
            end if;
         else
            --
            -- Chip not selected, disable output
            --
            data <= "ZZZZZZZZ";
         end if;

         wait on ncs1, cs2, nwe, noe, addr, data; -- FNH, 29.1.99: added data
      end loop;
   end process;


end sram_behaviour;


configuration cfg_sram of sram64kx8 is
   for sram_behaviour
   end for;
end cfg_sram;

