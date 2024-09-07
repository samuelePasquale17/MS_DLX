library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity SIGEXT is
    generic (
        N : integer := Nbit_SIGEXTin;  -- input width
        M : integer := Nbit_SIGEXTout  -- output width
    );
    port (
        Din : in std_logic_vector(N-1 downto 0);  -- input port
        Dout : out std_logic_vector(M-1 downto 0)  -- output port
    );
end entity;

architecture dataflow of SIGEXT is
begin

    Dout(M-1 downto N) <=       (others => '1') when Din(N-1) = '1' else   -- extend the sign on the most significant bits
                                (others => '0');

    Dout(N-1 downto 0) <=       Din;    -- forward the input to the output

end architecture;

configuration CFG_SIGEXT of SIGEXT is
for dataflow
end for;
end configuration;
