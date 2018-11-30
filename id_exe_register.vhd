library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_register is
	port(
	clk: in std_logic;
	rst_bar: in std_logic;				   
	
	rs1_in, rs2_in, rs3_in : in std_logic_vector(127 downto 0);
	li_in : in std_logic_vector(2 downto 0);
    imm_in : in std_logic_vector(15 downto 0);	
	control_signals_in : in unsigned(5 downto 0);
				  
	rs1_out, rs2_out, rs3_out : out std_logic_vector(127 downto 0);
	li_out : out std_logic_vector(2 downto 0);;
    imm_out : out std_logic_vector(15 downto 0);
	control_signals_out : out unsigned(5 downto 0);
	
	     );
end if_id_register;

--}} End of automatically maintained section

architecture behavioral of if_id_register is
begin
process(clk, rst_bar)
begin 
	if rst_bar = '0' then
		rs1_out <= (others=>(others=>'0'));	
		rs2_out	<= (others=>(others=>'0'));	
		rs3_out <= (others=>(others=>'0'));	
		imm_out <= (others=>(others=>'0'));	
		li_out <= (others=>(others=>'0'));
		control_signals_out <= (others=>(others=>'0'));
		
	elsif rising_edge(clk) then
		rs1_out <= rs1_in;	
		rs2_out	<= rs2_in;
		rs3_out <= rs3_in;
		imm_out <= imm_in;	
		li_out <= li_in;			  
		control_signals_out <= control_signals_in;
	end if;
	 
end process;
end behavioral;
