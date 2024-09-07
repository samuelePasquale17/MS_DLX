library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity LOGICALS is
    generic (
        N : integer := Nbit_logicals
    );
    port (
        -- ctrl
        -- 0001 AND
        -- 1110 NAND
        -- 0111 OR
        -- 1000 NOR
        -- 0110 XOR
        -- 1001 XNOR
        ctrl : in std_logic_vector(4-1 downto 0);  -- control signal
        A : in std_logic_vector(N-1 downto 0);  -- input #1
        B : in std_logic_vector(N-1 downto 0);  -- input #2
        Dout : out std_logic_vector(N-1 downto 0)  -- output data
    );
end entity;

architecture beh of LOGICALS is
begin

	Dout <= A and B when ctrl = "0001" else
			not(A and B) when ctrl = "1110" else
			A or B when ctrl = "0111" else
			not(A or B) when ctrl = "1000" else
			A xor B when ctrl = "0110" else
			not(A xor B);

end architecture;

architecture rtl of LOGICALS is

    component nand3N is
        generic(
            N : integer := 1	-- width, by default it is a 1-bit logic gate
        );
        port(
            A : in std_logic_vector(N-1 downto 0);
            B : in std_logic_vector(N-1 downto 0);
            C : in std_logic_vector(N-1 downto 0);
            Y : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component nand4N is
        generic(
            N : integer := 1	-- width, by default it is a 1-bit logic gate
        );
        port(
            A : in std_logic_vector(N-1 downto 0);
            B : in std_logic_vector(N-1 downto 0);
            C : in std_logic_vector(N-1 downto 0);
            D : in std_logic_vector(N-1 downto 0);
            Y : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- internal signals
    -- array for the outputs of the first level of NAND gates
    type array_type is array (0 to 3) of std_logic_vector(N-1 downto 0);
    signal l : array_type;

    signal ctrl_ext : std_logic_vector(4*N-1 downto 0);

	signal nA, nB : std_logic_vector(N-1 downto 0);
begin

	-- extension of ctrl signal because NAND gates are N bits wide
	ctrl_ext(4*N-1 downto 3*N) 	<= 	(others => '1') when ctrl(3) = '1' else
									(others => '0');
	ctrl_ext(3*N-1 downto 2*N) 	<= 	(others => '1') when ctrl(2) = '1' else
									(others => '0');
	ctrl_ext(2*N-1 downto N) 	<= 	(others => '1') when ctrl(1) = '1' else
									(others => '0');
	ctrl_ext(N-1 downto 0) 		<= 	(others => '1') when ctrl(0) = '1' else
									(others => '0');

	nA <= not(A);
	nB <= not(B);

    -- first level of nand gates, to drive the control signal
    -- there are 4 3-input NAND gates, driven by A, B and the control signal
	NAND1_LVL1 : nand3N
				                generic map(
				                    N => N
				                )
				                port map(	-- NOR
				                    A => nA,
				                    B => nB,
				                    C => ctrl_ext(4*N-1 downto 3*N), -- i-th bit ctrl signal
				                    Y => l(3) -- i-th cell of the array
				                );
	NAND2_LVL1 : nand3N
				                generic map(
				                    N => N
				                )
				                port map(	
				                    A => nA,
				                    B => B,
				                    C => ctrl_ext(3*N-1 downto 2*N), -- i-th bit ctrl signal
				                    Y => l(2) -- i-th cell of the array
				                );
	NAND3_LVL1 : nand3N
				                generic map(
				                    N => N
				                )
				                port map(	
				                    A => A,
				                    B => nB,
				                    C => ctrl_ext(2*N-1 downto 1*N), -- i-th bit ctrl signal
				                    Y => l(1) -- i-th cell of the array
				                );
	NAND4_LVL1 : nand3N
				                generic map(
				                    N => N
				                )
				                port map(	-- AND
				                    A => A,
				                    B => B,
				                    C => ctrl_ext(N-1 downto 0), -- i-th bit ctrl signal
				                    Y => l(0) -- i-th cell of the array
				                );


    -- second level is made of only one 4-input NAND gate
    NAND_LVL2 : nand4N
                        generic map (
                            N => N
                        )
                        port map(
                            A => l(0),
                            B => l(1), 
                            C => l(2),
                            D => l(3),
                            Y => Dout -- mapped with the output
                        );

end architecture;

configuration CFG_LOGICALS of LOGICALS is
for beh
end for;
end configuration;

configuration CFG_LOGICALS_wrong of LOGICALS is
for rtl
	for all : nand3N
		     use configuration work.CFG_nand3N;
	end for;

    for all : nand4N
        use configuration work.CFG_nand4N;
    end for;
end for;
end configuration;
