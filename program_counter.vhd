-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : 
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : 
-- Generated   : 
-- From        : 
-- By          : 
--
-------------------------------------------------------------------------------
--
--
-- Description :
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {modulo_60_counter} architecture {modulo_60_counter}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
	 port(
		 rst_n : in STD_LOGIC;
		 clk : in STD_LOGIC;	 
		 count : out std_logic_vector(4 downto 0)
	     );
end program_counter;

--}} End of automatically maintained section

architecture behavior of program_counter is	
begin
	process(rst_n, clk, load_en, setting, cnt_en_1)
	variable count_int: integer := 0;
	begin
		if (rst_n = '0') then
			count_int := -1;
			count <= (others => '0');
		end if;
		if rising_edge(clk) then
			if count_int < 31 then
				count_int := count_int + 1;
				count <= std_logic_vector(to_unsigned(count_int, 4));
			end if;
	end process;
end program_counter;
