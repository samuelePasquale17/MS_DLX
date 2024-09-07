library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity nand3N is
	generic(
		N : integer := 1	-- width, by default it is a 1-bit logic gate
	);
	port(
		A : in std_logic_vector(N-1 downto 0);
		B : in std_logic_vector(N-1 downto 0);
		C : in std_logic_vector(N-1 downto 0);
		Y : out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture dataflow of nand3N is
begin
	
	Y <= not(A and B and C); -- nand gate

end architecture;

configuration CFG_nand3N of nand3N is
for dataflow
end for;
end configuration;
