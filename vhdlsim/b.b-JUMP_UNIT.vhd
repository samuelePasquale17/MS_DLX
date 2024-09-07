library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity JUMP_UNIT is 
	generic (
		N : integer := DLX_WIDTH
	);
	port (
		en : in std_logic_vector(1 downto 0);
		nextPC : in std_logic_vector(N-1 downto 0);
		imm		: in std_logic_vector(N-1 downto 0);
		sub_1 : in std_logic;  -- has to be 1
		jumpPC : out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture beh of JUMP_UNIT is
begin
	JUprocess : process (nextPC, imm, en, sub_1)
		variable nextPC_v, imm_v, one : signed(N-1 downto 0);
		variable res : signed(N-1 downto 0);
	begin
		nextPC_v := signed(nextPC);
		imm_v := signed(imm); 
		-- one := (0 => '1', others => '0');
		if (en = "01" or en = "10") then  	-- if Jump or Branch
			res := nextPC_v + imm_v - 1;	-- update nextPC
		else
			res := nextPC_v;				-- else nextPC input driven as output
		end if;
		jumpPC <= std_logic_vector(res);
	end process;

end architecture;

configuration CFG_JUMP_UNIT of JUMP_UNIT is 
for beh
end for;
end configuration;
