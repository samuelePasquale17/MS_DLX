library ieee;
use ieee.std_logic_1164.all;
use work.myTypes.all;

entity LUT_CU is
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
end entity;

architecture ARCHSTRUCT of LUT_CU is
begin

	-- process implementing the LUT 
	process (opcode, func, En)
	variable inp_sig : std_logic_vector(op_code_size+func_size downto 0);
	begin
		inp_sig := opcode & func & En;  -- checking both inputs within the same case condition

			if inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SLL & "1") then
				control_word <= "111000110100010000001111011000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SRL & "1") then
				control_word <= "111000110100010000001011011000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_ADD & "1") then
				control_word <= "111000110100010000000000111000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SUB & "1") then
				control_word <= "111000110100010000010000111000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_AND & "1") then
				control_word <= "111000110100010000100000011000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_OR & "1") then
				control_word <= "111000110100010011100000011000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_XOR & "1") then
				control_word <= "111000110100010011000000011000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SNE & "1") then
				control_word <= "111000110100010000010000011000111010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SLE & "1") then
				control_word <= "111000110100010000010000011000110110001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (RTYPE_OPCODE & RTYPE_FUNC_SGE & "1") then
				control_word <= "111000110100010000010000011000110010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_J & func & "1") then
				control_word <= "000000000000000000000000000000000000000000000000";
				IS_JUMP_BRANCH <= "01";
			elsif inp_sig = (ITYPE_OPCODE_JAL & func & "1") then
				control_word <= "000001001100010000000000101000000010001000010101";
				IS_JUMP_BRANCH <= "01";
			elsif inp_sig = (ITYPE_OPCODE_BEQZ & func & "1") then
				control_word <= "101000010100000000000000101110000000000000000000";
				IS_JUMP_BRANCH <= "10";
			elsif inp_sig = (ITYPE_OPCODE_BNEZ & func & "1") then
				control_word <= "101000010100000000000000101100000000000000000000";
				IS_JUMP_BRANCH <= "10";
			elsif inp_sig = (ITYPE_OPCODE_ADDI & func & "1") then
				control_word <= "101010010001010000000000110000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SUBI & func & "1") then
				control_word <= "101010010001010000010000110000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_ANDI & func & "1") then
				control_word <= "101010010001010000100000010000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_ORI & func & "1") then
				control_word <= "101010010001010011100000010000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_XORI & func & "1") then
				control_word <= "101010010001010011000000010000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SLLI & func & "1") then
				control_word <= "101010010001010000001111010000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SRLI & func & "1") then
				control_word <= "101010010001010000001011010000000010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SNEI & func & "1") then
				control_word <= "101010010001010000010000010000111010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SLEI & func & "1") then
				control_word <= "101010010001010000010000010000110110001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SGEI & func & "1") then
				control_word <= "101010010001010000010000010000110010001000010101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_LW & func & "1") then
				control_word <= "101010010001010000000000110000000010001000110101";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_SW & func & "1") then
				control_word <= "111010010101000000000000110000000010100010100000";
				IS_JUMP_BRANCH <= "00";
			elsif inp_sig = (ITYPE_OPCODE_NOP & func & "1") then
				control_word <= "000000101010000000000000111000000001000000001000";
				IS_JUMP_BRANCH <= "00";
			else
				control_word <= "000100001010101000000000000000000001010101001010"; -- only reset signals are active
				IS_JUMP_BRANCH <= "00";
			end if;
	end process;

end architecture;

configuration CFG_LUT_CU of LUT_CU is
	for ARCHSTRUCT
	end for;
end configuration;
