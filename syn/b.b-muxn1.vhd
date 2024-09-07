library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity muxN1 is
	generic (N : integer := Nbit_MUXN1);	-- generic width
	port(
		A : 	in 		std_logic_vector(N-1 downto 0);  	-- input #1
		B : 	in 		std_logic_vector(N-1 downto 0);		-- input #2
		S : 	in 		std_logic;							-- selects A when high
		Y : 	out 	std_logic_vector(N-1 downto 0)		-- output
	);
end entity;


architecture ARCHSTRUCT of muxN1 is		-- architectural description

	component mux21 is
		port(
			A : 	in 		std_logic;	-- input #1
			B : 	in 		std_logic;  -- input #2
			S : 	in 		std_logic;	-- selects A when high
			Y : 	out 	std_logic	-- output
		);
	end component;

begin

	gen : for i in 0 to N-1 generate	-- generation of N muxes 2x1
		mux21_g : mux21 port map (
			A => A(i),
			B => B(i),
			S => S,
			Y => Y(i)
		);
	end generate gen;
end architecture;


configuration CFG_MUXN1 of muxN1 is
	for ARCHSTRUCT
          for gen
		for all : mux21
                  use configuration work.CFG_MUX21;
                end for;
          end for;
	end for;
end configuration;
