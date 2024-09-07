package constants is
    -- Default number of bits --

    constant Nbit_MUXN1                 : integer := 4;     -- MUX Nto1
    constant Nbit_RCA                   : integer := 4;     -- RCA
    constant Nbit_carry_select_block    : integer := 4;     -- CARRY SELECT BLOCK
    constant Nbit_sum_generator         : integer := 32;    -- SUM GENERATOR
    constant Nbit_pg_network            : integer := 32;    -- PG NETWORK
    constant Nbit_carry_generator       : integer := 32;    -- CARRY GENERATOR
    constant Nbit_p4_adder              : integer := 32;    -- P4 ADDER
    constant Nbit_boothmul              : integer := 32;    -- BOOTH MUL
    constant Nbit_mux8to1               : integer := 4;     -- MUL 8 inputs to 1 output
    constant Nbit_booth_encoder         : integer := 32;    -- ENCODER BOOTH
	constant Nbit_shift_pow2			: integer := 32;	-- SHIFT POW 2
	constant Nbit_complementor			: integer := 32;	-- COMPLEMENTOR
    constant Nbit_registerfile          : integer := 64;    -- REGISTER FILE WIDTH
    constant Nbit_addressRF             : integer := 5;     -- REGISTER FILE nsum bit address line
	constant Nbit_RotReg				: integer := 32;	-- ROTATE REGISTER
	constant Nbit_UpCnt					: integer := 8;		-- UP COUNTER
	constant Nbit_Reg					: integer := 32;	-- REGISTER 
	constant Nbit_And					: integer := 8;		-- AND GATE 
    constant Nbit_SIGEXTin              : integer := 16;    -- SIG EXTENSION input size
    constant Nbit_SIGEXTout             : integer := 32;    -- SIG EXTENSION output size
    constant Nbit_shifter               : integer := 32;    -- SHIFTER
    constant Nbit_SUBSUM                : integer := 32;    -- ADDER / SUBTRACTOR
    constant Nbit_comparator            : integer := 32;    -- comparator
    constant Nbit_logicals              : integer := 32;    -- LOGICALS
    constant Nbit_ALU                   : integer := 32;    -- ALU


    -- default values DLX
    constant DLX_WIDTH : integer := 32;
    constant INIT_ASM_FILE : string := "test.asm.mem";
    constant IRAM_DEPTH : integer := 48;
    constant ADDR_WIDTH_RF : integer := 5;
    constant I_TYPE_IMM_SIZE : integer := 16;
    constant J_TYPE_IMM_SIZE : integer := 26;

    constant depth_IRAM                 : integer := 62;    -- depth IRAM
    constant width_IRAM                 : integer := 32;    -- width IRAM
    constant width_DRAM                 : integer := 32;    -- width DRAM
    constant depth_DRAM                 : integer := 1024;  -- depth DRAM
    constant addr_DRAM                  : integer := 32;    -- address bits DRAM
    

		
    constant test_fileName              : string    := "test.asm.mem";  -- source file name IRAM
	
    -- Default delay values --


    -- NOT
    constant IVDELAY : time := 0 ns; -- NOT output delay

    -- NAND
    constant NDDELAY : time := 0 ns; -- NAND output delay

    -- XOR 
    constant XORDELAY : time := 0 ns;   -- XOR output delay

    -- AND 
    constant ANDDELAY : time := 0 ns;   -- AND output delay

    -- PG and G block
    constant PDELAY : time := 0 ns;     -- Propagate delay
    constant GDELAY : time := 0 ns;     -- Generate delay


    -- RCA
    constant DelaySum_RCA       : time := 0 ns;         -- RCA Sum
    constant DelayCarryOut_RCA  : time := 0 ns;         -- RCA Carry Out

    -- FA
    constant DelaySum_FA        : time := 0 ns;         -- FA Sum
    constant DelayCarryOut_FA   : time := 0 ns;         -- FA Carry Out

    -- Register File
    constant DelayOutputPort    : time := 0 ns;


end constants;
