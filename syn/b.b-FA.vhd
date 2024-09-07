library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity FA is			-- full adder
	port(
		A 	: 	in 		std_logic;	-- input #1
		B 	: 	in 		std_logic;  -- input #2
		Ci 	: 	in 		std_logic;	-- carry in
		S 	: 	out 	std_logic;	-- output
		Co 	: 	out 	std_logic	-- carry out
	);
end entity;


architecture ARCHSTRUCT of FA is
begin
	S <= A xor B xor Ci;
	Co <= (A and B) or (A and Ci) or (B and Ci);		-- carry out generation
end architecture;


configuration CFG_FA of FA is
	for ARCHSTRUCT
	end for;
end configuration;
