library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity mux4n1 is
    generic (
        N : integer := Nbit_MUXN1  -- width
    );
    port (
        A : in std_logic_vector(N-1 downto 0);  -- input #1 (SEL = 0)
        B : in std_logic_vector(N-1 downto 0);  -- input #2 (SEL = 1)
        C : in std_logic_vector(N-1 downto 0);  -- input #3 (SEL = 2)
        D : in std_logic_vector(N-1 downto 0);  -- input #4 (SEL = 3)
        SEL : in std_logic_vector(1 downto 0);  -- 2 bits 
        Y : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture dataflow of mux4n1 is
begin

    Y <=    A when SEL = "00" else
            B when SEL = "01" else
            C when SEL = "10" else
            D;

end architecture;

configuration CFG_MUX4N1 of mux4n1 is
for dataflow
end for;
end configuration;