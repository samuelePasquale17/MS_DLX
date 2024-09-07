library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity DATAPATH is

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

end entity;


architecture rtl of DATAPATH is

    signal      in_pc, out_pc, in_nextPC, out_nextPC, nextPC_exe, in_ju_imm,
                out_iram, out_ir, in_rf, out1_rf, 
                out_i_sigext, out_j_sigext, in_imm, 
                out_a, out_b, out2_rf, out_imm, in_a_alu, in_b_alu, 
                out_alu, tmpB, in_alu_reg, out_alu_reg, out_me,
                in_out_me, enable_address_dram, in_b : std_logic_vector(DLX_WIDTH-1 downto 0);

    signal      addr_in_rf, in_rd1, out_rd1, out_rd2 : std_logic_vector(ADDR_WIDTH_RF-1 downto 0);
            
    signal      c_out_alu, grt_s, lwr_s, eq_s, geq_s, leq_s, out_eq_z, out_neq_z, n_out_eq_z, n_out_neq_z, 
                sel_next_pc, tmpG, flg_s, en_register_file : std_logic;

	signal tmpAmux, tmpBmux, tmpYmux : std_logic_vector(0 downto 0);


	signal ADDR_REG31 : std_logic_vector(ADDR_WIDTH_RF-1 downto 0) := "11111";

    -- REGISTER
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

    -- ADDER 
    component P4_adder is
        generic (
            N : integer := Nbit_P4_adder;
            Nbit_blocks : integer := Nbit_carry_select_block
            );
        port (
            A : in std_logic_vector(N-1 downto 0);
            B : in std_logic_vector(N-1 downto 0);
            Cin : in std_logic;
            
            -- outputs
            S : out std_logic_vector(N-1 downto 0);
            Cout : out std_logic
        );
    end component;

    -- MUX 2 TO 1
    component muxN1 is
        generic (N : integer := Nbit_MUXN1);	-- generic width
        port(
            A : 	in 		std_logic_vector(N-1 downto 0);  	-- input #1
            B : 	in 		std_logic_vector(N-1 downto 0);		-- input #2
            S : 	in 		std_logic;							-- selects A when high
            Y : 	out 	std_logic_vector(N-1 downto 0)		-- output
        );
    end component;

    -- MUX 3 TO 1
    component muxn31 is
        generic (N : integer := Nbit_MUXN1);	-- generic width
        port(
            A : 	in 		std_logic_vector(N-1 downto 0);  	-- input #1
            B : 	in 		std_logic_vector(N-1 downto 0);		-- input #2
            C :     in      std_logic_vector(N-1 downto 0);     -- input #3
            S : 	in 		std_logic_vector(1 downto 0);		-- (0 => A, 1 => B, 2 => C, 3 => C)
            Y : 	out 	std_logic_vector(N-1 downto 0)		-- output
        );
    end component;

    -- MUX 7 TO 1
    component muxn71 is
        port(
            A, B, C, D, E, F, G : in std_logic;     -- 7 inputs
            S : in std_logic_vector(2 downto 0);    -- selection signal
            -- 0 => A, 1 => B, 2 => C, 3 => D, 4 => E, 5 => F, else => G
            Y : out std_logic                       -- output
        );
    end component;

    -- REGISTER FILE
    component registerfile is
        generic (
            N : integer := Nbit_registerfile;                       -- number of bits per each register   
            M : integer := Nbit_addressRF                           -- number of bits for address (#registers = 2**M)
        );
        port (
            Clk :       in std_logic;                               -- Clock signal
            Rst :       in std_logic;                               -- Reset signal active high
            En  :       in std_logic;                               -- Enable signal active high
    
            RD1 :       in std_logic;                               -- Read enable signals for read1 and read2 active high
            RD2 :       in std_logic;
    
            WR :        in std_logic;                               -- Write enable signal active high
    
            Addr_WR :   in std_logic_vector(M-1 downto 0);    		-- address ports
            Addr_RD1 :  in std_logic_vector(M-1 downto 0);
            Addr_RD2 :  in std_logic_vector(M-1 downto 0);
            
            DataIN :    in std_logic_vector(N-1 downto 0);          -- data input port
    
            Out1 :      out std_logic_vector(N-1 downto 0);         -- data output ports
            Out2 :      out std_logic_vector(N-1 downto 0)
    
        );
    end component;

    -- SIGN EXTENSION
    component SIGEXT is
        generic (
            N : integer := Nbit_SIGEXTin;  -- input width
            M : integer := Nbit_SIGEXTout  -- output width
        );
        port (
            Din : in std_logic_vector(N-1 downto 0);  -- input port
            Dout : out std_logic_vector(M-1 downto 0)  -- output port
        );
    end component;
    

    -- ZERO DETECTOR
    component zeroDetector is
        generic (
            N : integer := Nbit_ALU  -- generic number of bits
        );
        port (
            A : in std_logic_vector(N-1 downto 0);  -- input
            en : in std_logic;  -- enable
            eqZ : out std_logic;  -- equal to zero
            neqZ : out std_logic  -- not equal to zero
        );
    end component;

    -- INVERTER
    component iv is
        port(
            A : 	in 		std_logic;	-- input
            Y : 	out 	std_logic	-- complemented output
        );
    end component;

    -- ARITHMETIC LOGIC UNIT
    component ALU is
        generic (
            N : integer := Nbit_ALU
        );
        port (
            -- data in 
            A : in std_logic_vector(N-1 downto 0);  -- Data in #1
            B : in std_logic_vector(N-1 downto 0);  -- Data in #2 (shift amount if shifting)
    
            -- logicals
            ctrl_logicals : in std_logic_vector(3 downto 0);  -- control signals for logicals 
            -- 0001 AND
            -- 1110 NAND
            -- 0111 OR
            -- 1000 NOR
            -- 0110 XOR
            -- 1001 XNOR
    
            -- sum/sub
            sum_sub_sel : in std_logic;  -- select signal for sum sub operation (1 => sub, 0 => add)
    
            -- shifter
            LOGIC_ARITH : in std_logic;	    -- 1 = logic, 0 = arith
            LEFT_RIGHT : in std_logic;	    -- 1 = left, 0 = right
            SHIFT_ROTATE : in std_logic;	-- 1 = shift, 0 = rotate
    
            -- mux select output
            sel_out : in std_logic_vector(1 downto 0);  -- (0 => logicals, 1 => sumsub, 2 => shifter, 3 => ZERO)
    
            -- output 
            Dout : out std_logic_vector(N-1 downto 0);  -- result out
            Cout : out std_logic;  -- carry out 
            Grt : out std_logic;  -- greather (>)
            Lwr : out std_logic;  -- lower (<)
            Eq : out std_logic;   -- equal (==)
            GEq : out std_logic;  -- greather and equal (>=)
            LEq : out std_logic   -- lower and equal (<=)
        );
    end component;

	component JUMP_UNIT is 
		generic (
			N : integer := DLX_WIDTH
		);
		port (
			en : in std_logic_vector(1 downto 0);
			nextPC : in std_logic_vector(N-1 downto 0);
			imm		: in std_logic_vector(N-1 downto 0);
			sub_1 : in std_logic;  -- has to be 1
			jumpPC : out std_logic_vector(N-1 downto 0)
		);
	end component;

begin

    -- program counter
    PC : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_PC,
                en => EN_PC,
                Out_reg => out_pc,
                In_reg => in_pc
            );

    -- adder to compute the NEXTPC = PC + 1
    NEXT_PC_val : P4_adder 
            generic map (
                N => DLX_WIDTH,
                Nbit_blocks => Nbit_carry_select_block
            )
            port map (
                A => out_pc,
                B => (others => '0'),
                Cin => '1',
                S => in_nextPC,
                Cout => open
            );



    -- next program counter
    nextPC : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_NEXTPC,
                en => EN_NEXTPC,
                Out_reg => out_nextPC,
                In_reg => in_nextPC
            );

    ADDR_IRAM <= out_pc;

	jump_unit_det : JUMP_UNIT
			generic map (
				N => DLX_WIDTH
			)
			port map (
				en => IS_JUMP_BRANCH,
				nextPC => out_nextPC,
				imm => in_ju_imm,
				sub_1 => '1',
				jumpPC => nextPC_exe
			);

    MUX_IN_JU : muxn31
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => (others => '0'), -- 00
                B => out_j_sigext,  -- 01 JUMP
                C => out_i_sigext, -- 10 BRANCH
                S => IS_JUMP_BRANCH,
                Y => in_ju_imm
            );
	


    -- instruction register 
    IR : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_IR,
                en => EN_IR,
                Out_reg => out_ir,
                In_reg => DATA_IRAM
            );

    IR_VAL <= out_ir;

    -- register file
    RF : registerfile
            generic map (
                N => DLX_WIDTH,
                M => ADDR_WIDTH_RF
            )
            port map (
                Clk => Clk,
                Rst => RST_RF,
                En => en_register_file,
                RD1 => RD1_RF,
                RD2 => RD2_RF,
                WR => WR_RF,       
                Addr_WR => addr_in_rf,
                Addr_RD1 => out_ir(25 downto 21),
                Addr_RD2 => out_ir(20 downto 16),               
                DataIN => in_rf,
                Out1 => out1_rf,
                Out2 => out2_rf
            );

	en_register_file <= EN_RF or RD1_RF or RD2_RF or WR_RF;

    -- SIGN EXTENSION I
    SIG_EXTENSION_I_TYPE : SIGEXT
            generic map (
                N => I_TYPE_IMM_SIZE,
                M => DLX_WIDTH
            )
            port map (
                Din => out_ir(15 downto 0),
                Dout => out_i_sigext
            );

    -- SIGN EXTENSION J
    SIG_EXTENSION_J_TYPE : SIGEXT
            generic map (
                N => J_TYPE_IMM_SIZE,
                M => DLX_WIDTH
            )
            port map (
                Din => out_ir(25 downto 0),
                Dout => out_j_sigext
            );

    -- multiplexer which gets the destination addresses
    DEST_ADDR : muxn31
            generic map (
                N => ADDR_WIDTH_RF
            )
            port map (
                A => out_ir(20 downto 16),
                B => out_ir(15 downto 11),
                C => ADDR_REG31,
                S => SELECT_RD_ITYPE_R31,
                Y => in_rd1
            );

    -- get either the I-type immediate or the J-type immediate
    IMM_SEL : muxN1
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out_i_sigext,
                B => out_i_sigext,
                S => SELECT_EXTI_EXTJ,
                Y => in_imm
            );


    -- reg A
    A : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_A,
                en => EN_A,
                Out_reg => out_a,
                In_reg => out1_rf
            );

    -- reg B
    B : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_B,
                en => EN_B,
                Out_reg => out_b,
                In_reg => in_b
            );  



    MUX_B_NEXTPC : muxn31
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out2_rf,
                B => out_nextPC,
                C => nextPC_exe,
                S => IS_JUMP_BRANCH,
                Y => in_b
            );
            
    -- reg IMM
    IMM : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_IMM,
                en => EN_IMM,
                Out_reg => out_imm,
                In_reg => in_imm
            );

    -- reg RD1
    reg_RD1 : RegN 
            generic map (
                N => ADDR_WIDTH_RF
            )
            port map (
                Clk => Clk,
                Rst => RST_RD1,
                en => EN_RD1,
                Out_reg => out_rd1,
                In_reg => in_rd1
            );


    -- ALU
    ALU1 : ALU
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => in_a_alu,
                B => in_b_alu,
                ctrl_logicals => CTRL_LOGICALS,
                sum_sub_sel => SUB_SUM_SEL,
                LOGIC_ARITH => LOGICAL_ARITH,
                LEFT_RIGHT => LEFT_RIGHT,
                SHIFT_ROTATE => SHIFT_ROTATE,
                sel_out => SEL_OUT,
                Dout => out_alu,
                Cout => c_out_alu,
                Grt => grt_s,
                Lwr => lwr_s,
                Eq => eq_s,
                GEq => geq_s,
                LEq => leq_s
            );


    -- drive as A either A or B
    A_DRIVER : muxN1
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out_a,
                B => (others => '0'),
                S => SEL_A_ZERO,
                Y => in_a_alu
            );

    -- drive as B either B or IMM
    B_DRIVER : muxN1
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out_b,
                B => out_imm,
                S => SEL_B_IMM,
                Y => in_b_alu
            );

    -- zero detection unit
    ZERO : zeroDetector
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out_a,
                en => EN_ZERO,
                eqZ => out_eq_z,
                neqZ => out_neq_z
            );


    -- inverter equal to zero
    INV_EQZ : iv 
            port map (
                 A => out_eq_z,
                 Y => n_out_eq_z
            );


    -- inverter not equal to zero
    INV_NEQZ : iv 
            port map (
                 A => out_neq_z,
                 Y => n_out_neq_z
            );


    -- multiplexer used to select either the eq or neq to zero 
    -- condition from the zero detection unit
    MUX_EQ_NEQ_Z : muxN1
            generic map (
                N => 1
            )
            port map (
                A => tmpAmux,
                B => tmpBmux,
                S => SEL_ZERO_NOTZERO,
                Y => tmpYmux
            );

	sel_next_pc <= tmpYmux(0);

	tmpAmux(0) <= n_out_eq_z;
	tmpBmux(0) <= n_out_neq_z;

    -- multiplexer used to select the next program counter
    -- as PC + 1 or the one computed by the ALU
    NEXTPC_SELECTION : muxN1
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => nextPC_exe,
                B => out_alu,
                S => sel_next_pc,
                Y => in_pc
            );

    -- multiplexer used to select the effective alu out
    EXE_STAGE_OUT : muxn31
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => out_alu,
                B => tmpB, 
                C => nextPC_exe,
                S => SEL_DOUT_FLG_NEXTPC,
                Y => in_alu_reg
            );

    tmpB <= (0 => flg_s, others => '0');
    -- tmpB(0) <= flg_s;

    -- multiplexer to select the flag signals driven by the ALU
    MUX7 : muxn71
            port map (
                A => c_out_alu,
                B => grt_s,
                C => lwr_s,
                D => eq_s,
                E => geq_s,
                F => leq_s,
                G => tmpG,
                S => SEL_FLG,
                Y => flg_s
            );

    tmpG <= not(eq_s);

    -- out ALU
    reg_OUT_ALU : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_ALUOUT,
                en => EN_ALUOUT,
                Out_reg => out_alu_reg,
                In_reg => in_alu_reg
            );


    -- reg Memory
    ME : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_ME,
                en => EN_ME,
                Out_reg => out_me,
                In_reg => out_b
            );
 

    -- reg RD2
    reg_RD2 : RegN 
            generic map (
                N => ADDR_WIDTH_RF
            )
            port map (
                Clk => Clk,
                Rst => RST_RD2,
                en => EN_RD2,
                Out_reg => out_rd2,
                In_reg => out_rd1
            );


    -- multiplexer which selects either the DRAM out or the ALU OUT
    mux_OUT_ME_SELECT : muxN1
            generic map (
                N => DLX_WIDTH
            )
            port map (
                A => DATA_OUT_DRAM,
                B => out_alu_reg,
                S => SEL_OUTDRAM_OUTALU,
                Y => in_out_me
            );

	enable_address_dram <= (others => SEL_OUTDRAM_OUTALU);
    ADDR_DRAM <= out_alu_reg and enable_address_dram;
    DATA_IN_DRAM <= out_me;


    -- reg out memory
    reg_OUT_ME : RegN 
            generic map (
                N => DLX_WIDTH
            )
            port map (
                Clk => Clk,
                Rst => RST_OUT_ME,
                en => EN_OUT_ME,
                Out_reg => in_rf,
                In_reg => in_out_me
            );


    -- reg RD3
    reg_RD3 : RegN 
            generic map (
                N => ADDR_WIDTH_RF
            )
            port map(
                Clk => Clk,
                Rst => RST_RD3,
                en => EN_RD3,
                Out_reg => addr_in_rf,
                In_reg => out_rd2
            );

end architecture;


configuration CFG_DATAPATH of DATAPATH is
for rtl
    for all : RegN
        use configuration work.CFG_REGN;
    end for;
    for all : ALU
        use configuration work.CFG_ALU;
    end for;
    for all : iv
        use configuration work.CFG_IV;
    end for;
    for all : zeroDetector
        use configuration work.CFG_ZERODETECTOR;
    end for;
    for all : SIGEXT
        use configuration work.CFG_SIGEXT;
    end for;
    for all : registerfile
        use configuration work.CFG_RF;
    end for;
    for all : muxn71
        use configuration work.CFG_MUX71;
    end for;
    for all : muxn31
        use configuration work.CFG_MUXN31;
    end for;
    for all : muxN1
        use configuration work.CFG_MUXN1;
    end for;
    for all : P4_adder 
        use configuration work.CFG_P4_ADDER;
    end for;
	for all : JUMP_UNIT
		use configuration work.CFG_JUMP_UNIT;
	end for;
end for;
end configuration;
