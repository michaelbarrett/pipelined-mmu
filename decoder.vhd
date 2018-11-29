-- Decoder, combinational module
-- converts an instruction with an opcode into control signals understood by the alu

library IEEE;
use IEEE.std_logic_1164.all;n
use IEEE.numeric_std.all;

entity decoder is
  port(
    -- data inputs:
    instr : in std_logic_vector(24 downto 0); -- an instruction
    -- data control outputs (TO ALU):
    li : out std_logic;
    mal, mah, msl, msh : out std_logic;
    nop, bcw, and_instr, or_instr, popcnth, clz, rot, shlhi, a, sfw, ah, sfh, ahs, sfhs, mpyu, absdb : out std_logic;
    -- data instruction outputs (TO RF):
    -- for li
    li_for_li : out std_logic_vector(2 downto 0);
    imm_for_li : out std_logic_vector(15 downto 0);
    rd_for_li : out std_logic_vector(4 downto 0);
    -- for ma/ms/l/h
    rs3_for_m : out std_logic_vector(4 downto 0);
    rs2_for_m : out std_logic_vector(4 downto 0);
    rs1_for_m : out std_logic_vector(4 downto 0);
    rd_for_m : out std_logic_vector(4 downto 0);
    -- for r3 format
    opcode_for_r3 : out std_logic_vector(7 downto 0);
    rs2_for_r3 : out std_logic_vector(4 downto 0);
    rs1_for_r3 : out std_logic_vector(4 downto 0);
    rd_for_r3 : out std_logic_vector(4 downto 0);
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

    if instr(24) = '0' then -- if statement: sets one of the oups to 1 to signify the instruction
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

    li_for_li <= instr(23 downto 21);
    imm_for_li <= instr(20 downto 5); 
    rd_for_li <= instr(4 downto 0);
    -- for ma/ms/l/h
    rs3_for_m <= instr(19 downto 15);
    rs2_for_m <= instr(14 downto 10);
    rs1_for_m <= instr(9 downto 5);
    rd_for_m <= instr(4 downto 0);
    -- for r3 format
    opcode_for_r3 <= instr(22 downto 15);
    rs2_for_r3 <= instr(14 downto 10);
    rs1_for_r3 <= instr(9 downto 5);
    rd_for_r3 <= instr(4 downto 0);

  end process DecProc;

end architecture;
