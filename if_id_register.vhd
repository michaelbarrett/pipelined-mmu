library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_register is
	port(
	clk: in std_logic;
	rst_bar: in std_logic;
	 instr_in: in std_logic_vector(24 downto 0);
	 instr_out: out std_logic_vector(24 downto 0)
	     );
end if_id_register;

--}} End of automatically maintained section

architecture behavioral of if_id_register is
begin
process(clk, rst_bar)
begin 
	if rst_bar = '0' then
		instr_out <= (others=>'0');
	elsif rising_edge(clk) then
		instr_out <= instr_in;
	end if;
	 
end process;
end behavioral;
