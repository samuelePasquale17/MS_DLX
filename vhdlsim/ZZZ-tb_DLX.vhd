library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use work.constants.all;

entity tb is
end entity;

architecture testbench of tb is
    component DLX is
        port (
            Rst : in std_logic;
            Clk : in std_logic
        );
    end component;

    signal Rst_s, Clk_s : std_logic;
    

begin
    DUT : DLX
        port map (
            Rst => Rst_s,
            Clk => Clk_s
        );


    -- Clock process
    process
	variable ClkPeriod : time := 20 ns;
    begin
        Clk_s <= '0';
        wait for ClkPeriod/2;
        Clk_s <= '1';
        wait for ClkPeriod/2;
    end process;

    -- stimuli process
    process
	variable ClkPeriod : time := 20 ns;
    begin   
        Rst_s <= '1';
        wait for ClkPeriod*4;
        Rst_s <= '0';
        wait;
    end process;
end architecture;

configuration CFG_TB_DLX of tb is
for testbench
	for all : DLX
		use configuration work.CFG_DLX;
	end for;
end for;
end configuration;
