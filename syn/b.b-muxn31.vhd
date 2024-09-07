library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity muxn31 is
	generic (N : integer := Nbit_MUXN1);	-- generic width
	port(
		A : 	in 		std_logic_vector(N-1 downto 0);  	-- input #1
		B : 	in 		std_logic_vector(N-1 downto 0);		-- input #2
        C :     in      std_logic_vector(N-1 downto 0);     -- input #3
		S : 	in 		std_logic_vector(1 downto 0);		-- (0 => A, 1 => B, 2 => C, 3 => C)
		Y : 	out 	std_logic_vector(N-1 downto 0)		-- output
	);
end entity;


architecture df of muxn31 is		-- behavioral description
begin
    Y <=    A when S = "00" else
            B when S = "01" else
            C;

end architecture;


configuration CFG_MUXN31 of muxn31 is
	for df
	end for;
end configuration;
