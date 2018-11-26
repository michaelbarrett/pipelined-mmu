-- RF

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rf is
  port(
    -- inputs
    clock : in std_logic;
    register_write : in std_logic;
    r_addr1 : in std_logic_vector;
    r_addr2 : in std_logic_vector;
    r_addr3 : in std_logic_vector;
    w_addr : in std_logic_vector;
    w_data_in : in std_logic_vector;
    -- outputs
    r_out1 : out std_logic_vector;
    r_out2 : out std_logic_vector;
    r_out3 : out std_logic_vector;
    );
end entity;

architecture rtl of rf is

  type data_type is array (0 to 31) of std_logic_vector(w_data_in'range);
  signal data : data_type;
  signal read_address : std_logic_vector(r_addr1'range);

begin

  RfProc : process(clock) is

  begin
    if rising_edge(clock) then
      if register_write = '1' then
        data(to_integer(unsigned(w_addr))) <= datain;
      end if;
      read_address1 <= r_addr1;
      read_address2 <= r_addr2;
      read_address3 <= r_addr3;
    end if;
  end process RfProc;

  r_out1 <= data(to_integer(unsigned(read_address1)));
  r_out2 <= data(to_integer(unsigned(read_address2)));
  r_out3 <= data(to_integer(unsigned(read_address3)));

end architecture rtl;
