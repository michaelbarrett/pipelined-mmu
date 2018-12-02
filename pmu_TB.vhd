library ieee;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_1164.all;
use work.ib_type_pkg.all;

entity pmu_tb is
end pmu_tb;

architecture behavior of pmu_tb is 		

component load_module is
port (
	INSTRS: in ib_type
  );
end component load_module;

file file_INSTRS : text;
file file_RESULTS : text;

begin
 
  LOAD_MODULE_INST : load_module
    port map (
      instrs => INSTRS
      );
 
  process
    variable INPUT_LINE  : line;
    variable INPUT_INSTR : std_logic_vector(24 downto 0); 
     
  begin
 
    file_open(file_INSTRS, "input_instructions.txt",  read_mode);
	file_open(file_RESULTS, "output_results.txt", write_mode);
 
    for i in 0 to 31 loop
      readline(file_INSTRS, INPUT_LINE);
      read(INPUT_LINE, INPUT_INSTR);
 
      -- Pass the variable to a signal 
      INSTRS(i) <= INPUT_INSTR;	  
 		 								 
    end loop;
 	write(v_OLINE, w_SUM, right, c_WIDTH);
    writeline(file_RESULTS, v_OLINE);
    file_close(file_INSTRS);  
    file_close(file_RESULTS);
    wait;
  end process;
 
end behavior;