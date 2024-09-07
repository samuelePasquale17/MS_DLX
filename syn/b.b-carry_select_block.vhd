library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity carry_select_block is
    generic (
        N : integer := Nbit_carry_select_block     -- size Number of Bits
    );
    port (
        Cin : in std_logic;                     -- carry in
        A : in std_logic_vector(N-1 downto 0);  -- input #1
        B : in std_logic_vector(N-1 downto 0);  -- input #2
        S : out std_logic_vector(N-1 downto 0)  -- output
    );
end carry_select_block;

architecture ARCHSTRUCT of carry_select_block is

    -- RCA component
    component RCA is
        generic (
            N 	: integer 		:= Nbit_RCA		-- Number of bits
        );
        port(
            A 	: 	in 		std_logic_vector(N-1 downto 0);		-- input #1
            B 	: 	in 		std_logic_vector(N-1 downto 0);		-- input #2
            Ci 	: 	in 		std_logic;							-- carry in
            S 	: 	out 	std_logic_vector(N-1 downto 0);		-- output
            Co 	: 	out 	std_logic							-- carry out
        );
    end component;

    -- muxN1
    component muxN1 is
        generic (N : integer := Nbit_MUXN1);	-- generic width
        port(
            A : 	in 		std_logic_vector(N-1 downto 0);  	-- input #1
            B : 	in 		std_logic_vector(N-1 downto 0);		-- input #2
            S : 	in 		std_logic;							-- selects A when high
            Y : 	out 	std_logic_vector(N-1 downto 0)		-- output
        );
    end component;

    signal S1, S2 : std_logic_vector(N-1 downto 0); -- sum generated by RCAs

begin

    -- RCA n.1 with Carry In set to 0
    RCA1 : RCA 
    generic map(N => Nbit_carry_select_block)
    port map(A => A, B => B, Ci => '0', S => S1, Co => open);

    -- RCA n.2 with Carry In set to 1
    RCA2 : RCA 
    generic map(N => Nbit_carry_select_block)
    port map(A => A, B => B, Ci => '1', S => S2, Co => open);

    MUX : muxN1
    generic map(N => N)       -- if carry in is '0' B is driven as output,
    port map(A => S2, B => S1, S => Cin, Y => S);   -- otherwise A is the MUX outcome 

end architecture;

configuration CFG_CARRY_SELECT_BLOCK of carry_select_block is
    for ARCHSTRUCT
        for all : RCA 
            use configuration work.CFG_RCA;
        end for;

        for MUX : muxN1 
            use configuration work.CFG_MUXN1;
        end for;
    end for;

end configuration;
