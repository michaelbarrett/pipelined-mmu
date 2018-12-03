library ieee;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_1164.all;
use work.ib_type_pkg.all;

entity pmu_tb is
end pmu_tb;

architecture behavior of pmu_tb is 		

file file_INSTRS : text;
file file_RESULTS : text;		   
constant c_WIDTH : natural := 8;
signal rst_bar : std_logic := '1';
signal INSTRS: ib_type;
signal clk : std_logic := '0';
signal opcode_for_r3_tb : std_logic_vector(7 downto 0);
signal r3_addr_tb, r2_addr_tb, r1_addr_tb : std_logic_vector(4 downto 0);
signal r3_value_tb, r2_value_tb, r1_value_tb, rd_value_tb : std_logic_vector(127 downto 0);
signal zero_tb: std_logic;
constant clk_period : time := 10 ns;

begin
  UUT : entity pmu port map(rst_bar => rst_bar, clk => clk, instrs => INSTRS, opcode_for_r3 => opcode_for_r3_tb,
	  rs3_addr => r3_addr_tb, rs2_addr => r2_addr_tb, rs1_addr => r1_addr_tb, r3_value => r3_value_tb,
	  r2_value => r2_value_tb, r1_value => r1_value_tb, rd_value => rd_value_tb, zero => zero_tb);

-- clock process definitions
clk_process : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;
	  
start: process
	variable v_OLINE : line;
    variable INPUT_LINE  : line;
    variable INPUT_INSTR : std_logic_vector(24 downto 0); 
    variable instr_count : integer := 0;
  begin
 
    file_open(file_INSTRS, "input_instructions.txt",  read_mode);
	file_open(file_RESULTS, "output_results.txt", write_mode);
 
    while not endfile(file_INSTRS) loop
	  if(instr_count > 31) then
		  exit;				 		  
	  end if;
      readline(file_INSTRS, INPUT_LINE);
      read(INPUT_LINE, INPUT_INSTR);
      -- Pass the variable to a signal 
      INSTRS(instr_count) <= INPUT_INSTR;	  
 	  instr_count := instr_count + 1;						 
    end loop;
	
	rst_bar <= '0';
	wait for 40 ns;							  
	rst_bar <= '1';
	
	write(v_OLINE, string'("| --DECODE & READ OPERANDS-- |"), left, 48);
	
	write(v_OLINE, string'("--EXECUTE & WRITE-BACK-- |"), left, 24);
	writeline(file_RESULTS, v_OLINE);	   
	
	write(v_OLINE, string'("| Instr |"), left, 6);
	
	write(v_OLINE, string'("Opcode for Rs3 |"), left, 8);
	
	write(v_OLINE, string'("Rs3 address |"), left, 8);

	write(v_OLINE, string'("Rs3 value:"), left, c_WIDTH);
	hwrite(v_OLINE, r3_value_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Rs2 address:"), left, c_WIDTH);
	hwrite(v_OLINE, r2_addr_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Rs2 value:"), left, c_WIDTH);
	hwrite(v_OLINE, r2_value_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Rs1 address:"), left, c_WIDTH);
	hwrite(v_OLINE, r1_addr_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Rs1 value:"), left, c_WIDTH);
	hwrite(v_OLINE, r1_value_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Rd value:"), left, c_WIDTH);
	hwrite(v_OLINE, rd_value_tb);	
	writeline(file_RESULTS, v_OLINE);
	
	write(v_OLINE, string'("Zero:"), left, c_WIDTH);
	write(v_OLINE, zero_tb);	
	writeline(file_RESULTS, v_OLINE);		
	
	writeline(file_RESULTS, v_OLINE);
		
	
	for i in 0 to instr_count loop
		wait for clk_period;
		
		write(v_OLINE, string'("Instr"), left, 6);
		write(v_OLINE, i);
	    writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("--DECODE & READ OPERANDS--"));
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Opcode for Rs3:"), left, c_WIDTH);
		hwrite(v_OLINE, opcode_for_r3_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Rs3 address:"), left, c_WIDTH);
		hwrite(v_OLINE, r3_addr_tb);	
		writeline(file_RESULTS, v_OLINE);
	
		write(v_OLINE, string'("Rs3 value:"), left, c_WIDTH);
		hwrite(v_OLINE, r3_value_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Rs2 address:"), left, c_WIDTH);
		hwrite(v_OLINE, r2_addr_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Rs2 value:"), left, c_WIDTH);
		hwrite(v_OLINE, r2_value_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Rs1 address:"), left, c_WIDTH);
		hwrite(v_OLINE, r1_addr_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Rs1 value:"), left, c_WIDTH);
		hwrite(v_OLINE, r1_value_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("--EXECUTE & WRITE-BACK--"));
		writeline(file_RESULTS, v_OLINE);	   
		
		write(v_OLINE, string'("Rd value:"), left, c_WIDTH);
		hwrite(v_OLINE, rd_value_tb);	
		writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, string'("Zero:"), left, c_WIDTH);
		write(v_OLINE, zero_tb);	
		writeline(file_RESULTS, v_OLINE);		
		
		writeline(file_RESULTS, v_OLINE);
	end loop;
	file_close(file_INSTRS);  
    file_close(file_RESULTS);
    wait;
  end process;
 
end behavior;