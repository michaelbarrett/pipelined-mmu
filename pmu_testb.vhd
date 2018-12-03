entity pmu_testb is
end pmu_testb;

architecture pmu_testb of pmu_testb is

signal clk : std_logic := '0';
signal rst_bar : std_logic := '0'; -- 0 = loading instrs, 1 = reading instrs
signal instrs : ib_type;
constant clk_period : time := 10 ns;

begin
	
-- instantiate the uut
	uut: entity work.pmu PORT MAP (
		clk => clk,
		rst_bar => rst_bar,
		instrs => instrs
		);

end pmu_testb;
