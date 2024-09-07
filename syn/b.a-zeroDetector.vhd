library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.constants.all;

entity zeroDetector is
    generic (
        N : integer := Nbit_ALU  -- generic number of bits
    );
    port (
        A : in std_logic_vector(N-1 downto 0);  -- input
        en : in std_logic;  -- enable
        eqZ : out std_logic;  -- equal to zero
        neqZ : out std_logic  -- not equal to zero
    );
end entity;

architecture df of zeroDetector is

	signal tmp : std_logic;
begin
    tmp <=  OR_reduce(A) when en = '1' else
            '0';

	neqZ <= tmp;
    
    eqZ <=  not(tmp) when en = '1' else
            '0';
end architecture;

configuration CFG_ZERODETECTOR of zeroDetector is
for df
end for;
end configuration;
