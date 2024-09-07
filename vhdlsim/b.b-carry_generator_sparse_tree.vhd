library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constants.all;


entity carry_generator_sparse_tree is
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
end entity;

architecture ARCHSTRUCT of carry_generator_sparse_tree is

constant NLEVELS_1: integer := integer(log2(real(carry_range)));
constant NLEVELS_2: integer := integer(log2(real(N))-log2(real(carry_range)));

type SignalVector is array (N downto 1) of std_logic_vector(N downto 1);


component g_block is
    port (
        -- input
        G_i_k : in std_logic;               -- G    i      k
        G_kmin1_j : in std_logic;           -- G    k-1    j
        P_i_k : in std_logic;               -- P    i      k
        
        --output
        G_i_j : out std_logic               -- G    i      j
    );
end component;

component pg_block is
    port (
        -- input
        G_i_k : in std_logic;               -- G    i      k
        G_kmin1_j : in std_logic;           -- G    k-1    j
        P_i_k : in std_logic;               -- P    i      k
        P_kmin1_j : in std_logic;           -- P    k-1    j
        
        --output
		P_i_j : out std_logic;              -- P    i      j
        G_i_j : out std_logic               -- G    i      j
    );
end component;

signal Gmat : SignalVector;
signal Pmat : SignalVector;


begin



C(0) <= Cin;

Gmat(1)(1) <= (Cin and P(0)) or G(0);

assign: for i in 2 to N generate
	Pmat(i)(i) <= P(i-1);
	Gmat(i)(i) <= G(i-1);
end generate;

-- for the NLEVELS_1 the following algorith have been used. The pg or g block of the next level has always 2 ingoing inputs (i.e. 2 parents)

-- for each level
LVL_PT1: for level in 1 to NLEVELS_1 generate
    -- for all NBITs	
    G_BLOCK0 : for i in 1 to N generate
            -- if i == 2^level G-block is generated			
            FRST: if i = 2**level generate
					first_G: g_block port map(P_i_k => Pmat(i)(i-2**(level-1)+1), G_i_k => Gmat(i)(i-2**(level-1)+1), G_kmin1_j => Gmat(i-2**(level-1))(1), G_i_j => Gmat(i)(i-2**level+1));
			end generate;
			
            -- otherwise PG-block generation			
            PG_BLOCKi : if (i mod 2**level = 0) and ((i > 2**level) or (i < 2**level)) generate 
				FRST_PG : pg_block port map(P_i_k => Pmat(i)(i-2**(level-1)+1), G_i_k => Gmat(i)(i-2**(level-1)+1),
								  P_kmin1_j => Pmat(i-2**(level-1))(i-2**level+1), G_kmin1_j => Gmat(i-2**(level-1))(i-2**level+1),
								  P_i_j => Pmat(i)(i-2**level+1) , G_i_j => Gmat(i)(i-2**level+1));
			end generate;
			
		end generate;
end generate;

-- mapping the bit since it have been already evaluated
C(1) <= Gmat(carry_range)(1);

-- for the NLEVELS_2 a second algorithm is used. It identify the parent from the previous level and the leaves in the next one

-- for each level
LVL_PT2 : for level in 0 to NLEVELS_2-1 generate
    -- for all NBITs	
    G_BLOCK1 : for i in carry_range to N generate
		ROOT : if (i mod (carry_range*(2**level)) = 0) and (i=(carry_range*(2**level)) or (i/(carry_range*(2**level))) mod 2 > 0) generate
			LVL: for k in i + carry_range to i + carry_range*(2**level) generate
				-- if true a G-block has to be generated and the carry out have to be driven as output
                G_BLOCK2 : if k mod carry_range = 0 and i = carry_range*(2**level) generate	
					G_L2: g_block port map(P_i_k => Pmat(k)(i+1), G_i_k => Gmat(k)(i+1), G_kmin1_j => Gmat(i)(i-carry_range*(2**level)+1), G_i_j => Gmat(k)(i-carry_range*(2**level)+1));	
					C(k/carry_range) <= Gmat(k)(i-carry_range*(2**level)+1);
				end generate;
                
                -- otherwise a pg block has to be generated
				LEAF: if k mod carry_range = 0 and i > 2**(level+2) generate
						PG_L2: pg_block port map(P_i_k => Pmat(k)(i+1), G_i_k => Gmat(k)(i+1),
								  P_kmin1_j => Pmat(i)(i-carry_range*(2**level)+1), G_kmin1_j => Gmat(i)(i-carry_range*(2**level)+1),
								  P_i_j => Pmat(k)(i-carry_range*(2**level)+1) , G_i_j => Gmat(k)(i-carry_range*(2**level)+1));
				end generate;
				
			end generate;
		end generate;
	end generate;
end generate;

end architecture;

configuration CFG_CARRY_GENERATOR_SPARSE_TREE of carry_generator_sparse_tree is
for ARCHSTRUCT

    for LVL_PT1
        for G_BLOCK0
            for FRST
                for all : g_block
                    use configuration work.CFG_G_BLOCK;
                end for;
            end for;

            for PG_BLOCKi
                for all : pg_block
                    use configuration work.CFG_PG_BLOCK;
                end for;
            end for;
        end for;
    end for;

    for LVL_PT2
        for G_BLOCK1
            for ROOT
                for LVL
                    for G_BLOCK2
                        for all : g_block
                            use configuration work.CFG_G_BLOCK;
                        end for;
                    end for;

                    for LEAF
                        for all : pg_block
                            use configuration work.CFG_PG_BLOCK;
                        end for;
                    end for;

                end for;
            end for;
        end for;
    end for;

end for;
end configuration;
