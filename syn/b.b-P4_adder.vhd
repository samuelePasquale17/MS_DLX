library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity P4_adder is
	generic (
		N : integer := Nbit_P4_adder;
		Nbit_blocks : integer := Nbit_carry_select_block
		);
	port (
		A : in std_logic_vector(N-1 downto 0);
		B : in std_logic_vector(N-1 downto 0);
		Cin : in std_logic;
		
		-- outputs
		S : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic
	);
end entity;

architecture STRUCT of P4_adder is

	-- sum generator
	component sum_generator is
		generic(
		    N : integer := Nbit_sum_generator;
		    Nbit_blocks : integer := Nbit_carry_select_block
		);
		port(
		    A : in std_logic_vector(N-1 downto 0);
		    B : in std_logic_vector(N-1 downto 0);
		    Cin : in std_logic;
		    Carry : in std_logic_vector((N/Nbit_blocks)-1 downto 0);

		    S : out std_logic_vector(N-1 downto 0);
		    Cout : out std_logic
		);
	end component;


	-- carry generator
	component carry_generator is
		generic(
		    N : integer := Nbit_carry_generator;
		    carry_range : integer := Nbit_carry_select_block
		);
		port (
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			C : out std_logic_vector((N/carry_range) downto 0)
		);
	end component;

	
	signal P, G : std_logic_vector(N-1 downto 0);
	signal Carries : std_logic_vector((N/Nbit_blocks) downto 0);


begin

	-- generation of the carry generator
	CG : carry_generator
				generic map(
					N => N,							-- width of the A and B inputs
					carry_range => Nbit_blocks		-- size of the carry select block
				)
				port map(
					A => A,
					B => B,
					Cin => Cin,
					C => Carries
				);

	-- generation of the sum generator
	SG : sum_generator
				generic map(
					N => N,
					Nbit_blocks => Nbit_blocks	
				)
				port map(					-- mapping with inputs and with the carry generator
					A => A,
					B => B,
					Cin => Cin,
					Carry => Carries((N/Nbit_blocks) downto 1),
					S => S,
					Cout => Cout
				);

end architecture;

configuration CFG_P4_ADDER of P4_adder is
for STRUCT
	for all : sum_generator
		use configuration work.CFG_SUM_GENERATOR;
	end for;

	for all : carry_generator
		use configuration work.CFG_CARRY_GENERATOR;
	end for;
end for;
end configuration;
