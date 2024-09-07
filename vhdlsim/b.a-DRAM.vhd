library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity DRAM is
    generic (
        N : integer := width_DRAM;  -- word length
        P : integer := depth_DRAM;  -- number of words withing the memory 
        K : integer := addr_DRAM    -- address size, it is log2(depth_DRAM)
    );
    port (
        DIN : in std_logic_vector(N-1 downto 0);    -- data in
        ADDR : in std_logic_vector(K-1 downto 0);   -- address signal
        DOUT : out std_logic_vector(N-1 downto 0);  -- data out
        Clk : in std_logic;                         -- clock signal
        RW : in std_logic;                          -- R/W signal (0 => Read, 1 => Write)
        Rst : in std_logic                          -- Reset
    );
end entity;

architecture beh of DRAM is
    subtype word_type is std_logic_vector(N-1 downto 0);
    type storage_type is array(0 to P-1) of word_type;
    signal memory : storage_type;

begin
    -- write process
    WrProc : process(Clk)
    begin
        if (rising_edge(Clk)) then
            if (Rst = '1') then
                memory <= (others => (others => '0'));
            elsif (RW = '1') then
                memory(to_integer(unsigned(ADDR))) <= DIN;
            end if;
        end if;
    end process;

    -- read process (asyncronous)
    RdProc : process(RW, ADDR, memory)
    begin
        if (RW = '0') then
            DOUT <= memory(to_integer(unsigned(ADDR)));
        else 
            DOUT <= (others => '0');
        end if;
    end process;
end architecture;

configuration CFG_DRAM of DRAM is
for beh
end for;
end configuration;
