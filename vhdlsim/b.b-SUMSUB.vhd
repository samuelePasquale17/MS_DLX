library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity SUBSUM is
    generic (
        N : integer := Nbit_SUBSUM;  -- input/output width
        Nbit_blocks : integer := Nbit_carry_select_block  -- carry select block (P4 adder) size
    );
    port (
        A : in std_logic_vector(N-1 downto 0);  -- input #1
        B : in std_logic_vector(N-1 downto 0);  -- input #2
        En_sub : in std_logic;  -- 1 => sub, 0 => add
        Dout : out std_logic_vector(N-1 downto 0);  -- data out 
        Cout : out std_logic  -- carry out
    );
end entity;

architecture rtl of SUBSUM is

    component P4_adder is
        generic (
            N : integer := Nbit_P4_adder;
            Nbit_blocks : integer := Nbit_carry_select_block
            );
        port (
            A : in std_logic_vector(N-1 downto 0);
            B : in std_logic_vector(N-1 downto 0);
            Cin : in std_logic;
            
            -- outputs
            S : out std_logic_vector(N-1 downto 0);
            Cout : out std_logic
        );
    end component;

	signal B_tmp, En_sub_ext : std_logic_vector(N-1 downto 0);

begin

	-- enable signal extended
	En_sub_ext <= 	(others => '1') when En_sub = '1' else
					(others => '0') ;

	B_tmp <= En_sub_ext xor B;  -- xor with Cin (which is the SUM/SUM control signal)

    adder : P4_adder
            generic map (
                N => N,
                Nbit_blocks => Nbit_blocks
            )
            port map (
                A => A,
                B => B_tmp,
                Cin => En_sub,
                S => Dout,
                Cout => Cout
            );

end architecture;

configuration CFG_SUBSUM of SUBSUM is
for rtl
    for all : P4_adder
        use configuration work.CFG_P4_ADDER;
    end for;
end for;
end configuration;
