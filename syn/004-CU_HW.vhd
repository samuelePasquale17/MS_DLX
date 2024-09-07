library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;
use work.constants.all;

entity CU_HW is
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
		IS_JUMP_BRANCH : out std_logic_vector(1 downto 0); -- jump or jal or branch detector
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
end entity;

architecture rtl of CU_HW is
	component RegN is
		generic(
			N : integer := Nbit_Reg	-- register width
		);
		port (
			Clk : in std_logic;	-- clock signal
			Rst : in std_logic;	-- reset signal
			en : in std_logic;	-- enable signal
			Out_reg : out std_logic_vector(N-1 downto 0); -- output
			In_reg : in std_logic_vector(N-1 downto 0)		-- input
		);
	end component;

	component LUT_CU is
		generic (
			-- default value defined into myTypes package
			control_word_bits : integer := CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE  -- number of bits for the control word
		);
		port (
			-- for the LUT the size of inputs must be a constant, thus change is directly from the myTypes package
			opcode : in std_logic_vector(op_code_size-1 downto 0);  -- opcode field
			func : in std_logic_vector(func_size-1 downto 0);  -- func field
			En : in std_logic; -- enable signal
			IS_JUMP_BRANCH : out std_logic_vector(1 downto 0); -- jump or jal or branch detector
			control_word : out std_logic_vector(control_word_bits-1 downto 0)  -- control word driven as output
	
			-- for the CU FSM implementation the following mapping for the control word has been defined
			-----------------------------------------
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

	component CU_FETCH_STAGE is
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
	end component;

	signal enable, enable_delay_1cc : std_logic_vector(0 downto 0);
	signal out_lut : std_logic_vector(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-1 downto 0);
	signal ctrl_fetch : std_logic_vector(Nbit_CTRL_FETCH_STAGE-1 downto 0);
	signal ctrl_decode : std_logic_vector(Nbit_CTRL_DEC_STAGE-1 downto 0);
	signal ctrl_execute : std_logic_vector(Nbit_CTRL_EXE_STAGE-1 downto 0);
	signal ctrl_memory : std_logic_vector(Nbit_CTRL_MEM_STAGE-1 downto 0);
	signal ctrl_writeback : std_logic_vector(Nbit_CTRL_WB_STAGE-1 downto 0);
	signal out_reg_1 : std_logic_vector(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-1 downto 0);
	signal out_reg_2 : std_logic_vector(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-1 downto 0);


begin

	enable(0) <= not(Rst);

	-- reg delay 1 clock cycle the enable
	reg_en : RegN
	generic map(
		N => 1
	)
	port map(
		Clk => Clk,
		Rst => Rst,
		en => enable(0),
		Out_reg => enable_delay_1cc,
		In_reg => enable
	);

	-- control signal for fetch stage
	CU_IF : CU_FETCH_STAGE
	generic map (
		N => Nbit_CTRL_FETCH_STAGE
	)
	port map (
		en => enable(0),
		ctrl_word_fetch_stage => ctrl_fetch
	);


	-- LUT for the control word generation
	LUT_control_unit : LUT_CU
	generic map(
		control_word_bits => CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE  -- control word sizing
	)
	port map(
		opcode => opcode,  -- opcode field
		func => func,  -- func field
		En => enable_delay_1cc(0),
		IS_JUMP_BRANCH => IS_JUMP_BRANCH,
		control_word => out_lut  -- internal signal for the control word
	);

	ctrl_decode <= out_lut(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-1 downto CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE);

	-- reg DEC/EXE
	reg_1 : RegN
	generic map(
		N => CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE
	)
	port map(
		Clk => Clk,
		Rst => Rst,
		en => enable_delay_1cc(0),
		Out_reg => out_reg_1,
		In_reg => out_lut(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-1 downto 0)
	);

	ctrl_execute <= out_reg_1(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-1 downto CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE);


	-- reg EXE/MEM
	reg_2 : RegN
	generic map(
		N => CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE
	)
	port map(
		Clk => Clk,
		Rst => Rst,
		en => enable_delay_1cc(0),
		Out_reg => out_reg_2,
		In_reg => out_reg_1(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-1 downto 0)
	);

	ctrl_memory <= out_reg_2(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-1 downto CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-Nbit_CTRL_MEM_STAGE);


	-- reg MEM/WB
	reg_3 : RegN
	generic map(
		N => CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-Nbit_CTRL_MEM_STAGE
	)
	port map(
		Clk => Clk,
		Rst => Rst,
		en => enable_delay_1cc(0),
		Out_reg => ctrl_writeback,
		In_reg => out_reg_2(CTRL_WORD_SIZE-Nbit_CTRL_FETCH_STAGE-Nbit_CTRL_DEC_STAGE-Nbit_CTRL_EXE_STAGE-Nbit_CTRL_MEM_STAGE-1 downto 0)
	);

	-- final control word
	control_word <= ctrl_fetch & ctrl_decode & ctrl_execute & ctrl_memory & ctrl_writeback;

end architecture;


configuration CFG_CU_HW of CU_HW is
for rtl
	for all : RegN
		use configuration work.CFG_REGN;
	end for;

	for all : CU_FETCH_STAGE
		use configuration work.CFG_CU_FETCH_STAGE;
	end for;

	for all : LUT_CU
		use configuration work.CFG_LUT_CU;
	end for;
end for;
end configuration;
