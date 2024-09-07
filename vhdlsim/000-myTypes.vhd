library ieee;
use ieee.std_logic_1164.all;

package myTypes is

    -- control input sizes
    constant OP_CODE_SIZE           : integer := 6;     -- opcode: identifies the type of the operation
    constant FUNC_SIZE              : integer := 11;    -- func: type of the operation specified in case of R-Type instruction
    constant Nbit_CTRL_FETCH_STAGE  : integer := 7;     -- number of control signals only in the fetch stage
    constant Nbit_CTRL_DEC_STAGE  : integer := 15;     -- number of control signals only in the decode stage
    constant Nbit_CTRL_EXE_STAGE  : integer := 25;     -- number of control signals only in the execute stage
    constant Nbit_CTRL_MEM_STAGE  : integer := 7;     -- number of control signals only in the memory stage
    constant Nbit_CTRL_WB_STAGE  : integer := 1;     -- number of control signals only in the writeback stage

    -- control word size
    constant CTRL_WORD_SIZE         : integer := 55;    -- the control word is the output of the Control Unit and its size is stricly dependent on the number of control signals sent to the datapath

    -- == R-TYPE instructions ==============================================================================================================================================================
    -- opcode field
    constant RTYPE_OPCODE           : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "000000";        -- opcode for R-Type instructions
    
    -- func field
    constant RTYPE_FUNC_SLL         : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000000100";  -- SLL RS1,RS2,RD
    constant RTYPE_FUNC_SRL        : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000000110";  -- SRL RS1,RS2,RD
    constant RTYPE_FUNC_ADD          : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000100000";  -- ADD RS1,RS2,RD
    constant RTYPE_FUNC_SUB         : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000100010";  -- SUB RS1,RS2,RD
    constant RTYPE_FUNC_AND        : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000100100";  -- AND RS1,RS2,RD
    constant RTYPE_FUNC_OR         : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000100101";  -- OR RS1,RS2,RD
    constant RTYPE_FUNC_XOR        : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000100110";  -- XOR RS1,RS2,RD
    constant RTYPE_FUNC_SNE       : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000101001";  -- SNE RS1,RS2,RD
    constant RTYPE_FUNC_SLE        : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000101100";  -- SLE RS1,RS2,RD
    constant RTYPE_FUNC_SGE        : std_logic_vector(FUNC_SIZE - 1 downto 0)      :=  "00000101101";  -- SGE RS1,RS2,RD


    -- == I-TYPE instructions ==============================================================================================================================================================
    -- opcode field
    constant ITYPE_OPCODE_J    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "000010"; 
    constant ITYPE_OPCODE_JAL     : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "000011";  
    constant ITYPE_OPCODE_BEQZ    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "000100"; 
    constant ITYPE_OPCODE_BNEZ    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "000101"; 
    constant ITYPE_OPCODE_ADDI     : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "001000"; 
    constant ITYPE_OPCODE_SUBI     : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "001010";  
    constant ITYPE_OPCODE_ANDI    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "001100"; 
    constant ITYPE_OPCODE_ORI     : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "001101";  
    constant ITYPE_OPCODE_XORI      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "001110";  
    constant ITYPE_OPCODE_SLLI    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "010100";  
    constant ITYPE_OPCODE_SRLI    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "010110";  
    constant ITYPE_OPCODE_SNEI      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "011001";  
    constant ITYPE_OPCODE_SLEI      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "011100";  
    constant ITYPE_OPCODE_SGEI      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "011101";  
    constant ITYPE_OPCODE_LW      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "100011";
    constant ITYPE_OPCODE_SW    : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "101011";     
    constant ITYPE_OPCODE_NOP      : std_logic_vector(OP_CODE_SIZE-1 downto 0)     := "010101";  
    
    -- =====================================================================================================================================================================================

end package;