library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use work.constants.all;

entity COMPARATOR is
    generic (
        N : integer := Nbit_comparator
    );
    port (
        SUBSUMout : in std_logic_vector(N-1 downto 0);  -- output SUBSUM component
        Carry : in std_logic;  -- carry out SUBSUM component
        Grt : out std_logic;  -- greather (>)
        Lwr : out std_logic;  -- lower (<)
        Eq : out std_logic;   -- equal (==)
        GEq : out std_logic;  -- greather and equal (>=)
        LEq : out std_logic   -- lower and equal (<=)
    );
end entity;

architecture str of COMPARATOR is

    signal Z : std_logic;  -- signal which is HIGH if SUM is ZERO 
    signal s1, s2 : std_logic;  -- internal signals

begin

    Z <= nor_reduce(SUBSUMout);  -- check if output is zero
    s1 <= not(Carry);  -- carry inverted (for A<B and A <=B check)
    s2 <= not(Z);  -- for A>B check


    -- if the carry out is 1 means that A-B is > 0, therefore not(B) is > than A
    GEq <= Carry; 

    -- if Z is fully 0 means that A == B
    Eq <= Z;

    -- opposite than Grt
    Lwr <= s1;

    -- equality from the Z signal, lower if not greather (inv Carry) 
    Leq <= s1 or Z;

    -- greather if not equal (not(Z)) and Carry is high
    Grt <= Carry and s2;

end architecture;

configuration CFG_COMPARATOR of COMPARATOR is
for str
end for;
end configuration;
