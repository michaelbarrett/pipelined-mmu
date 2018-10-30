-- ALU

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numerid_std.all;

entity alu is
  port(
--  data inputs:
    in1, in2, imm : in unsigned(127 downto 0);
    
--  control inputs:
    opcode : in unsigned(3 downto 0); //xxx0000, xxx0001, xxx0010, etc

--  data outputs:
    res : out unsigned(127 downto 0);

--  flag outputs:
    zero : out std_logic;

    );
end entity;

architecture behavioral of alu is

-- perform different operations to the inputs based on the opcode

end architecture;
