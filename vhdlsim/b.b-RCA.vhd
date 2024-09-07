library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity RCA is
	generic (
		N 	: integer 		:= Nbit_RCA		-- Number of bits
	);
	port(
		A 	: 	in 		std_logic_vector(N-1 downto 0);		-- input #1
		B 	: 	in 		std_logic_vector(N-1 downto 0);		-- input #2
		Ci 	: 	in 		std_logic;							-- carry in
		S 	: 	out 	std_logic_vector(N-1 downto 0);		-- output
		Co 	: 	out 	std_logic							-- carry out
	);
end entity;


architecture ARCHSTRUCT of RCA is

	component FA is			-- full adder
		port(
			A 	: 	in 		std_logic;	-- input #1
			B 	: 	in 		std_logic;  -- input #2
			Ci 	: 	in 		std_logic;	-- carry in
			S 	: 	out 	std_logic;	-- output
			Co 	: 	out 	std_logic	-- carry out
		);
	end component;
	
    signal STMP : std_logic_vector(N-1 downto 0);
    signal CTMP : std_logic_vector(N downto 0);

begin
  CTMP(0) <= Ci;
  S <= STMP;	-- output mapping with FA's outputs
  Co <= CTMP(N);

  -- generation of N FAs
  ADDER1: for I in 1 to N generate
    FAI : FA 
      port map (A(I-1), B(I-1), CTMP(I-1), STMP(I-1), CTMP(I)); 
    end generate;

end architecture;


configuration CFG_RCA of RCA is
	for ARCHSTRUCT
          for ADDER1
            for all : FA
              use configuration work.CFG_FA;
            end for;
          end for;
	end for;
end configuration;
