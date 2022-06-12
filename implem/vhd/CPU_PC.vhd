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
        S_AND,
        S_ANDI,
        S_OR,
        S_ORI,
        S_XOR,
        S_XORI,
        S_SUB,
        S_AUIPC,
        S_SLL,
        S_SLLI,
        S_SRA,
        S_SRAI,
        S_SRL,
        S_SRLI,
        S_BEQ,
        S_BLT,
        S_BNE,
        S_SLT,
        S_SLTI,
        S_JAL,
        S_JALR,
        S_BGE
    
        );

    signal state_d, state_q : State_type;
    signal cmd_cs : PO_cs_cmd;


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
        cmd.PC_sel            <= PC_from_pc;

        cmd.PC_X_sel          <= PC_X_pc;
        cmd.PC_Y_sel          <= PC_Y_immU;

        cmd.TO_PC_Y_sel       <= TO_PC_Y_immB;

        cmd.AD_we             <= '0';
        cmd.AD_Y_sel          <= AD_Y_immI;

        cmd.IR_we             <= '0';

        cmd.ADDR_sel          <= ADDR_from_pc;
        cmd.mem_we            <= '0';
        cmd.mem_ce            <= '0';

        cmd_cs.CSR_we            <= UNDEFINED;

        cmd_cs.TO_CSR_sel        <= UNDEFINED;
        cmd_cs.CSR_sel           <= UNDEFINED;
        cmd_cs.MEPC_sel          <= UNDEFINED;

        cmd_cs.MSTATUS_mie_set   <= 'U';
        cmd_cs.MSTATUS_mie_reset <= 'U';

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
                cmd.PC_we <= '1';
                state_d <= S_Init;

            if status.IR(6 downto 0)="0110111" then
			    	state_d <= S_LUI;
            elsif status.IR(6 downto 0)="0010111" then
                        state_d <= S_AUIPC;
		    elsif status.IR(6 downto 0)= "0010011" then
                        if status.IR(14 downto 12) = "000" then
				            state_d <= S_ADDI;
            	        elsif status.IR(14 downto 12) = "101" then
				            if status.IR(31 downto 25) = "0000000" then
					            state_d <= S_SRLI;
			                elsif status.IR(31 downto 25) = "0100000" then
					            state_d <= S_SRAI;
				            end if;
			            elsif status.IR(14 downto 12) = "001" then
				            if status.IR(31 downto 25) = "0000000" then
					            state_d <= S_SLLI;
				            end if;
			            elsif status.IR(14 downto 12) = "110" then
				            state_d <= S_ORI;
		                elsif status.IR(14 downto 12) = "111" then
				            state_d <= S_ANDI;
			            elsif status.IR(14 downto 12) = "100" then
				            state_d <= S_XORI;
                        elsif status.IR(14 downto 12) = "010" then
                            stat_d <= S_SLTI;
                        end if;

			    elsif status.IR(6 downto 0)="0110011" then
			        if status.IR(14 downto 12) = "000" then
			    	    if status.IR(31 downto 25) = "0000000" then
			    		     state_d <= S_ADD;
			            elsif status.IR(31 downto 25) = "0100000" then
				    	    state_d <= S_SUB; 
				        end if;
			        elsif status.IR(14 downto 12) = "111" then
				        if status.IR(31 downto 25) = "0000000" then
				    	    state_d <= S_AND;
				        end if;
			        elsif status.IR(14 downto 12) = "110" then
				        if status.IR(31 downto 25) = "0000000" then
				    	    state_d <= S_OR;
				        end if;
			        elsif status.IR(14 downto 12) = "100" then
				        if status.IR(31 downto 25) = "0000000" then
                            state_d <= S_XOR;
                        end if;
			        elsif status.IR(14 downto 12) = "101" then
				        if status.IR(31 downto 25) = "0000000" then
				    	    state_d <= S_SRL;
				        elsif status.IR(31 downto 25) = "0100000" then
				    	    state_d <= S_SRA;
				        end if;
			        elsif status.IR(14 downto 12) = "001" then
				        if status.IR(31 downto 25) = "0000000" then
				    	    state_d <= S_SLL;
                        elsif status.IR(14 downto 12) = "010" then
                            state_d <= S_SLT;
				        end if;
			        end if;
                elsif status.IR(6 downto 0) = "1101111" then
                    state_d <= S_JAL;
                elsif status.IR(6 downto 0) = "1100111" then
                    state_d <= S_JALR;
				elsif status.IR(6 downto 0)="1100011" then
                    if status.IR(14 downto 12)="000" then
                        state_d <= S_BEQ;
                    elsif status.IR(14 downto 12)="001" then
                        state_d <= S_BNE;
                    elsif status.IR(14 downto 12)="100" then
                        state_d <= S_BLT;
                    --elsif status.IR(14 downto 12)="101" then
                     --   state_d <= S_BGE;
                    else
                        state_d <= S_Error;
                    end if;
                else
                    state_d <= S_Error; -- Pour detecter les rates du decodage
                end if;

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
   
    -- next state
    state_d <= S_Fetch;

when S_ADDI =>
    --rd <- rs1 + immI
    cmd.RF_we <= '1';
    cmd.ALU_Y_sel <= ALU_Y_immI;
    cmd.ALU_op <= ALU_plus;
    cmd.DATA_sel <= DATA_from_alu;
    
    cmd.mem_ce <= '1';    
    --next state
    state_d <= S_Fetch;

--AUIPC rd, imm : R[rd] = PC + (imm << 12)
when S_AUIPC =>
    cmd.RF_we <= '1';
    cmd.PC_X_sel <= PC_X_pc;
    cmd.PC_Y_sel <= PC_Y_immU;
    cmd.DATA_sel <= DATA_from_pc;
    
    --PC take the value
    cmd.ADDR_sel <= ADDR_from_pc;
    cmd.mem_ce <= '1';

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

when S_BEQ =>
    case status.JCOND is
		when true =>
			cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
		when others =>
			cmd.TO_PC_Y_SEL <= TO_PC_Y_cst_x04;
	end case;
    
    cmd.PC_sel <= PC_from_pc;
    cmd.PC_we <= '1';
    state_d <= S_Fetch;


when S_BGE =>
    case status.JCOND is
		when true =>
			cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
		when others =>
			cmd.TO_PC_Y_SEL <= TO_PC_Y_cst_x04;
	end case;
    
    cmd.PC_sel <= PC_from_pc;
    cmd.PC_we <= '1';
    state_d <= S_Fetch;


when S_BNE =>
    case status.JCOND is
        when false =>
            cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
        when others =>
            cmd.TO_PC_Y_SEL <= TO_PC_Y_cst_x04;
        end case;
    cmd.PC_sel <= PC_from_pc;
    cmd.PC_we <= '1';
    state_d <= S_Fetch;

when S_BLT =>
    case status.JCOND is
        when true =>
            cmd.TO_PC_Y_sel <= TO_PC_Y_immB;
        when others =>
            cmd.TO_PC_Y_SEL <= TO_PC_Y_cst_x04;
        end case;
    cmd.PC_sel <= PC_from_pc;
    cmd.PC_we <= '1';
    state_d <= S_Fetch;


when S_SLT =>
    --we compare rs1 to the right value
    cmd.ALU_Y_sel <= ALU_Y_rf_rs2;
    
    --Now we have the right value we take 0 or 1 depending on the validation of the test
    cmd.DATA_sel <= DATA_from_slt;
    
    --then in the register
    cmd.RF_we <= '1';
    cmd.mem_ce <= '1';
    state_d <= S_Fetch;


when S_SLTI =>
    --we compare rs1 to the right value
    cmd.ALU_Y_sel <= ALU_Y_immI;
    --Now we have the right value we take 0 or 1 depending on the validation of the test
    cmd.DATA_sel <= DATA_from_slt;
    
    --then in the register
    cmd.RF_we <= '1';
    cmd.mem_ce <= '1';
    state_d <= S_Fetch;

when S_JAL =>
    --first we need to select the right values for the addition
    cmd.PC_X_sel <= PC_X_pc;
    cmd.PC_Y_sel <= PC_Y_cst_x04;

    --then we put it in the rd register
    cmd.DATA_sel <= DATA_from_pc;
    cmd.RF_we <= '1';

    --you get the constant from immJ because it is a jump instruction
    cmd.TO_PC_Y_SEL <= TO_PC_Y_immJ;
    --after the addition pc + cst you assign the value to pc
    cmd.PC_sel <= PC_from_pc;

    cmd.PC_we <= '1';
    state_d <= S_Fetch;

when S_JALR =>
    --first we need to select the right values for the addition
    cmd.PC_X_sel <= PC_X_pc;
    cmd.PC_Y_sel <= PC_Y_cst_x04;

    --then we put it in the rd register
    cmd.DATA_sel <= DATA_from_pc;
    cmd.RF_we <= '1';

    --then we take the immI value and add it to rs1
    cmd.ALU_Y_sel <= ALU_Y_immI;
    cmd.ALU_op <= ALU_plus;

    --now we assign this value to pc
    cmd.PC_sel <= PC_from_alu;
    cmd.PC_we <= '1';
    state_d <= S_Fetch;



            

---------- Instructions de chargement à partir de la mémoire ----------

---------- Instructions de sauvegarde en mémoire ----------

---------- Instructions d'accès aux CSR ----------

 when others => null;
        end case;

    end process FSM_comb;

end architecture;
