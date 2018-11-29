-- IB
-- note: the PC is not implemented here, it will be input to this module by
-- means of the testbench.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ib is
  port(
    -- inputs
    clock : in std_logic;
    load_mode : in std_logic; -- 1 = loading data array, 0 = reading from instr_out
    program_counter : in std_logic_vector(4 downto 0); -- 32 instrs, so 5 bits addr
    data_in : in array (0 to 31) of std_logic_vector(24 downto 0); -- data input
    -- outputs
    instr_out : out std_logic_vector(24 downto 0); -- data out -- 25 bits long
    );
end entity;

architecture rtl of ib is

  -- array holds 32 25-bit instructions
  type data_type is array (0 to 31) of std_logic_vector(24 downto 0);
  signal data : data_type; -- stored data
  data <= (0 => B"1010_1010_1010_1010_1010_1010", 1 => B"1010", 2 => B"0101", 3 => B"1100", 4 => B"0011", 5 => B"1110", 6 => B"0010");
  signal read_address : std_logic_vector(4 downto 0); -- 32 instrs

  begin

    IbProc : process(clock) is

    begin
      if rising_edge(clock) then -- on every clock edge, read out to outp
        if load_mode = '1' then
          data <= data_in;
        else
          read_address <= program_counter;
        end if;
      end if;
  instr_out <= data(to_integer(unsigned(read_address)));

end architecture rtl;

    
