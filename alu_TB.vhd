library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_TB is
end alu_TB;

architecture alu_TB of alu_TB is

signal clk : std_logic := '0';
signal rs1, rs2, rs3, rd : std_logic_vector(127 downto 0);
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
		rd => rd,
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
	rs1 <= std_logic_vector(X"1111_1110_1100_1000_0001_0011_0111_1111");
	rs2 <= std_logic_vector(X"0001_0010_0001_0011_0001_0010_0001_0011");
	rs3 <= std_logic_vector(X"0001_0001_0001_0001_0001_0001_0001_0001");
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
	--popcnth
	instr_num <= to_unsigned(9, instr_num'length); wait for clk_period;
	--clz
	instr_num <= to_unsigned(10, instr_num'length); wait for clk_period;
	--rot
	instr_num <= to_unsigned(11, instr_num'length); wait for clk_period;
	--shlhi
	instr_num <= to_unsigned(12, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(13, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(14, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(15, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(16, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(17, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(18, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(19, instr_num'length); wait for clk_period;
	instr_num <= to_unsigned(20, instr_num'length); wait for clk_period;
	wait;
end process;

end alu_TB;
