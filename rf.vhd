-- RF

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rf is
  port(
  -- inputs
  -- register write is always true
    r_addr1 : in std_logic_vector(4 downto 0); -- 32 registers, so 5 bits addr
    r_addr2 : in std_logic_vector(4 downto 0);
    r_addr3 : in std_logic_vector(4 downto 0);
    w_addr1 : in std_logic_vector(4 downto 0);
    w_data_in1 : in std_logic_vector(127 downto 0); -- 128 bits in reg
    -- outputs
    r_data_out1 : out std_logic_vector(127 downto 0); -- 128 bits in reg
    r_data_out2 : out std_logic_vector(127 downto 0);
    r_data_out3 : out std_logic_vector(127 downto 0)
    );
end entity;

architecture rtl of rf is

  -- array holds 32 128-bit registers -- 0 to 31 is (0 to (2**address'length)-1)
  type data_type is array (0 to 31) of std_logic_vector(127 downto 0);
  -- initialize to zero
  signal data : data_type := (others=>(others=>'0'));
  
  -- other signals
  signal rd_temp : std_logic_vector(4 downto 0);
  signal read_address1 : std_logic_vector(4 downto 0);
  signal read_address2 : std_logic_vector(4 downto 0);
  signal read_address3 : std_logic_vector(4 downto 0);

begin

  RfProc : process(r_addr1, r_addr2, r_addr3, w_addr1, w_data_in1) is

  begin
	-- register write (no if statement bc always) -- use rd_temp so that it's available next cycle for wb
    data(to_integer(unsigned(rd_temp))) <= w_data_in1;

    rd_temp <= w_addr1;
	
	-- register read
    read_address1 <= r_addr1;
    read_address2 <= r_addr2;
    read_address3 <= r_addr3;

    r_data_out1 <= data(to_integer(unsigned(read_address1)));
    r_data_out2 <= data(to_integer(unsigned(read_address2)));
    r_data_out3 <= data(to_integer(unsigned(read_address3)));  

  end process RfProc;

end architecture rtl;
