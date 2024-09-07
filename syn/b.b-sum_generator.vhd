library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity sum_generator is
    generic(
        N : integer := Nbit_sum_generator;
        Nbit_blocks : integer := Nbit_carry_select_block
    );
    port(
        A : in std_logic_vector(N-1 downto 0);
        B : in std_logic_vector(N-1 downto 0);
        Cin : in std_logic;
        Carry : in std_logic_vector((N/Nbit_blocks)-1 downto 0);

        S : out std_logic_vector(N-1 downto 0);
        Cout : out std_logic
    );
end entity;

architecture ARCHSTRUCT of sum_generator is

    signal carries : std_logic_vector((N/Nbit_blocks)-1 downto 0);

    component carry_select_block is
        generic (
            N : integer := Nbit_carry_select_block     -- size Number of Bits 
        );
        port (
            Cin : in std_logic;
            A : in std_logic_vector(N-1 downto 0);
            B : in std_logic_vector(N-1 downto 0);
            S : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin

    carries <= Carry((N/Nbit_blocks)-2 downto 0) & Cin;
    Cout <= Carry((N/Nbit_blocks)-1);

    

    SG : for I in 1 to N/Nbit_blocks generate
        CSB : carry_select_block
            generic map(N => Nbit_carry_select_block)
            port map(
                Cin => carries(I-1), 
                A   => A((Nbit_blocks*I)-1 downto Nbit_blocks*(I-1)), 
                B   => B((Nbit_blocks*I)-1 downto Nbit_blocks*(I-1)), 
                S   => S((Nbit_blocks*I)-1 downto Nbit_blocks*(I-1))
            );
    end generate;

end architecture;

configuration CFG_SUM_GENERATOR of sum_generator is
    for ARCHSTRUCT
        for SG
            for all : carry_select_block
                use configuration work.CFG_CARRY_SELECT_BLOCK;
            end for;
        end for;
    end for;
end configuration;
