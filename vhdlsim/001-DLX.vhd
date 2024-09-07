library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use work.constants.all;

entity DLX is
    port (
        Rst : in std_logic;
        Clk : in std_logic
    );
end entity;

architecture rtl of DLX is
    component DLX_DP_CU is
        port (
            Rst : in std_logic;
            Clk : in std_logic;
    
            -- interface with IRAM
            ADDR_IRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            DATA_IRAM : in std_logic_vector(DLX_WIDTH-1 downto 0);
    
            -- interface with DRAM
            DATA_OUT_DRAM : in std_logic_vector(DLX_WIDTH-1 downto 0);
            DATA_IN_DRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            ADDR_DRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            RW_DRAM : out std_logic
        );
    end component;

    component IRAM is
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
    end component;

    component DRAM is
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
    end component;

    signal address_iram, data_iram, address_dram, data_in_dram, data_out_dram : std_logic_vector(DLX_WIDTH-1 downto 0);
    signal rd_dram : std_logic;

begin

    -- datapath and control unit component
    DP_CU : DLX_DP_CU
            port map(
                Clk => Clk,
                Rst => Rst,

                ADDR_IRAM => address_iram,      -- connection with IRAM
                DATA_IRAM => data_iram,
    
                DATA_OUT_DRAM => data_out_dram, -- connection with DRAM
                DATA_IN_DRAM => data_in_dram,
                ADDR_DRAM => address_dram,
                RW_DRAM => rd_dram
            );


    -- IRAM
    instruction_mem : IRAM
            port map(
                RESET => Rst,
                ADDR => address_iram,
                RD_DATA => data_iram
            );

    -- DRAM
    data_mem : DRAM
            port map(
                DIN => data_in_dram,
                ADDR => address_dram,
                DOUT => data_out_dram,
                Clk => Clk,
                RW => rd_dram,
                Rst => Rst
            );


end architecture;

configuration CFG_DLX of DLX is
for rtl
    for all : DLX_DP_CU
        use configuration work.CFG_DLX_DP_CU;
    end for;

    for all : DRAM
        use configuration work.CFG_DRAM;
    end for;

    for all : IRAM
        use configuration work.CFG_IRAM;
    end for;
end for;
end configuration;
