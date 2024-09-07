library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;


entity SHIFTER is
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
end entity;

-- in this implementation some control signals are useless by kept for 
-- possible further Instruction Set extensions

architecture beh of SHIFTER is
begin
    -- behavior described by a process
    SHIFT: process (Din, amount, LOGIC_ARITH, LEFT_RIGHT, SHIFT_ROTATE) is
    begin
        if SHIFT_ROTATE = '0' then  -- check if rotate
    
            if LEFT_RIGHT = '0' then  -- check rotation direction
                Dout <= to_StdLogicVector((to_bitvector(Din)));	-- ror (conv_integer(amount)));
            else
            Dout <= to_StdLogicVector((to_bitvector(Din)));	-- rol (conv_integer(amount)));
            end if;
        else
    
            if LEFT_RIGHT = '0' then  -- check shift direction

                if LOGIC_ARITH = '0' then  -- check if logical or arithmetical
                    Dout <= to_StdLogicVector((to_bitvector(Din)));	-- sra (conv_integer(amount)));
                else
                    Dout <= to_StdLogicVector((to_bitvector(Din)) srl (conv_integer(amount)));
                end if;				
            else
    
                if LOGIC_ARITH = '0' then  -- check if logical or arithmetical
                    Dout <= to_StdLogicVector((to_bitvector(Din)));	-- sla (conv_integer(amount)));
                else
                    Dout <= to_StdLogicVector((to_bitvector(Din)) sll (conv_integer(amount)));
                end if;
            end if;
        end if;
    end process;
end architecture;

configuration CFG_SHIFTER of SHIFTER is
for beh
end for;
end configuration;
