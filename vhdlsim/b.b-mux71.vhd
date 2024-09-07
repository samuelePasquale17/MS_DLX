library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity muxn71 is
	port(
        A : in std_logic; 
		B : in std_logic; 
		C : in std_logic; 
		D : in std_logic;
		E : in std_logic;
		F : in std_logic;
		G : in std_logic;     -- 7 inputs
        S : in std_logic_vector(2 downto 0);    -- selection signal
        -- 0 => A, 1 => B, 2 => C, 3 => D, 4 => E, 5 => F, else => G
        Y : out std_logic                       -- output
	);
end entity;


architecture df of muxn71 is		-- behavioral description
begin
    Y <=    A when S = "000" else
            B when S = "001" else
            C when S = "010" else
            D when S = "011" else
            E when S = "100" else
            F when S = "101" else
            G;
end architecture;


configuration CFG_MUX71 of muxn71 is
	for df
	end for;
end configuration;
