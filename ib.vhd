-- IB
-- note: the PC is not implemented here, it will be input to this module	 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ib_type_pkg is
type ib_type is array(0 to 31) of std_logic_vector (24 downto 0);
end package ib_type_pkg;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ib_type_pkg.all;

entity ib is
  port(
    -- inputs
    load_mode : in std_logic; -- 0 = loading data array, 1 = reading from instr_out
    program_counter : in std_logic_vector(4 downto 0); -- 32 instrs, so 5 bits addr
    data_in : in ib_type; -- data input
    -- outputs
    instr_out : out std_logic_vector(24 downto 0) -- data out -- 25 bits long
    );
end entity;

architecture rtl of ib is

signal data : ib_type; -- stored data
signal read_address : std_logic_vector(4 downto 0); -- 32 instrs

  begin

    IbProc : process(load_mode, program_counter, data_in) is	

    begin
	  -- array holds 32 25-bit instructions
      --type data_type is array (0 to 31) of std_logic_vector(24 downto 0);
      
      --data <= (0 => B"1010_1010_1010_1010_1010_10101", 1 => B"1010010101010101010101010", others => B"0000000000000000000000000");
	
		
      if load_mode = '0' then
        data <= data_in;
      end if;
      read_address <= program_counter;

      instr_out <= data(to_integer(unsigned(read_address)));

    end process IBProc;

end architecture rtl;
