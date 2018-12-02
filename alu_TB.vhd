library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_TB is
end alu_TB;

architecture alu_TB of alu_TB is

signal clk : std_logic := '0';
signal rs1, rs2, rs3 : std_logic_vector(127 downto 0);
signal res : std_logic_vector(127 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal li : std_logic_vector(2 downto 0);
signal rs2_for_shlhi : std_logic_vector(4 downto 0);
signal instr_num : unsigned(5 downto 0);
constant clk_period : time := 10 ns;

begin

-- instantiate the uut
	uut: entity work.alu PORT MAP (
		rs1 => rs1,
		rs2 => rs2,
		rs3 => rs3,
		res => res,
		imm => imm,
		li => li,
		rs2_for_shlhi => rs2_for_shlhi,
		instr_num => instr_num
		);
		
-- clock process definitions
clk_process : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;

-- stimulus process
stim_proc : process
begin
	wait for clk_period*1;
	rs1 <= std_logic_vector(to_unsigned(3, rs1'length));
	rs2 <= std_logic_vector(to_unsigned(6, rs2'length));
	rs3 <= std_logic_vector(to_unsigned(9, rs3'length));
	imm <= std_logic_vector(to_unsigned(12, imm'length));
	li <= std_logic_vector(to_unsigned(0, li'length));
	rs2_for_shlhi <= std_logic_vector(to_unsigned(2, rs2_for_shlhi'length));
	instr_num <= to_unsigned(1, instr_num'length); wait for clk_period;
	li <= std_logic_vector(to_unsigned(1, li'length));
	instr_num <= to_unsigned(1, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(2, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(3, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(4, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(5, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(6, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(7, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(8, instr_num'length); wait for clk_period;
	wait;
end process;

end alu_TB;
