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
	
	rd_value_read : out std_logic_vector(127 downto 0); -- read rd value
	r3_value : out std_logic_vector(127 downto 0);
	r2_value : out std_logic_vector(127 downto 0);
	r1_value : out std_logic_vector(127 downto 0);

-- Stage 3: Execute & Write-back -- 
    rd_value : out std_logic_vector(127 downto 0); -- rd value to write
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
signal r1_value_ab, r2_value_ab, r3_value_ab, rd_value_read_ab: std_logic_vector(127 downto 0);
signal li_for_li_ab : std_logic_vector(2 downto 0);
signal imm_for_li_ab : std_logic_vector(15 downto 0);
signal rs2_for_shlhi : std_logic_vector(4 downto 0);
signal rs2_for_shlhi_ab, rd_addr_ab : std_logic_vector(4 downto 0);
signal control_signals_ab : unsigned(5 downto 0);		
signal rd_value_in_read : std_logic_vector(127 downto 0);
signal current_rd_out, 	next_rd_out: std_logic_vector(4 downto 0);
signal w_data_in1_res, current_rd_value_out : std_logic_vector(127 downto 0);

begin 
	u0: entity program_counter port map (clk => clk, rst_n => rst_bar, count=>count);
		
	u1: entity ib port map (load_mode => rst_bar, program_counter => count, data_in => instrs, instr_out => instr_out);	 
		
	u2: entity if_id_register port map(clk => clk, rst_bar => rst_bar, instr_in => instr_out, instr_out => instr_out_buffer); 
		
	u3: entity decoder port map (instr => instr_out_buffer, instr_num_out => control_signals, li_for_li => li_for_li, imm_for_li => imm_for_li,
		rs3_addr => rs3_addr, rs2_addr => rs2_addr, rs1_addr => rs1_addr, rd_addr => rd_addr,  
		opcode_for_r3 => opcode_for_r3, rs2_for_shlhi => rs2_for_shlhi); 
		
	u4: entity rf port map (r_addr1 => rs1_addr, r_addr2 => rs2_addr, r_addr3 => rs3_addr,
		w_addr1 => rd_addr, w_data_in1 => w_data_in1_res, w_addr1_write => rd_addr_ab, r_data_out1 => r1_value, 
		r_data_out2 => r2_value, r_data_out3 => r3_value, r_data_outd => rd_value_read);
									  
	u5: entity id_exe_register port map(clk => clk, rst_bar => rst_bar, rs1_in => r1_value, rs2_in => r2_value, rs3_in => r3_value,
		li_in => li_for_li, imm_in => imm_for_li, control_signals_in => control_signals, rs1_out => r1_value_ab, rs2_out => r2_value_ab,
		rs3_out => r3_value_ab, li_out => li_for_li_ab, imm_out => imm_for_li_ab, control_signals_out => control_signals_ab, 
		rs2_for_shlhi_in => rs2_addr, rs2_for_shlhi_out => rs2_for_shlhi_ab,
		rd_in => rd_value_read, rd_out => rd_value_read_ab,
		rd_addr_in => rd_addr, rd_addr_out => rd_addr_ab);
	
	u6: entity alu port map (li => li_for_li_ab, rs1 => r1_value_ab, rs2 => r2_value_ab, rs3 => r3_value_ab, rd => w_data_in1,
		imm => imm_for_li_ab, rs2_for_shlhi => rs2_for_shlhi_ab, instr_num => control_signals_ab,
		res => w_data_in1_res, zero => zero); 
	
	u7: entity forwarding_buffer port map(clk => clk, rst_bar => rst_bar, current_rd_in => rd_addr, next_rd_in => rd_addr_ab, current_rd_value_in =>w_data_in1_res,
		current_rd_out => current_rd_out, next_rd_out => next_rd_out, current_rd_value_out => current_rd_value_out); 
		
	u8: entity fowarding_unit port map (current_rd => current_rd_out, next_rd => next_rd_out, stored_rd_value => current_rd_value_out, current_rd_value =>rd_value_read_ab,
		rd_value => w_data_in1);
		
end dataflow;
