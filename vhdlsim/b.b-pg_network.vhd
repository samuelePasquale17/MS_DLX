library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

-- PG network gets A and B vectors as inputs and generate
-- the propagate and generate signals computing the XOR and
-- the AND gates bitwise

entity pg_network is
    generic(
        N : integer := Nbit_pg_network
    );
    port(
        A : in std_logic_vector(N-1 downto 0);
        B : in std_logic_vector(N-1 downto 0);
        P : out std_logic_vector(N-1 downto 0);
        G : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture ARCHDATAFLOW of pg_network is
begin

    P <= A xor B after XORDELAY;        -- propagate
    G <= A and B after ANDDELAY;        -- generate

end architecture;

configuration CFG_PG_NETWORK  of pg_network is
    for ARCHDATAFLOW
    end for;
end configuration;
