library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity CU_FETCH_STAGE is
    generic (
        N : integer := Nbit_CTRL_FETCH_STAGE
    );
    port (
        en : in std_logic;
        ctrl_word_fetch_stage : out std_logic_vector(N-1 downto 0)
        -- ctrl_word_fetch_stage[6] EN_PC
        -- ctrl_word_fetch_stage[5] RST_PC
        -- ctrl_word_fetch_stage[4] RST_IRAM
        -- ctrl_word_fetch_stage[3] EN_NETXPC
        -- ctrl_word_fetch_stage[2] RST_NEXTPC
        -- ctrl_word_fetch_stage[1] EN_IR
        -- ctrl_word_fetch_stage[0] RST_IR

    );
end entity;

architecture df of CU_FETCH_STAGE is
begin
     -- when enable active driving always the same control signal to the fetch stage
    ctrl_word_fetch_stage <=    "1001010" when en = '1' else
                                -- if not active driving all reset active
                                "0110101";
end architecture;


configuration CFG_CU_FETCH_STAGE of CU_FETCH_STAGE is 
for df
end for;
end configuration;