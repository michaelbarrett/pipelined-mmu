-- ALU, combinational module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
  port(
--  data inputs:
    rs1, rs2, rs3 : in std_logic_vector(127 downto 0);
    imm : in std_logic_vector(15 downto 0);
	li : in std_logic_vector(2 downto 0);
    
--  control inputs:
    instr_num : in unsigned(5 downto 0);

--  data outputs:
    res : out std_logic_vector(127 downto 0);

--  flag outputs:
    zero : out std_logic    
    );
end entity;

architecture behavioral of alu is

  begin

-- perform different operations to the inputs based on the opcode

AluProc : process(rs1, rs2, rs3, imm, instr_num) is

	  --vars for signed instrs
	  variable s2_lf1 : signed(15 downto 0) := signed(rs2(15 downto 0));
      variable s2_lf2 : signed(15 downto 0) := signed(rs2(47 downto 32));
      variable s2_lf3 : signed(15 downto 0) := signed(rs2(79 downto 64));
      variable s2_lf4 : signed(15 downto 0) := signed(rs2(111 downto 96));
      variable s3_lf1 : signed(15 downto 0) := signed(rs3(15 downto 0));
      variable s3_lf2 : signed(15 downto 0) := signed(rs3(47 downto 32));
      variable s3_lf3 : signed(15 downto 0) := signed(rs3(79 downto 64));
      variable s3_lf4 : signed(15 downto 0) := signed(rs3(111 downto 96));
	  variable res1 : signed(31 downto 0);
      variable res2 : signed(31 downto 0);
	  variable res3 : signed(31 downto 0);
	  variable res4 : signed(31 downto 0);
	  variable s1_f1 : signed(31 downto 0);
	  variable s1_f2 : signed(31 downto 0);
	  variable s1_f3 : signed(31 downto 0);
	  variable s1_f4 : signed(31 downto 0);
	begin

        if instr_num = 1 then -- li
          res <= std_logic_vector(resize(signed(imm), res'length));
        elsif instr_num = 2 then -- mal
          -- multiply low 16 bit fields of each 32-bit field of regs rs3 and rs2

          -- make 32-bit products

          if ((s2_lf1 * s3_lf1 < 2**31-1) and (s2_lf1 * s3_lf1 > -2**31)) then
            res1 := s2_lf1 * s3_lf1;
		  elsif (s2_lf1 * s3_lf1 < 0) then
			-- different signs and output is positive means invoke saturation
			res1 := to_signed(-2**31, res1'length);
          elsif (s2_lf1 * s3_lf1 > 0) then
            -- same signs and output is negative means invoke saturation
            res1 := to_signed(2**31 - 1, res1'length);
          end if;
          
          if ((s2_lf2 * s3_lf2 < 2**31-1) and (s2_lf2 * s3_lf2 > -2**31)) then
            res2 := s2_lf2 * s3_lf2;
		  elsif (s2_lf2 * s3_lf2 < 0) then
			-- different signs and output is positive means invoke saturation
			res2 := to_signed(-2**31, res2'length);
          elsif (s2_lf2 * s3_lf2 > 0) then
            -- same signs and output is negative means invoke saturation
            res2 := to_signed(2**31 - 1, res2'length);
          end if;
          
          if ((s2_lf3 * s3_lf3 < 2**31-1) and (s2_lf3 * s3_lf3 > -2**31)) then
            res3 := s2_lf3 * s3_lf3;
		  elsif (s2_lf3 * s3_lf3 < 0) then
			-- different signs and output is positive means invoke saturation
			res3 := to_signed(-2**31, res3'length);
          elsif (s2_lf3 * s3_lf3 > 0) then
            -- same signs and output is negative means invoke saturation
            res3 := to_signed(2**31 - 1, res3'length);
          end if;
          
          if ((s2_lf4 * s3_lf4 < 2**31-1) and (s2_lf4 * s3_lf4 > -2**31)) then
            res4 := s2_lf4 * s3_lf4;
          elsif (s2_lf4 * s3_lf4 < 0) then
            -- different signs and output is positive means invoke saturation
            res4 := to_signed(-2**31, res4'length);
          elsif (s2_lf4 * s3_lf4 > 0) then
            -- same signs and output is negative means invoke saturation
            res4 := to_signed(2**31 - 1, res4'length);
          end if;
          
          -- add these products to 32-bit fields of reg rs1
          -- get 32 bit fields of rs1 and add to them, checking saturation
          
          s1_f1 := signed(rs1(15 downto 0)) + res1;          
          
          s1_f2 := signed(rs1(63 downto 32)) + res2;
          
          s1_f3 := signed(rs1(95 downto 64)) + res3;
          
          s1_f4 := signed(rs1(127 downto 96)) + res4;
          
          -- output to res

          res <= std_logic_vector(s1_f1 & s1_f2 & s1_f3 & s1_f4);
          
        elsif instr_num = 3 then -- mah
            
        elsif instr_num = 4 then -- msl

        elsif instr_num = 5 then -- msh

        elsif instr_num = 6 then -- bcw

        elsif instr_num = 7 then -- and
          res <= rs1 and rs2;
        elsif instr_num = 8 then -- or
          res <= rs1 or rs2;
        elsif instr_num = 9 then -- popcnth
          
        elsif instr_num = 10 then -- clz

        elsif instr_num = 11 then -- rot

        elsif instr_num = 12 then -- shldi

        elsif instr_num = 13 then -- a
          
        elsif instr_num = 14 then -- sfw

        elsif instr_num = 15 then -- ah

        elsif instr_num = 16 then -- sfh

        elsif instr_num = 17 then -- ahs

        elsif instr_num = 18 then -- sfhs

        elsif instr_num = 19 then -- mpyu

        elsif instr_num = 20 then -- absdb

        end if;
        end process AluProc; 
        
end architecture behavioral;
