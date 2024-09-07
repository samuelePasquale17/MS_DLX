library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity g_block is
    port (
        -- input
        G_i_k : in std_logic;               -- G    i      k
        G_kmin1_j : in std_logic;           -- G    k-1    j
        P_i_k : in std_logic;               -- P    i      k
        
        --output
        G_i_j : out std_logic               -- G    i      j
    );
end entity;

architecture ARCHDATAFLOW of g_block is
begin

    G_i_j <= G_i_k or (P_i_k and G_kmin1_j) after GDELAY;

end architecture;

configuration CFG_G_BLOCK of g_block is
    for ARCHDATAFLOW
    end for;
end configuration;
