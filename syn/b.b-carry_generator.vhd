library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constants.all;

entity carry_generator is
    generic(
        N : integer := Nbit_carry_generator;
        carry_range : integer := Nbit_carry_select_block
    );
	port (
		A, B : in std_logic_vector(N-1 downto 0);
		Cin : in std_logic;
		C : out std_logic_vector((N/carry_range) downto 0)
	);
end entity;


architecture ARCHSTRUCT of carry_generator is

	signal P, G : std_logic_vector(N-1 downto 0);

	-- sparse tree made of g and pg blocks
	component carry_generator_sparse_tree is
		generic(
		    N : integer := Nbit_carry_generator;
		    carry_range : integer := Nbit_carry_select_block
		);
		port (
		    P : in std_logic_vector(N-1 downto 0);
		    G : in std_logic_vector(N-1 downto 0);
		    Cin : in std_logic;
		    C : out std_logic_vector((N/carry_range) downto 0)
		);
	end component;

	-- pg network for P and G signal generation
	component pg_network is
		generic(
		    N : integer := Nbit_pg_network
		);
		port(
		    A : in std_logic_vector(N-1 downto 0);
		    B : in std_logic_vector(N-1 downto 0);
		    P : out std_logic_vector(N-1 downto 0);
		    G : out std_logic_vector(N-1 downto 0)
		);
	end component;

begin
		
	PG_NET : pg_network
				generic map(
					N => N
				)
				port map(
					A => A,
					B => B,
					P => P, 	-- Propagate signal generated from A and B
					G => G
				);

	CG : carry_generator_sparse_tree
					generic map(
						N => N,
						carry_range => Nbit_carry_select_block	
					)
					port map(
						P => P,		-- P and G are driven as inputs
						G => G,
						Cin => Cin, -- gets the carry in
						C => C
					);
end architecture;

configuration CFG_CARRY_GENERATOR of carry_generator is
    for ARCHSTRUCT
		for all : pg_network
			use configuration work.CFG_PG_NETWORK; 
		end for;

		for all : carry_generator_sparse_tree
			use configuration work.CFG_CARRY_GENERATOR_SPARSE_TREE;
		end for;

    end for;
end configuration;
