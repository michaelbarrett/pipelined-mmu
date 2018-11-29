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
    instr_num : in unsigned(5 downto 0);

--  data outputs:
    res : out std_logic_vector(127 downto 0);

--  flag outputs:
    zero : out std_logic;    
    );
end entity;

architecture behavioral of alu is

  begin

-- perform different operations to the inputs based on the opcode

    process(rs1, rs2, rs3)

      begin

        if instr_num = 1 then -- li
          res <= imm;
        elsif mal = '1' then
          -- multiply low 16 bit fields of each 32-bit field of regs rs3 and rs2
          variable s2_lf1 : signed(15 downto 0);
          s2_lf1 := rs2(15 downto 0);
          variable s2_lf2 : signed(15 downto 0);
          s2_lf2 := rs2(47 downto 32);
          variable s2_lf3 : signed(15 downto 0);
          s2_lf3 := rs2(79 downto 64);
          variable s2_lf4 : signed(15 downto 0);
          s2_lf4 := rs2(112 downto 96);

          variable s2_lf1 : signed(15 downto 0);
          s2_lf1 := rs2(15 downto 0);
          variable s2_lf2 : signed(15 downto 0);
          s2_lf2 := rs2(47 downto 32);
          variable s2_lf3 : signed(15 downto 0);
          s2_lf3 := rs2(79 downto 64);
          variable s2_lf4 : signed(15 downto 0);
          s2_lf4 := rs2(112 downto 96);

          -- make 32-bit products
          variable res1 : signed(31 downto 0);
          res1 := s2_lf1 * s3_lf1;
          if (res1 > 0) and (s2_lf1(s2_lf1'left) xor s3_lf1(s3_lf1'left)) then
            -- different signs and output is positive means invoke saturation
            res1 := -2**31;
          elsif (res2 < 0) and (s2_lf1(s2_lf1'left) xnor s3_lf1(s3_lf1'left)) then
            -- same signs and output is negative means invoke saturation
            res1 := 2**31 - 1;
          end if;
          
          variable res2 : signed(31 downto 0);
          res2 := s2_lf2 * s3_lf2;
          if (res1 > 0) and (s2_lf1(s2_lf1'left) xor s3_lf1(s3_lf1'left)) then
            -- different signs and output is positive means invoke saturation
            res1 := -2**31;
          elsif (res2 < 0) and (s2_lf1(s2_lf1'left) xnor s3_lf1(s3_lf1'left)) then
            -- same signs and output is negative means invoke saturation
            res1 := 2**31 - 1;
          end if;
          
          variable res3 : signed(31 downto 0);
          res3 := s2_lf3 * s3_lf3;
          if (res1 > 0) and (s2_lf1(s2_lf1'left) xor s3_lf1(s3_lf1'left)) then
            -- different signs and output is positive means invoke saturation
            res1 := -2**31;
          elsif (res2 < 0) and (s2_lf1(s2_lf1'left) xnor s3_lf1(s3_lf1'left)) then
            -- same signs and output is negative means invoke saturation
            res1 := 2**31 - 1;
          end if;
          
          variable res4 : signed(31 downto 0);
          if ((s2_lf4 * s3_lf4 < 2**31-1) and (s2_lf4 * s3_lf4 > -2**31)) then
            res4 := s2_lf4 * s3_lf4;
          elsif (s2_lf4 * s3_lf4 < 0) then
            -- different signs and output is positive means invoke saturation
            res4 := -2**31;
          elsif (s2_lf4 * s3_lf4 > 0) then
            -- same signs and output is negative means invoke saturation
            res4 := 2**31 - 1;
          end if;
          
          -- add these products to 32-bit fields of reg rs1
          -- get 32 bit fields of rs1 and add to them, checking saturation
          variable s1_f1 : signed(31 downto 0);
          s1_f1 := rs1(15 downto 0) + res1;          
          variable s1_f2 : signed(31 downto 0);
          s1_f2 := rs1(63 downto 32) + res2;
          variable s1_f3 : signed(31 downto 0);
          s1_f3 := rs1(95 downto 64) + res3;
          variable s1_f4 : signed(31 downto 0);
          s1_f4 := rs1(127 downto 96) + res4;
          
          -- output to res to save in rd
          
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
