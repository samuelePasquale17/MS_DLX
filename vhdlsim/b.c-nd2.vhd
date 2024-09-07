library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity nd2 is -- nand
	port(
		A : 	in 		std_logic;	-- input #1
		B : 	in		std_logic;	-- input #2
		Y : 	out 	std_logic	-- A and B
	);
end entity;

architecture ARCHSTRUC of nd2 is		-- structural 
begin
	Y <= not(A and B) after NDDELAY;	
end architecture;


configuration CFG_NAND of nd2 is
	for ARCHSTRUC
	end for;
end configuration;
