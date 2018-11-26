-- ALU

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port(
--  data inputs:
    in1, in2, in3 : in std_logic_vector(4 downto 0);
    imm : in std_logic_vector(15 downto 0);
    
--  control inputs:
    opcode : in std_logic_vector(3 downto 0); //xxx0000, xxx0001, xxx0010, etc

--  data outputs:
    res : out std_logic_vector(4 downto 0);

--  flag outputs:
    zero : out std_logic;

    );
end entity;

architecture behavioral of alu is

-- perform different operations to the inputs based on the opcode

  if (add_ctrl = 1) { res = in1 + in2 } --addition
    else if  (and_ctrl == 1) { res = in1 & in2 } --bitwise AND

end architecture;
