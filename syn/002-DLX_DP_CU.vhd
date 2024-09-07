library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use work.constants.all;

entity DLX_DP_CU is
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
end entity;

architecture rtl of DLX_DP_CU is

    component DATAPATH is

        port (
            Clk                  :   in  std_logic;
            RST_PC               :   in  std_logic;
            EN_PC                :   in  std_logic;
            RST_NEXTPC           :   in  std_logic;
            EN_NEXTPC            :   in  std_logic;
            RST_IRAM                  :   in  std_logic;
            RST_IR                  :   in  std_logic;
            EN_IR                  :   in  std_logic;
            RD1_RF                  :   in  std_logic;
            RD2_RF                  :   in  std_logic;
            WR_RF                  :   in  std_logic;
            RST_RF					: in std_logic;
            EN_RF 					: in std_logic;
            SELECT_EXTI_EXTJ                  :   in  std_logic;
            EN_ZERO 				: in std_logic;
            EN_A                  :   in  std_logic;
            RST_A                  :   in  std_logic;
            EN_B                  :   in  std_logic;
            RST_B                  :   in  std_logic;
            EN_IMM                  :   in  std_logic;
            RST_IMM                  :   in  std_logic;
            RST_RD1                  :   in  std_logic;
            EN_RD1                  :   in  std_logic;
            SEL_A_ZERO                  :   in  std_logic;
            SEL_B_IMM                  :   in  std_logic;
            CTRL_LOGICALS                  :   in  std_logic_vector(3 downto 0);
            SUB_SUM_SEL                  :   in  std_logic;
            LOGICAL_ARITH                  :   in  std_logic;
            LEFT_RIGHT                  :   in  std_logic;
            SHIFT_ROTATE                  :   in  std_logic;
            SEL_OUT                  :   in  std_logic_vector(1 downto 0);
            SEL_ZERO_NOTZERO                  :   in  std_logic;
            SEL_DOUT_FLG_NEXTPC                  :   in  std_logic_vector(1 downto 0);
            SEL_FLG                  :   in  std_logic_vector(2 downto 0);
            RST_ALUOUT                  :   in  std_logic;
            EN_ALUOUT                  :   in  std_logic;
            RST_ME                  :   in  std_logic;
            EN_ME                  :   in  std_logic;
            RST_RD2                  :   in  std_logic;
            EN_RD2                  :   in  std_logic;
            SEL_OUTDRAM_OUTALU                  :   in  std_logic;
            RST_OUT_ME                  :   in  std_logic;
            EN_OUT_ME                  :   in  std_logic;
            RST_RD3                  :   in  std_logic;
            EN_RD3                  :   in  std_logic;
			IS_JUMP_BRANCH					: in std_logic_vector(1 downto 0);
    
            SELECT_RD_ITYPE_R31 : in std_logic_vector(1 downto 0);
            DATA_IRAM : in std_logic_vector(DLX_WIDTH-1 downto 0);
            DATA_OUT_DRAM : in std_logic_vector(DLX_WIDTH-1 downto 0);
    
            ADDR_IRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            DATA_IN_DRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            ADDR_DRAM : out std_logic_vector(DLX_WIDTH-1 downto 0);
            IR_VAL : out std_logic_vector(DLX_WIDTH-1 downto 0)
        );
    
    end component;

    component CU_HW is
        generic (
            -- default values defined into myTypes package
            opcode_bits : integer := op_code_size;  -- number of bits for the opcode field
            func_bits : integer := func_size;  -- number of bits for the function field
            control_word_bits : integer := CTRL_WORD_SIZE  -- number of bits for the control word
        );
        port (
            Clk : in std_logic;  -- clock signal
            Rst : in std_logic;  -- reset signal
    
            opcode : in std_logic_vector(opcode_bits-1 downto 0);  -- opcode field
            func : in std_logic_vector(func_bits-1 downto 0);  -- opcode field
			IS_JUMP_BRANCH : out std_logic_vector(1 downto 0); -- jump or jal detector
            control_word : out std_logic_vector(control_word_bits-1 downto 0)  -- control word driven as output
    
            -- for the CU implementation the following mapping for the control word has been defined
            -- for the CU FSM implementation the following mapping for the control word has been defined
            -----------------------------------------
            -- |	control_word[54]		|	EN_PC		|
            -- |	control_word[53]		|	RST_PC		|
            -- |	control_word[52]		|	RST_IRAM		|
            -- |	control_word[51]		|	EN_NEXTPC		|
            -- |	control_word[50]		|	RST_NEXTPC		|
            -- |	control_word[49]		|	EN_IR		|
            -- |	control_word[48]		|	RST_IR		|
            -- |	control_word[47]		|	RD1_RF		|
            -- |	control_word[46] 	| 	RD2_RF	 	|
            -- |	control_word[45] 	|	EN_RF		|
            -- |	control_word[44] 	|	RST_RF		|
            -- |	control_word[43] 	|	SELECT_EXTI_EXTJ		|
            -- |	control_word[42] 	|	SELECT_RD_ITYPE_R31[0]	|	
            -- |	control_word[41] 	|	SELECT_RD_ITYPE_R31[0]	|
            -- |	control_word[40] 	|	EN_A		|
            -- |	control_word[39] 	|	RST_A		|
            -- |	control_word[38] 	|	EN_B		|
            -- |	control_word[37] 	|	RST_B		|
            -- |	control_word[36] 	|	EN_IMM		|
            -- |	control_word[35] 	|	RST_IMM		|
            -- |	control_word[34] 	|	EN_RD1	|
            -- |	control_word[33]	|	RST_RD1		|
            -- |	control_word[32] 	| 	CTRL_LOGICALS[0]	 	|
            -- |	control_word[31] 	|	CTRL_LOGICALS[1]		|
            -- |	control_word[30] 	|	CTRL_LOGICALS[2]		|
            -- |	control_word[29] 	|	CTRL_LOGICALS[3]		|
            -- |	control_word[28] 	|	SUB_SUM_SEL	|	
            -- |	control_word[27] 	|	LOGICAL_ARITH	|
            -- |	control_word[26] 	|	LEFT_RIGHT		|
            -- |	control_word[25] 	|	SHIFT_ROTATE		|
            -- |	control_word[24] 	|	SELL_OUT[0]		|
            -- |	control_word[23] 	|	SELL_OUT[1]			|
            -- |	control_word[22] 	|	SEL_A_ZERO		|
            -- |	control_word[21] 	|	SEL_B_IMM	|
            -- |	control_word[20]		|	EN_ZERO		|
            -- |	control_word[19] 	| 	SEL_ZERO_NOTZERO	 	|
            -- |	control_word[18] 	|	SEL_DOUT_FLG_NEXTPC[0]		|
            -- |	control_word[17] 	|	SEL_DOUT_FLG_NEXTPC[1]		|
            -- |	control_word[16] 	|	SEL_FLG[0]		|
            -- |	control_word[15] 	|	SEL_FLG[1]	|	
            -- |	control_word[14] 	|	SEL_FLG[2]	|
            -- |	control_word[13] 	|	EN_ALUOUT		|
            -- |	control_word[12]	|	RST_ALUOUT		|
            -- |	control_word[11] 	|	EN_ME		|
            -- |	control_word[10] 	|	RST_ME		|
            -- |	control_word[9] 	|	EN_RD2	|
            -- |	control_word[8] 	|	RST_RD2	|
            -- |	control_word[7]		|	RW_DRAM		|
            -- |	control_word[6] 	| 	RST_DRAM	 	|
            -- |	control_word[5] 	|	SEL_OUTDRAM_OUTALU		|
            -- |	control_word[4] 	|	EN_OUTME		|
            -- |	control_word[3] 	|	RST_OUTME		|
            -- |	control_word[2] 	|	EN_RD3	|	
            -- |	control_word[1] 	|	RST_RD3	|
            -- |	control_word[0] 	|	WR_RF		|
            -----------------------------------------
        );
    end component;

    signal ir_sig : std_logic_vector(DLX_WIDTH-1 downto 0);
    signal ctrl_word : std_logic_vector(CTRL_WORD_SIZE-1 downto 0);
	signal jump_detect : std_logic_vector(1 downto 0);

begin

    datapath_dlx : DATAPATH
        port map (
            Clk => Clk,
            RST_PC => ctrl_word(53),
            EN_PC => ctrl_word(54),
            RST_NEXTPC => ctrl_word(50),
            EN_NEXTPC => ctrl_word(51),
            RST_IRAM => ctrl_word(52),
            RST_IR => ctrl_word(48),
            EN_IR => ctrl_word(49),
            RD1_RF => ctrl_word(47),
            RD2_RF => ctrl_word(46),
            WR_RF => ctrl_word(0),
            RST_RF => ctrl_word(44),
            EN_RF => ctrl_word(45),
            SELECT_EXTI_EXTJ => ctrl_word(43),
            EN_ZERO => ctrl_word(20),
            EN_A => ctrl_word(40),
            RST_A => ctrl_word(39),
            EN_B => ctrl_word(38),
            RST_B => ctrl_word(37),
            EN_IMM => ctrl_word(36),
            RST_IMM => ctrl_word(35),
            RST_RD1 => ctrl_word(33),
            EN_RD1 => ctrl_word(34),
            SEL_A_ZERO => ctrl_word(22),
            SEL_B_IMM => ctrl_word(21),
            CTRL_LOGICALS => ctrl_word(32 downto 29),
            SUB_SUM_SEL => ctrl_word(28),
            LOGICAL_ARITH => ctrl_word(27),
            LEFT_RIGHT => ctrl_word(26),
            SHIFT_ROTATE => ctrl_word(25),
            SEL_OUT => ctrl_word(24 downto 23),
            SEL_ZERO_NOTZERO => ctrl_word(19),
            SEL_DOUT_FLG_NEXTPC => ctrl_word(18 downto 17),
            SEL_FLG => ctrl_word(16 downto 14),
            RST_ALUOUT => ctrl_word(12),
            EN_ALUOUT => ctrl_word(13),
            RST_ME => ctrl_word(10),
            EN_ME => ctrl_word(11),
            RST_RD2 => ctrl_word(8),
            EN_RD2 => ctrl_word(9),
            SEL_OUTDRAM_OUTALU => ctrl_word(5),
            RST_OUT_ME => ctrl_word(3),
            EN_OUT_ME => ctrl_word(4),
            RST_RD3 => ctrl_word(1),
            EN_RD3 => ctrl_word(2),
			IS_JUMP_BRANCH => jump_detect,
    
            SELECT_RD_ITYPE_R31 => ctrl_word(42 downto 41),
            DATA_IRAM => DATA_IRAM,
            DATA_OUT_DRAM => DATA_OUT_DRAM,
    
            ADDR_IRAM => ADDR_IRAM,
            DATA_IN_DRAM => DATA_IN_DRAM,
            ADDR_DRAM => ADDR_DRAM,
            IR_VAL => ir_sig
        );

    control_unit_dlx : CU_HW
        port map(
            Clk => Clk,
            Rst => Rst,
            opcode => ir_sig(DLX_WIDTH-1 downto DLX_WIDTH-6), -- opcode field
            func => ir_sig(10 downto 0),  -- func field
			IS_JUMP_BRANCH => jump_detect,
            control_word => ctrl_word
        );


    RW_DRAM <= ctrl_word(7);
end architecture;

configuration CFG_DLX_DP_CU of DLX_DP_CU is
for rtl
    for all : DATAPATH
        use configuration work.CFG_DATAPATH;
    end for;

    for all : CU_HW
        use configuration work.CFG_CU_HW;
    end for;
end for;
end configuration;
