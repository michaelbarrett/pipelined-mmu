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
    li : out std_logic;
    mal, mah, msl, msh : out std_logic;
    nop, bcw, and_instr, or_instr, popcnth, clz, rot, shlhi, a, sfw, ah, sfh, ahs, sfhs, mpyu, absdb : out std_logic;
    );
end entity;

architecture conversion of decoder is

begin

  DecProc : process(opcode) is

  begin

    li <= '0'; -- init all oups to zero
    mal <= '0';
    mah <= '0';
    msl <= '0';
    msh <= '0';
    nop <= '0';
    bcw <= '0';
    and_instr <= '0';
    or_instr <= '0';
    popcnth <= '0';
    clz <= '0';
    rot <= '0';
    shlhi <= '0';
    a <= '0';
    sfw <= '0';
    ah <= '0';
    sfh <= '0';
    ahs <= '0';
    sfhs <= '0';
    mpyu <= '0';
    absdb <= '0';

    if instr(24) = '0' then
      li <= '1';
    elsif (instr(23) = '0' and instr(21) = '0' and instr(20) = '0') then
      mal <= '1';
    elsif (instr(23) = '0' and instr(21) = '0' and instr(20) = '1') then
      mah <= '1';
    elsif (instr(23) = '0' and instr(21) = '1' and instr(20) = '0') then
      msl <= '1';
    elsif (instr(23) = '0' and instr(21) = '1' and instr(20) = '1') then
      msh <= '1';
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '0' and instr(15) = '0') then
      nop <= '1'; 
    elsif (instr(18) = '0' and instr(17) = '0' and instr(17) = '0' and instr(15) = '1') then
      bcw <= '1';
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '1' and instr(15) = '0') then
      and_instr <= '1'; 
    elsif (instr(18) = '0' and instr(17) = '0' and instr(17) = '1' and instr(15) = '1') then
      or_instr <= '1';
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '0' and instr(15) = '0') then
      popcnth <= '1'; 
    elsif (instr(18) = '0' and instr(17) = '1' and instr(17) = '0' and instr(15) = '1') then
      clz <= '1';
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '1' and instr(15) = '0') then
      rot <= '1'; 
    elsif (instr(18) = '0' and instr(17) = '1' and instr(17) = '1' and instr(15) = '1') then
      shlhi <= '1';
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '0' and instr(15) = '0') then
      a <= '1'; 
    elsif (instr(18) = '1' and instr(17) = '0' and instr(17) = '0' and instr(15) = '1') then
      sfw <= '1';
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '1' and instr(15) = '0') then
      ah <= '1'; 
    elsif (instr(18) = '1' and instr(17) = '0' and instr(17) = '1' and instr(15) = '1') then
      sfh <= '1';
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '0' and instr(15) = '0') then
      ahs <= '1'; 
    elsif (instr(18) = '1' and instr(17) = '1' and instr(17) = '0' and instr(15) = '1') then
      sfhs <= '1';
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '1' and instr(15) = '0') then
      mpyu <= '1'; 
    elsif (instr(18) = '1' and instr(17) = '1' and instr(17) = '1' and instr(15) = '1') then
      absdb <= '1';
    end if;

end architecture;
