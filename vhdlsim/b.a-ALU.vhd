library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity ALU is
    generic (
        N : integer := Nbit_ALU
    );
    port (
        -- data in 
        A : in std_logic_vector(N-1 downto 0);  -- Data in #1
        B : in std_logic_vector(N-1 downto 0);  -- Data in #2 (shift amount if shifting)

        -- logicals
        ctrl_logicals : in std_logic_vector(3 downto 0);  -- control signals for logicals 
        -- 0001 AND
        -- 1110 NAND
        -- 0111 OR
        -- 1000 NOR
        -- 0110 XOR
        -- 1001 XNOR

        -- sum/sub
        sum_sub_sel : in std_logic;  -- select signal for sum sub operation (1 => sub, 0 => add)

        -- shifter
        LOGIC_ARITH : in std_logic;	    -- 1 = logic, 0 = arith
		LEFT_RIGHT : in std_logic;	    -- 1 = left, 0 = right
		SHIFT_ROTATE : in std_logic;	-- 1 = shift, 0 = rotate

        -- mux select output
        sel_out : in std_logic_vector(1 downto 0);  -- (0 => logicals, 1 => sumsub, 2 => shifter, 3 => ZERO)

        -- output 
        Dout : out std_logic_vector(N-1 downto 0);  -- result out
        Cout : out std_logic;  -- carry out 
        Grt : out std_logic;  -- greather (>)
        Lwr : out std_logic;  -- lower (<)
        Eq : out std_logic;   -- equal (==)
        GEq : out std_logic;  -- greather and equal (>=)
        LEq : out std_logic   -- lower and equal (<=)
    );
end entity;

architecture rtl of ALU is


    component LOGICALS is
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
    end component;


    component COMPARATOR is
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
    end component;


    component SUBSUM is
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
    end component;


    component SHIFTER is
        generic (
            N : integer := Nbit_shifter
        );
        port (
            Din : in std_logic_vector(N-1 downto 0);  -- input 
            amount : in std_logic_vector(N-1 downto 0);  -- shift amount
            LOGIC_ARITH: in std_logic;	-- 1 = logic, 0 = arith
            LEFT_RIGHT: in std_logic;	-- 1 = left, 0 = right
            SHIFT_ROTATE: in std_logic;	-- 1 = shift, 0 = rotate
            Dout : out std_logic_vector(N-1 downto 0)  -- output
        );
    end component;


    component mux4n1 is
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
    end component;

    signal Dout_logicals, Dout_sumsub, Dout_shifter : std_logic_vector(N-1 downto 0);
    signal Cout_sumsub : std_logic;

begin

    Cout <= Cout_sumsub;

    MUX4N1_COMPONENT : mux4n1
        generic map (
            N => N
        )
        port map(
            A => Dout_logicals,
            B => Dout_sumsub,
            C => Dout_shifter,
            D => (others => '0'),
            SEL => sel_out,
            Y => Dout
        );
    
    
    SUB_SUM_COMPONENT : SUBSUM
            generic map (
                N => N,  -- width
                Nbit_blocks => 4   -- size carry select block of P4 adder
            )
            port map (
                A => A,
                B => B,
                En_sub => sum_sub_sel,
                Dout => Dout_sumsub,
                Cout => Cout_sumsub
            );

    SHIFTER_COMPONENT : SHIFTER
            generic map (
                N => N  -- width
            )
            port map (
                Din => A,
                amount => B,
                LOGIC_ARITH => LOGIC_ARITH,
                LEFT_RIGHT => LEFT_RIGHT,
                SHIFT_ROTATE => SHIFT_ROTATE,
                Dout => Dout_shifter
            );

    LOGICALS_COMPONENT : LOGICALS
            generic map (
                N => N  -- width 
            )
            port map (
                ctrl => ctrl_logicals,
                A => A,
                B => B,
                Dout => Dout_logicals
            );

    COMPARATOR_COMPONENT : COMPARATOR
            generic map (
                N => N  -- width
            )
            port map (
                SUBSUMout => Dout_sumsub,
                Carry => Cout_sumsub,
                Grt => Grt,
                Lwr => Lwr,
                Eq => Eq,
                GEq => GEq,
                LEq => LEq
            ); 

end architecture;

configuration CFG_ALU of ALU is
for rtl
    for all : COMPARATOR
        use configuration work.CFG_COMPARATOR; 
    end for;

    for all : LOGICALS
        use configuration work.CFG_LOGICALS; 
    end for;

    for all : SHIFTER
        use configuration work.CFG_SHIFTER;  
    end for;

    for all : SUBSUM
        use configuration work.CFG_SUBSUM;  
    end for;

    for all : mux4n1
        use configuration work.CFG_MUX4N1; 
    end for;

end for;
end configuration;
