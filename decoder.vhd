-- Decoder, combinational module
-- converts an instruction with an opcode into control signals understood by the alu

library IEEE;
use IEEE.std_logic_1164.all;n
use IEEE.numeric_std.all;

entity decoder is
  port(
    -- data inputs:
    instr : in std_logic_vector(24 downto 0); -- an instruction
    -- data outputs:
    load : out std_logic;
    mal, mah, msl, msh : out std_logic;
    nop, bcw, and_instr, or_instr, popcnth, clz, rot, shlhi, a, sfw, ah, sfh, ahs, sfhs, mpyu, absdb : out std_logic;
    );
end entity;

architecture conversion of decoder is

begin

  DecProc : process(instr) is

  begin
    

end architecture;
