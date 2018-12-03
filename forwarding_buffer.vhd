library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwarding_buffer is
	port(
	clk: in std_logic;
	rst_bar: in std_logic;				   

	current_rd_in: in std_logic_vector(4 downto 0);
	next_rd_in: in std_logic_vector(4 downto 0);		  
	current_rd_value_in: in std_logic_vector(127 downto 0);
	
	current_rd_out: out std_logic_vector(4 downto 0);
	next_rd_out: out std_logic_vector(4 downto 0);				
	current_rd_value_out: out std_logic_vector(127 downto 0)
	     );
end forwarding_buffer;

--}} End of automatically maintained section

architecture behavioral of forwarding_buffer is
begin
process(clk, rst_bar)
begin 
	if rst_bar = '0' then
		current_rd_out <= (others=>'0');	--note: I removed (others=>(others=>'0') 11/30/2018 1:02PM
		next_rd_out	<= (others=>'0');	
		current_rd_value_out <= (others=>'0');
		
	elsif rising_edge(clk) then
		current_rd_out <= current_rd_in;	
		next_rd_out	<= next_rd_in;
		current_rd_value_out <= current_rd_value_in;
	end if;
	 
end process;
end behavioral;
