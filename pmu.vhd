library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.ib_type_pkg.all;

entity pmu is
	port(
	clk : in std_logic;
	rst_bar : in std_logic;
	instrs: in ib_type;

--  Stage 2: Decode & Read Operands --
	opcode_for_r3: out std_logic_vector(7 downto 0);
	
    rs3_addr : out std_logic_vector(4 downto 0);
    rs2_addr : out std_logic_vector(4 downto 0);
    rs1_addr : out std_logic_vector(4 downto 0);
	
	r3_value : out std_logic_vector(127 downto 0);
	r2_value : out std_logic_vector(127 downto 0);
	r1_value : out std_logic_vector(127 downto 0);

-- Stage 3: Execute & Write-back -- 
    rd_value : out std_logic_vector(127 downto 0);
	zero :	 out std_logic 
	);
end pmu;	

architecture dataflow of pmu is
signal count : std_logic_vector(4 downto 0);
signal instr_out, instr_out_buffer: std_logic_vector(24 downto 0);
signal control_signals : unsigned(5 downto 0);
signal li_for_li : std_logic_vector(2 downto 0);
signal imm_for_li : std_logic_vector(15 downto 0);
signal rd_addr : std_logic_vector(4 downto 0);
signal w_data_in1 : std_logic_vector(127 downto 0);
signal r1_value_ab, r2_value_ab, r3_value_ab : std_logic_vector(127 downto 0);
signal li_for_li_ab : std_logic_vector(2 downto 0);
signal imm_for_li_ab : std_logic_vector(15 downto 0);
signal rs2_for_shlhi : std_logic_vector(4 downto 0);
signal rs2_for_shlhi_ab : std_logic_vector(4 downto 0);
signal control_signals_ab : unsigned(5 downto 0);

begin 
	u0: entity program_counter port map (clk => clk, rst_n => rst_bar, count=>count);
		
	u1: entity ib port map (load_mode => rst_bar, program_counter => count, data_in => instrs, instr_out => instr_out);	 
		
	u2: entity if_id_register port map(clk => clk, rst_bar => rst_bar, instr_in => instr_out, instr_out => instr_out_buffer); 
		
	u3: entity decoder port map (instr => instr_out_buffer, instr_num_out => control_signals, li_for_li => li_for_li, imm_for_li => imm_for_li,
		rs3_addr => rs3_addr, rs2_addr => rs2_addr, rs1_addr => rs1_addr, rd_addr => rd_addr, opcode_for_r3 => opcode_for_r3, rs2_for_shlhi => rs2_for_shlhi); 
		
	u4: entity rf port map (r_addr1 => rs1_addr, r_addr2 => rs2_addr, r_addr3 => rs3_addr,
		w_addr1 => rd_addr, w_data_in1 => w_data_in1, r_data_out1 => r1_value, r_data_out2 => r2_value,	r_data_out3 => r3_value);
		
	u5: entity id_exe_register port map(clk => clk, rst_bar => rst_bar, rs1_in => r1_value, rs2_in => r2_value, rs3_in => r3_value,
		li_in => li_for_li, imm_in => imm_for_li, control_signals_in => control_signals, rs1_out => r1_value_ab, rs2_out => r2_value_ab,
		rs3_out => r3_value_ab, li_out => li_for_li_ab, imm_out => imm_for_li_ab, control_signals_out => control_signals_ab, 
		rs2_for_shlhi_in => rs2_for_shlhi, rs2_for_shlhi_out => rs2_for_shlhi_ab);
	
	u6: entity alu port map (li => li_for_li_ab, rs1 => r1_value_ab, rs2 => r2_value_ab, rs3 => r3_value_ab, imm => imm_for_li_ab, rs2_for_shlhi => rs2_for_shlhi_ab, instr_num => control_signals_ab,
		res => w_data_in1, zero => zero); 
		
end dataflow;
