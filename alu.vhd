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

  bepgin

-- perform different operations to the inputs based on the opcode

    AluProc : process(rs1, rs2, rs3, imm, instr_num) is

      --vars for signed instrs
      --low fields
      variable s2_lf1 : signed(15 downto 0) := signed(rs2(15 downto 0));
      variable s2_lf2 : signed(15 downto 0) := signed(rs2(47 downto 32));
      variable s2_lf3 : signed(15 downto 0) := signed(rs2(79 downto 64));
      variable s2_lf4 : signed(15 downto 0) := signed(rs2(111 downto 96));
      variable s3_lf1 : signed(15 downto 0) := signed(rs3(15 downto 0));
      variable s3_lf2 : signed(15 downto 0) := signed(rs3(47 downto 32));
      variable s3_lf3 : signed(15 downto 0) := signed(rs3(79 downto 64));
      variable s3_lf4 : signed(15 downto 0) := signed(rs3(111 downto 96));
      --high fields
      variable s2_hf1 : signed(15 downto 0) := signed(rs2(31 downto 16));
      variable s2_hf2 : signed(15 downto 0) := signed(rs2(63 downto 48));
      variable s2_hf3 : signed(15 downto 0) := signed(rs2(95 downto 80));
      variable s2_hf4 : signed(15 downto 0) := signed(rs2(127 downto 112));
      variable s3_hf1 : signed(15 downto 0) := signed(rs3(31 downto 16));
      variable s3_hf2 : signed(15 downto 0) := signed(rs3(63 downto 48));
      variable s3_hf3 : signed(15 downto 0) := signed(rs3(95 downto 80));
      variable s3_hf4 : signed(15 downto 0) := signed(rs3(127 downto 112));
      --halfword slots of rs1
      variable s1_lf1 : signed(15 downto 0) := signed(rs1(15 downto 0));
      variable s1_hf1 : signed(15 downto 0) := signed(rs2(31 downto 16));
      variable s1_lf2 : signed(15 downto 0) := signed(rs1(47 downto 32));
      variable s1_hf2 : signed(15 downto 0) := signed(rs2(63 downto 48));
      variable s1_lf3 : signed(15 downto 0) := signed(rs1(79 downto 64));
      variable s1_hf3 : signed(15 downto 0) := signed(rs2(95 downto 80));
      variable s1_lf4 : signed(15 downto 0) := signed(rs1(111 downto 96));
      variable s1_hf4 : signed(15 downto 0) := signed(rs2(127 downto 112));     
      --to be computed
      variable count : unsigned(4 downto 0) := "00000"; -- for popcnth
      variable res1 : signed(31 downto 0);
      variable res2 : signed(31 downto 0);
      variable res3 : signed(31 downto 0);
      variable res4 : signed(31 downto 0);
      variable s1_f1 : signed(31 downto 0); -- for ma/s/l
      variable s1_f2 : signed(31 downto 0);
      variable s1_f3 : signed(31 downto 0);
      variable s1_f4 : signed(31 downto 0);
      variable d_lf1 : unsigned(15 downto 0); -- for popcnth
      variable d_hf1 : unsigned(15 downto 0);
      variable d_lf2 : unsigned(15 downto 0);
      variable d_hf2 : unsigned(15 downto 0);
      variable d_lf3 : unsigned(15 downto 0);
      variable d_hf3 : unsigned(15 downto 0);
      variable d_lf4 : unsigned(15 downto 0);
      variable d_hf4 : unsigned(15 downto 0);      
    begin

      --Load a 16-bit immediate value from the [20:5] instruction field into the 16-bit field specified by the li field [23-21] of the 128-bit register rd.
      if instr_num = 1 then -- li
        --res <= std_logic_vector(resize(signed(imm), res'length));
        if (li = "000") then
          res <= "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000" & imm;
        elsif (li = "001") then
          res <= "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000" & imm & "0000_0000_0000_0000";
        elsif (li = "010") then
          res <= "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000" & "0000_0000_0000_0000" & imm & "0000_0000_0000_0000" & "0000_0000_0000_0000";
        elsif (li = "011") then
          res <= "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000" & imm & "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000";
        elsif (li = "100") then
          res <= "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000" & imm & "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        elsif (li = "101") then
          res <= "0000_0000_0000_0000" & "0000_0000_0000_0000" & imm & "0000_0000_0000_0000" & "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        elsif (li = "110") then
          res <= "0000_0000_0000_0000" & imm & "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";
        elsif (li = "111") then
          res <= imm & "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000" & "0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000";          
        end if;

      --Signed integer multiple-add low with saturation: Multiply low 16-bit-fields of each 32-bit field of registers rs3 and rs2, then add 32-bit products to 32-bit fields of register rs1, and save result in register rd.
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
          res2 := to_signed(-2**31, res2'length);
        elsif (s2_lf2 * s3_lf2 > 0) then
          res2 := to_signed(2**31 - 1, res2'length);
        end if;
        
        if ((s2_lf3 * s3_lf3 < 2**31-1) and (s2_lf3 * s3_lf3 > -2**31)) then
          res3 := s2_lf3 * s3_lf3;
        elsif (s2_lf3 * s3_lf3 < 0) then
          res3 := to_signed(-2**31, res3'length);
        elsif (s2_lf3 * s3_lf3 > 0) then
          res3 := to_signed(2**31 - 1, res3'length);
        end if;
        
        if ((s2_lf4 * s3_lf4 < 2**31-1) and (s2_lf4 * s3_lf4 > -2**31)) then
          res4 := s2_lf4 * s3_lf4;
        elsif (s2_lf4 * s3_lf4 < 0) then
          res4 := to_signed(-2**31, res4'length);
        elsif (s2_lf4 * s3_lf4 > 0) then
          res4 := to_signed(2**31 - 1, res4'length);
        end if;
        -- add these products to 32-bit fields of reg rs1
        -- get 32 bit fields of rs1 and add to them, checking saturation
        s1_f1 := signed(rs1(15 downto 0)) + res1;          
        s1_f2 := signed(rs1(63 downto 32)) + res2;
        s1_f3 := signed(rs1(95 downto 64)) + res3;
        s1_f4 := signed(rs1(127 downto 96)) + res4;
        -- output to res
        res <= std_logic_vector(s1_f4 & s1_f3 & s1_f2 & s1_f1); --4 * 32 = 128               

      --Signed integer multiple-add high with saturation: Multiply high 16-bit-fields of each 32-bit field of registers rs3 and rs2, then add 32-bit products to 32-bit fields of register rs1, and save result in register rd.
      elsif instr_num = 3 then -- mah
        -- multiply high 16 bit fields of each 32-bit field of regs rs3 and rs2
        -- make 32-bit products
        if ((s2_hf1 * s3_hf1 < 2**31-1) and (s2_hf1 * s3_hf1 > -2**31)) then
          res1 := s2_hf1 * s3_hf1;
        elsif (s2_hf1 * s3_hf1 < 0) then
          -- different signs and output is positive means invoke saturation
          res1 := to_signed(-2**31, res1'length);
        elsif (s2_hf1 * s3_hf1 > 0) then
          -- same signs and output is negative means invoke saturation
          res1 := to_signed(2**31 - 1, res1'length);
        end if;
        
        if ((s2_hf2 * s3_hf2 < 2**31-1) and (s2_hf2 * s3_hf2 > -2**31)) then
          res2 := s2_hf2 * s3_hf2;
        elsif (s2_hf2 * s3_hf2 < 0) then
          res2 := to_signed(-2**31, res2'length);
        elsif (s2_hf2 * s3_hf2 > 0) then
          res2 := to_signed(2**31 - 1, res2'length);
        end if;
        
        if ((s2_hf3 * s3_hf3 < 2**31-1) and (s2_hf3 * s3_hf3 > -2**31)) then
          res3 := s2_hf3 * s3_hf3;
        elsif (s2_hf3 * s3_hf3 < 0) then
          res3 := to_signed(-2**31, res3'length);
        elsif (s2_hf3 * s3_hf3 > 0) then
          res3 := to_signed(2**31 - 1, res3'length);
        end if;
        
        if ((s2_hf4 * s3_hf4 < 2**31-1) and (s2_hf4 * s3_hf4 > -2**31)) then
          res4 := s2_hf4 * s3_hf4;
        elsif (s2_hf4 * s3_hf4 < 0) then
          res4 := to_signed(-2**31, res4'length);
        elsif (s2_hf4 * s3_hf4 > 0) then
          res4 := to_signed(2**31 - 1, res4'length);
        end if;
        -- add these products to 32-bit fields of reg rs1
        -- get 32 bit fields of rs1 and add to them, checking saturation
        s1_f1 := signed(rs1(15 downto 0)) + res1;          
        s1_f2 := signed(rs1(63 downto 32)) + res2;
        s1_f3 := signed(rs1(95 downto 64)) + res3;
        s1_f4 := signed(rs1(127 downto 96)) + res4;
        -- output to res
        res <= std_logic_vector(s1_f4 & s1_f3 & s1_f2 & s1_f1);       

      --Signed integer multiple-subtract low with saturation: Multiply low 16-bit-fields of each 32-bit field of registers rs3 and rs2, then subtract 32-bit products from 32-bit fields of register rs1, and save result in register rd.
      elsif instr_num = 4 then -- msl
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
          res2 := to_signed(-2**31, res2'length);
        elsif (s2_lf2 * s3_lf2 > 0) then
          res2 := to_signed(2**31 - 1, res2'length);
        end if;
        
        if ((s2_lf3 * s3_lf3 < 2**31-1) and (s2_lf3 * s3_lf3 > -2**31)) then
          res3 := s2_lf3 * s3_lf3;
        elsif (s2_lf3 * s3_lf3 < 0) then
          res3 := to_signed(-2**31, res3'length);
        elsif (s2_lf3 * s3_lf3 > 0) then
          res3 := to_signed(2**31 - 1, res3'length);
        end if;
        
        if ((s2_lf4 * s3_lf4 < 2**31-1) and (s2_lf4 * s3_lf4 > -2**31)) then
          res4 := s2_lf4 * s3_lf4;
        elsif (s2_lf4 * s3_lf4 < 0) then
          res4 := to_signed(-2**31, res4'length);
        elsif (s2_lf4 * s3_lf4 > 0) then
          res4 := to_signed(2**31 - 1, res4'length);
        end if;
        -- add these products to 32-bit fields of reg rs1
        -- get 32 bit fields of rs1 and add to them, checking saturation
        s1_f1 := signed(rs1(15 downto 0)) - res1;          
        s1_f2 := signed(rs1(63 downto 32)) - res2;
        s1_f3 := signed(rs1(95 downto 64)) - res3;
        s1_f4 := signed(rs1(127 downto 96)) - res4;
        -- output to res
        res <= std_logic_vector(s1_f4 & s1_f3 & s1_f2 & s1_f1);        

      --Signed integer multiple-subtract high with saturation: Multiply high 16-bit-fields of each 32-bit field of registers rs3 and rs2, then subtract 32-bit products from 32-bit fields of register rs1, and save result in register rd.
      elsif instr_num = 5 then -- msh
        -- multiply high 16 bit fields of each 32-bit field of regs rs3 and rs2
        -- make 32-bit products
        if ((s2_hf1 * s3_hf1 < 2**31-1) and (s2_hf1 * s3_hf1 > -2**31)) then
          res1 := s2_hf1 * s3_hf1;
        elsif (s2_hf1 * s3_hf1 < 0) then
          -- different signs and output is positive means invoke saturation
          res1 := to_signed(-2**31, res1'length);
        elsif (s2_hf1 * s3_hf1 > 0) then
          -- same signs and output is negative means invoke saturation
          res1 := to_signed(2**31 - 1, res1'length);
        end if;
        
        if ((s2_hf2 * s3_hf2 < 2**31-1) and (s2_hf2 * s3_hf2 > -2**31)) then
          res2 := s2_hf2 * s3_hf2;
        elsif (s2_hf2 * s3_hf2 < 0) then
          res2 := to_signed(-2**31, res2'length);
        elsif (s2_hf2 * s3_hf2 > 0) then
          res2 := to_signed(2**31 - 1, res2'length);
        end if;
        
        if ((s2_hf3 * s3_hf3 < 2**31-1) and (s2_hf3 * s3_hf3 > -2**31)) then
          res3 := s2_hf3 * s3_hf3;
        elsif (s2_hf3 * s3_hf3 < 0) then
          res3 := to_signed(-2**31, res3'length);
        elsif (s2_hf3 * s3_hf3 > 0) then
          res3 := to_signed(2**31 - 1, res3'length);
        end if;
        
        if ((s2_hf4 * s3_hf4 < 2**31-1) and (s2_hf4 * s3_hf4 > -2**31)) then
          res4 := s2_hf4 * s3_hf4;
        elsif (s2_hf4 * s3_hf4 < 0) then
          res4 := to_signed(-2**31, res4'length);
        elsif (s2_hf4 * s3_hf4 > 0) then
          res4 := to_signed(2**31 - 1, res4'length);
        end if;
        -- add these products to 32-bit fields of reg rs1
        -- get 32 bit fields of rs1 and add to them, checking saturation
        s1_f1 := signed(rs1(15 downto 0)) - res1;          
        s1_f2 := signed(rs1(63 downto 32)) - res2;
        s1_f3 := signed(rs1(95 downto 64)) - res3;
        s1_f4 := signed(rs1(127 downto 96)) - res4;
        -- output to res
        res <= std_logic_vector(s1_f4 & s1_f3 & s1_f2 & s1_f1);

        --bcw: broadcast a ("the") right 32-bit word of register rs1 to each of the  four 32-bit words of register rd.
      elsif instr_num = 6 then -- bcw
        s1_f1 := signed(rs1(31 downto 0));
        s1_f2 := signed(rs1(31 downto 0));
        s1_f3 := signed(rs1(31 downto 0));
        s1_f4 := signed(rs1(31 downto 0));        
        res <= std_logic_vector(s1_f4 & s1_f3 & s1_f2 & s1_f1);

        --and: bitwise logical and
      elsif instr_num = 7 then -- and
        res <= rs1 and rs2;

        --or: bitwise logical or
      elsif instr_num = 8 then -- or
        res <= rs1 or rs2;

        --popcnth: count ones in halfwords: the number of 1s in each of the four
        --("8") halfword-slots in register rs1 is computed. If the halfword slot in register rs1 is zero, the result is 0. Each of the results is placed into corresponding 16-bit slot in register rd. (Comments: 8 separate 16-bit halfword values in each 128-bit register)
      elsif instr_num = 9 then -- popcnth
        d_lf1 <= "0000000000000000";   --initialize count variable (16-bit halfword value.)
        for i in 0 to 15 loop   --for all the bits.
          d_lf1 := d_lf1 + ("000000000000000" & s1_lf1(i));  --Add the bit to the count
        end loop;
        
        d_hf1 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_hf1 := d_hf1 + ("000000000000000" & s1_hf1(i));  --Add the bit to the count
        end loop;

        d_lf2 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_lf2 := d_lf2 + ("000000000000000" & s1_lf2(i));  --Add the bit to the count
        end loop;

        d_hf2 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_hf2 := d_hf2 + ("000000000000000" & s1_hf2(i));  --Add the bit to the count
        end loop;

        d_lf3 <= "0000000000000000";   --initialize count variable (16-bit halfword value.)
        for i in 0 to 15 loop   --for all the bits.
          d_lf3 := d_lf3 + ("000000000000000" & s1_lf3(i));  --Add the bit to the count
        end loop;
        
        d_hf3 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_hf3 := d_hf3 + ("000000000000000" & s1_hf3(i));  --Add the bit to the count
        end loop;

        d_lf4 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_lf4 := d_lf4 + ("000000000000000" & s1_lf4(i));  --Add the bit to the count
        end loop;

        d_hf4 <= "0000000000000000";   --initialize count variable.
        for i in 0 to 15 loop   --for all the bits.
          d_hf4 := d_hf4 + ("000000000000000" & s1_hf4(i));  --Add the bit to the count
        end loop;
        res <= std_logic_vector(d_lf1 & d_hf1 & d_lf2 & d_hf2 & d_lf3 & d_hf3 & d_lf4 & d_hf4);

      -- count leading zeroes in words: for each of the two 32-bit word slots in register rs1 the number of zero bits to the left of the first non-zero bit is computed. If the word slot in register rs1 is zero, the result is 32. The two results are placed into the corresponding 32-bit word slots in register rd. (Comments: 4 separate 32-bit values in each 128-bit register)  
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
