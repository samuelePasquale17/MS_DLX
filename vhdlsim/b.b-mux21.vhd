library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity mux21 is
	port(
		A : 	in 		std_logic;	-- input #1
		B : 	in 		std_logic;  -- input #2
		S : 	in 		std_logic;	-- selects A when high
		Y : 	out 	std_logic	-- output
	);
end entity;


architecture ARCHSTRUCT of mux21 is
	component nd2 is -- nand
		port(
			A : 	in 		std_logic;	-- input #1
			B : 	in		std_logic;	-- input #2
			Y : 	out 	std_logic	-- A and B
		);
	end component;
	
	component iv is
		port(
			A : 	in 		std_logic;	-- input
			Y : 	out 	std_logic	-- complemented output
		);
	end component;
	
	-- internal signals
	signal n_S, s1, s2 : std_logic;

begin

	NOT1 : iv port map(
					A => S,
					Y => n_S
				);
				
	NAND1 : nd2 port map(
					A => A,
					B => S,
					Y => s1
				);
				
	NAND2 : nd2 port map(
					A => B,
					B => n_S,
					Y => s2
				);
				
	NAND3 : nd2 port map(
					A => s1,
					B => s2,
					Y => Y
				);
				
end architecture;


configuration CFG_MUX21 of mux21 is
	for ARCHSTRUCT
		for all : iv 
			use configuration work.CFG_IV;
		end for;
		
		for all : nd2 
			use configuration work.CFG_NAND;
		end for;
	end for;
end configuration;
