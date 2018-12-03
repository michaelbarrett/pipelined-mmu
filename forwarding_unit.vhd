library IEEE;
use IEEE.std_logic_1164.all;

entity fowarding_unit is
	port(
	current_rd: in std_logic_vector(4 downto 0);
	next_rd: in std_logic_vector(4 downto 0);
	 stored_rd_value: in std_logic_vector(127 downto 0);
	 current_rd_value: in std_logic_vector(127 downto 0);
	 rd_value: out std_logic_vector(127 downto 0)
	     );
end fowarding_unit;

--}} End of automatically maintained section

architecture behavioral of fowarding_unit is
signal temp : std_logic_vector(127 downto 0);
begin
process(current_rd, next_rd, stored_rd_value, current_rd_value)															  	
begin 
	if current_rd = next_rd then
		temp <= stored_rd_value;
	else
		temp <= current_rd_value;
	end if;	 
end process;
rd_value <= temp;
end behavioral;
