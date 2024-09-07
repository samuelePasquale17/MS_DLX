library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.constants.all;

entity IRAM is
    generic (           
        RAM_WIDTH : integer := width_IRAM;   -- width ram
        RAM_DEPTH : integer := depth_IRAM;  -- depth ram
        INIT_FILE : string := "test.asm.mem" 
    );
    port (
        RESET : in std_logic;
        ADDR : in std_logic_vector(width_IRAM - 1 downto 0);
        RD_DATA : out std_logic_vector(width_IRAM - 1 downto 0)
    );
end entity;

architecture beh of IRAM is
    type TYPE_IRAM is array (0 to RAM_DEPTH - 1) of std_logic_vector(RAM_WIDTH-1 downto 0); -- The memory is byte addressable
    signal MEMORY : TYPE_IRAM;

begin

    -- PURPOSE: This process is in charge of filling the Instruction RAM with the firmware
    -- TYPE : combinational
    -- INPUTS : RESET
    -- OUTPUTS: MEMORY
    FILL_MEMORY_P: process (RESET)
        file MEMORY_FP : text;
        variable FILE_LINE : line;
        variable INDEX : integer := 0;
        variable TMP_DATA_U : std_logic_vector(RAM_WIDTH-1 downto 0);
    begin 
        if (RESET = '0') then

            -- Load data from file
            file_open(MEMORY_FP,INIT_FILE,READ_MODE);
            while (not endfile(MEMORY_FP)) loop
                readline(MEMORY_FP,FILE_LINE);
                hread(FILE_LINE,TMP_DATA_U);
                MEMORY(INDEX) <= TMP_DATA_U; 
                INDEX := INDEX + 1;
            end loop;

            -- Clear the rest of the memory
            while(INDEX < RAM_DEPTH) loop
                MEMORY(INDEX) <= (others => '0');
                INDEX := INDEX + 1;
            end loop;

		else 
			memory <= (others => (others => '0'));
        end if;
    end process FILL_MEMORY_P;

    RD_DATA <= MEMORY(to_integer(unsigned(ADDR)));

end beh;

configuration CFG_IRAM of IRAM is
for beh
end for;
end configuration;
