-- ALU, combinational module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port(
--  data inputs:
    rs1, rs2, rs3 : in std_logic_vector(127 downto 0);
    imm : in std_logic_vector(15 downto 0);
    
--  control inputs:
    li : in std_logic;
    mal, mah, msl, msh : in std_logic;
    nop, bcw, and_instr, or_instr, popcnth, clz, rot, shlhi, a, sfw, ah, sfh, ahs, sfhs, mpyu, absdb : in std_logic;

--  data outputs:
    res : out std_logic_vector(4 downto 0);

--  flag outputs:
    zero : out std_logic;    
    );
end entity;

architecture behavioral of alu is

  begin

-- perform different operations to the inputs based on the opcode

    process(rs1, rs2, rs3)

      begin

        if li = '1' then
          res <= imm;
        elsif mal = '1' then
          -- multiply low 16 bit fields of each 32-bit field of regs rs3 and rs2
        elsif mah = '1' then
            
        elsif msl = '1' then

        elsif msh = '1' then

        elsif bcw = '1' then

        elsif and_instr = '1' then
          res <= rs1 and rs2;
        elsif or_instr = '1' then
          res <= rs1 or rs2;
        elsif popcnth = '1' then
          
        elsif clz = '1' then

        elsif rot = '1' then

        elsif shlhi = '1' then

        elsif a = '1' then
          
        elsif sfw = '1' then

        elsif ah = '1' then

        elsif sfh = '1' then

        elsif ahs = '1' then

        elsif sfhs = '1' then

        elsif mpyu = '1' then

        elsif absdb = '1' then

        end if;
        end process 
        
end architecture;
