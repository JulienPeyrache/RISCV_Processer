library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PKG.all;


entity CPU_PC is
    generic(
        mutant: integer := 0
    );
    Port (
        -- Clock/Reset
        clk    : in  std_logic ;
        rst    : in  std_logic ;

        -- Interface PC to PO
        cmd    : out PO_cmd ;
        status : in  PO_status
    );
end entity;


--syntaxe modifiée

architecture RTL of CPU_PC is
    type State_type is (
        S_Error,
        S_Init,
        S_Pre_Fetch,
        S_Fetch,
        S_Decode,
        S_LUI,
        S_ADDI,
        S_ADD,
        S_AUIPC,
        S_SLL,
        S_SLLI,
        S_SRA,
        S_SRAI,
        S_SRL,
        S_SRLI,
        S_SUB,
        S_AND,
        S_ANDI,
        S_OR,
        S_ORI,
        S_XOR,
        S_XORI
        );

    signal state_d, state_q : State_type;
    signal cmd_cs : PO_cs_cmd;
    alias section31_25 is status.IR(31 downto 25);
    alias section14_12 is status.IR(14 downto 12);
    alias section6_0 is status.IR(6 downto 0);


    function arith_sel (IR : unsigned( 31 downto 0 ))
        return ALU_op_type is
        variable res : ALU_op_type;
    begin
        if IR(30) = '0' or IR(5) = '0' then
            res := ALU_plus;
        else
            res := ALU_minus;
        end if;
        return res;
    end arith_sel;

    function logical_sel (IR : unsigned( 31 downto 0 ))
        return LOGICAL_op_type is
        variable res : LOGICAL_op_type;
    begin
        if IR(12) = '1' then
            res := LOGICAL_and;
        else
            if IR(13) = '1' then
                res := LOGICAL_or;
            else
                res := LOGICAL_xor;
            end if;
        end if;
        return res;
    end logical_sel;

    function shifter_sel (IR : unsigned( 31 downto 0 ))
        return SHIFTER_op_type is
        variable res : SHIFTER_op_type;
    begin
        res := SHIFT_ll;
        if IR(14) = '1' then
            if IR(30) = '1' then
                res := SHIFT_ra;
            else
                res := SHIFT_rl;
            end if;
        end if;
        return res;
    end shifter_sel;

begin

    cmd.cs <= cmd_cs;

    FSM_synchrone : process(clk)
    begin
        if clk'event and clk='1' then
            if rst='1' then
                state_q <= S_Init;
            else
                state_q <= state_d;
            end if;
        end if;
    end process FSM_synchrone;

    FSM_comb : process (state_q, status)
    begin

        -- Valeurs par défaut de cmd à définir selon les préférences de chacun
        cmd.rst               <= '0';
        cmd.ALU_op            <= ALU_plus;
        cmd.LOGICAL_op        <= LOGICAL_and;
        cmd.ALU_Y_sel         <= ALU_Y_immI;

        cmd.SHIFTER_op        <= SHIFT_ll;
        cmd.SHIFTER_Y_sel     <= SHIFTER_Y_rs2;

        cmd.RF_we             <= '0';
        cmd.RF_SIZE_sel       <= UNDEFINED;
        cmd.RF_SIGN_enable    <= '0';
        cmd.DATA_sel          <= UNDEFINED;

        cmd.PC_we             <= '0';
        cmd.PC_sel            <= UNDEFINED;

        cmd.PC_X_sel          <= PC_X_pc;
        cmd.PC_Y_sel          <= PC_Y_immU;

        cmd.TO_PC_Y_sel       <= TO_PC_Y_immB;

        cmd.AD_we             <= '0';
        cmd.AD_Y_sel          <= UNDEFINED;

        cmd.IR_we             <= '0';

        cmd.ADDR_sel          <= ADDR_from_pc;
        cmd.mem_we            <= '0';
        cmd.mem_ce            <= '0';

        cmd_cs.CSR_we            <= UNDEFINED;

        cmd_cs.TO_CSR_sel        <= UNDEFINED;
        cmd_cs.CSR_sel           <= UNDEFINED;
        cmd_cs.MEPC_sel          <= UNDEFINED;

        cmd_cs.MSTATUS_mie_set   <= '0';
        cmd_cs.MSTATUS_mie_reset <= '0';

        cmd_cs.CSR_WRITE_mode    <= UNDEFINED;

        state_d <= state_q;

        case state_q is
            when S_Error =>
                state_d <= S_Error;

            when S_Init =>
                -- PC <- RESET_VECTOR
                cmd.PC_we <= '1';
                cmd.PC_sel <= PC_rstvec;
                state_d <= S_Pre_Fetch;

            when S_Pre_Fetch =>
                -- mem[PC]
                cmd.mem_ce <= '1';
                state_d <= S_Fetch;

            when S_Fetch =>
                -- IR <- mem_datain
                cmd.IR_we <= '1';
                state_d <= S_Decode;


            when S_Decode =>
                -- PC<- PC+4
                cmd.TO_PC_Y_sel <= TO_PC_Y_cst_x04;
                cmd.PC_sel <= PC_from_pc;
                cmd.PC_we <= '0';

            case section6_0 is
			    when "0110111" =>
			    	state_d <= S_LUI;
                when "0010111" =>
                        state_d <= S_AUIPC;
			    when "0010011" => --type I
                        if section14_12 = "000" then
				            state_d <= S_ADDI;
            	        elsif section14_12 = "101" then
				            if section31_25 = "0000000" then
					            state_d <= S_SRLI;
			                elsif section31_25 = "0100000" then
					            state_d <= S_SRAI;
				            end if;
			            elsif section14_12 = "001" then
				            if section31_25 = "0000000" then
					            state_d <= S_SLLI;
				            end if;
			            elsif section14_12 = "110" then
				            state_d <= S_ORI;
		                elsif section14_12 = "111" then
				            state_d <= S_ANDI;
			            elsif section14_12 = "100" then
				            state_d <= S_XORI;
                        end if;

			    when "0110011" => --type R
			        if section14_12 = "000" then
			    	    if section31_25 = "0000000" then
			    		     state_d <= S_ADD;
			            elsif section31_25 = "0100000" then
				    	    state_d <= S_SUB; 
				        end if;
			        elsif section14_12 = "111" then
				        if section31_25 = "0000000" then
				    	    state_d <= S_AND;
				        end if;
			        elsif section14_12 = "110" then
				        if section31_25 = "0000000" then
				    	    state_d <= S_OR;
				        end if;
			        elsif section14_12 = "100" then
				        if section31_25 = "0000000" then
                            state_d <= S_XOR;
                        end if;
			        elsif section14_12 = "101" then
				        if section31_25 = "0000000" then
				    	    state_d <= S_SRL;
				        elsif section31_25 = "0100000" then
				    	    state_d <= S_SRA;
				        end if;
			        elsif section14_12 = "001" then
				        if section31_25 = "0000000" then
				    	    state_d <= S_SLL;
				        end if;
			        end if;
				
                when others =>
                    state_d <= S_Error; -- Pour detecter les rates du decodage
                end case;

---------- Instructions avec immediat de type U ----------



when S_LUI =>
    -- rd <- ImmU + 0
    cmd.PC_X_sel <= PC_X_cst_x00;
    cmd.PC_Y_sel <= PC_Y_immU;
    cmd.DATA_sel <= DATA_from_pc;
    cmd.RF_we <= '1'; 
    -- lecture mem[PC]
    cmd.ADDR_sel <= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    -- next state
    state_d <= S_Fetch;

when S_ADDI =>
    --rd <- rs1 + immI
    cmd.ALU_Y_sel <= ALU_Y_immI;
    cmd.ALU_op <= ALU_plus;
    cmd.DATA_sel <= DATA_from_alu;
    cmd.RF_we <= '1';
    cmd.mem_ce <= '1';    
    --next state
    state_d <= S_Fetch;

--AUIPC rd, imm : R[rd] = PC + (imm << 12)
when S_AUIPC =>
    cmd.PC_X_sel <= PC_X_pc;
    cmd.PC_Y_sel <= PC_Y_immU;
    cmd.DATA_sel <= DATA_from_pc;
    cmd.RF_we <= '1';
    --PC take the value
    cmd.ADDR_sel <= ADDR_from_pc;
    cmd.mem_ce <= '1';    
    cmd.mem_we <= '1';    
    -- next state
    state_d <= S_Fetch;

    





---------- Instructions arithmétiques et logiques ----------

when S_ADD=>
    --rd <- rs1 + rs2
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    cmd.ALU_op <= ALU_plus;
    cmd.DATA_sel <= DATA_from_alu;
    cmd.RF_we <= '1';
    cmd.mem_ce <= '1';
    --next state
    state_d <= S_Fetch;

When S_SUB =>
    --rd <- rs1 - rs2
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    cmd.ALU_op <= ALU_minus;
    cmd.DATA_sel <= DATA_from_alu;
    cmd.RF_we <= '1';
    cmd.mem_ce <= '1';
    --next state
    state_d <= S_Fetch;



when S_SLL =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_rs2;
    --select addition
    cmd.SHIFTER_op <= SHIFT_ll;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;

when S_SRL =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_rs2;
    --select addition
    cmd.SHIFTER_op<=SHIFT_rl;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;

when S_SRA =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_rs2;
    --select addition
    cmd.SHIFTER_op<=SHIFT_ra;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;

when S_SRAI =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_ir_sh;
    --select addition
    cmd.SHIFTER_op<=SHIFT_ra;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;


when S_SLLI =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_ir_sh;
    --select addition
    cmd.SHIFTER_op<=SHIFT_ll;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc ;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;

when S_SRLI =>
    --select rs2
    cmd.SHIFTER_Y_sel<=SHIFTER_Y_ir_sh;
    --select addition
    cmd.SHIFTER_op<=SHIFT_rl;
    --rd <- rs1+rs2
    cmd.RF_we <= '1';
    cmd.DATA_sel <= DATA_from_shifter;
    --lecture mem[PC]
    cmd.ADDR_sel<= ADDR_from_pc;
    cmd.mem_ce <= '1';
    cmd.mem_we <= '0';
    --Next state
    state_d <= S_Fetch;

when S_AND =>
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    cmd.LOGICAL_op <= LOGICAL_and;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;

when S_ANDI =>
    cmd.ALU_Y_sel <= ALU_Y_immI;
    cmd.LOGICAL_op <= LOGICAL_and;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;

when S_OR =>
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    cmd.LOGICAL_op <= LOGICAL_or;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;


when S_ORI =>
    cmd.ALU_Y_sel <= ALU_Y_immI ;
    cmd.LOGICAL_op <= LOGICAL_or;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;

when S_XOR =>
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    cmd.LOGICAL_op <= LOGICAL_xor;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;

when S_XORI =>
    cmd.ALU_Y_sel <= ALU_Y_immI;
    cmd.LOGICAL_op <= LOGICAL_xor;
    cmd.DATA_sel <= DATA_from_logical;
    -- then in the register
    cmd.RF_we <= '1';
    --Next state
    state_d <= S_Fetch;


---------- Instructions de saut ----------

---------- Instructions de chargement à partir de la mémoire ----------

---------- Instructions de sauvegarde en mémoire ----------

---------- Instructions d'accès aux CSR ----------

            when others => null;
        end case;

    end process FSM_comb;

end architecture;
