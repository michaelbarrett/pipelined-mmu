-- Decoder, combinational module
-- converts an instruction with an opcode into control signals understood by the alu

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
  port(
    -- data inputs:
    instr : in std_logic_vector(24 downto 0); -- an instruction
    -- data control outputs (TO ALU):
    -- 0 nop, 1 li, 2 3 4 5 mal mah msl msh, 6 bcw, 7 and, 8 or, 9 popcnth, 10 clz,
    -- 11 rot, 12 shlhi, 13 a, 14 sfw, 15 ah, 16 sfh, 17 ahs, 18 sfhs, 19 mpyu, 20 absdb
    instr_num_out : out unsigned(5 downto 0); -- contains 0-20
    -- data instruction outputs (TO RF):
    -- for li
    li_for_li : out std_logic_vector(2 downto 0);
    imm_for_li : out std_logic_vector(15 downto 0);
    -- for ma/ms/l/h
    rs3_addr : out std_logic_vector(4 downto 0);
    rs2_addr : out std_logic_vector(4 downto 0);
    rs1_addr : out std_logic_vector(4 downto 0);
    rd_addr : out std_logic_vector(4 downto 0);
    -- for r3 format
    opcode_for_r3 : out std_logic_vector(7 downto 0);
    -- for shlhi [r3]
    rs2_for_shlhi : out std_logic_vector(4 downto 0)
    );
end entity;

architecture conversion of decoder is	
signal rs3_addr_temp : std_logic_vector(4 downto 0);
signal rs2_addr_temp : std_logic_vector(4 downto 0);
signal rs1_addr_temp : std_logic_vector(4 downto 0);
signal rd_addr_temp : std_logic_vector(4 downto 0);
signal opcode_for_r3_temp : std_logic_vector(7 downto 0);

signal instr_num : unsigned(5 downto 0);

begin

  DecProc : process(instr) is

  begin

    instr_num <= "000000"; -- init instr output to zero

    if instr(24) = '0' then -- if statement: sets one of the oups to 1 to signify the instruction
      instr_num <= "000001"; --1 li
    elsif (instr(23) = '0' and instr(21) = '0' and instr(20) = '0') then
      instr_num <= "000010"; --2 mal
    elsif (instr(23) = '0' and instr(21) = '0' and instr(20) = '1') then
      instr_num <= "000011"; --3 mah
    elsif (instr(23) = '0' and instr(21) = '1' and instr(20) = '0') then
      instr_num <= "000100"; --4 msl
    elsif (instr(23) = '0' and instr(21) = '1' and instr(20) = '1') then
      instr_num <= "000101"; --5 msh
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '0' and instr(15) = '0') then
      instr_num <= "000000"; --0 nop
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '0' and instr(15) = '1') then
      instr_num <= "000110"; --6 bcw
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '1' and instr(15) = '0') then
      instr_num <= "000111"; --7 and      
    elsif (instr(18) = '0' and instr(17) = '0' and instr(16) = '1' and instr(15) = '1') then
      instr_num <= "001000"; --8 or      
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '0' and instr(15) = '0') then
      instr_num <= "001001"; --9 popcnth      
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '0' and instr(15) = '1') then
      instr_num <= "001010"; --10 clz      
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '1' and instr(15) = '0') then
      instr_num <= "001011"; --11 rot      
    elsif (instr(18) = '0' and instr(17) = '1' and instr(16) = '1' and instr(15) = '1') then
      instr_num <= "001100"; --12 shlhi      
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '0' and instr(15) = '0') then
      instr_num <= "001101"; --13 a      
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '0' and instr(15) = '1') then
      instr_num <= "001110"; --14 sfw      
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '1' and instr(15) = '0') then
      instr_num <= "001111"; --15 ah      
    elsif (instr(18) = '1' and instr(17) = '0' and instr(16) = '1' and instr(15) = '1') then
      instr_num <= "010000"; --16 sfh      
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '0' and instr(15) = '0') then
      instr_num <= "010001"; --17 ahs      
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '0' and instr(15) = '1') then
      instr_num <= "010010"; --18 sfhs      
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '1' and instr(15) = '0') then
      instr_num <= "010011"; --19 mpyu      
    elsif (instr(18) = '1' and instr(17) = '1' and instr(16) = '1' and instr(15) = '1') then
      instr_num <= "010100"; --20 absdb      
    end if;

    -- for li
    if instr(24) = '0' then
      li_for_li <= instr(23 downto 21);
      imm_for_li <= instr(20 downto 5);
      rd_addr_temp <= instr(4 downto 0);
      rs3_addr_temp <= "ZZZZZ";
      rs2_addr_temp <= "ZZZZZ";
      rs1_addr_temp <= "ZZZZZ";	
      opcode_for_r3_temp <= "ZZZZZZZZ"; 
    -- for ma/ms/l/h
    elsif instr(24) = '1' and instr(23) = '0' then
      li_for_li <= instr(23 downto 21);
      rs3_addr_temp <= instr(19 downto 15);
      rs2_addr_temp <= instr(14 downto 10);
      rs1_addr_temp <= instr(9 downto 5);
      rd_addr_temp <= instr(4 downto 0);
      opcode_for_r3_temp <= "ZZZZZZZZ";
    -- for r3 format
    else
      opcode_for_r3_temp <= instr(22 downto 15);
      rs3_addr_temp <= "ZZZZZ";
      rs2_addr_temp <= instr(14 downto 10);
      rs1_addr_temp <= instr(9 downto 5);
      rd_addr_temp <= instr(4 downto 0);
    end if;

  end process DecProc;
  instr_num_out <= instr_num;
  rs3_addr <= rs3_addr_temp;
rs2_addr <= rs2_addr_temp;
rs1_addr <= rs1_addr_temp;
rd_addr <= rd_addr_temp;
  opcode_for_r3 <= opcode_for_r3_temp;
end architecture conversion;
