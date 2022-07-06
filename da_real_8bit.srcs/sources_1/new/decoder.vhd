library ieee;
use ieee.std_logic_1164.all;
library work;
use work.pkg_processor.all;
--use work.utils.all;

entity decoder is
    port(
        Instr                       : in  std_logic_vector(15 downto 0);    -- Eingang vom Programmspeicher
        addr_opa                    : out std_logic_vector(4 downto 0);     -- Adresse von 1. Operand
        addr_opb                    : out std_logic_vector(4 downto 0);     -- Adresse von 2. Operand
        alu_op_code                 : out std_logic_vector(3 downto 0);     -- Opcode for ALU
        dbg_op_code                 : out std_logic_vector(7 downto 0);     -- opcode for debugging. does not go as input for anything
        w_e_regfile                 : out std_logic;                        -- write enable for Registerfile
        w_e_SREG                    : out std_logic_vector(7 downto 0);     -- einzeln Write_enables für SREG - Bits

        rf_immediate                : out std_logic;
        alu_immediate               : out std_logic;
        immediate_value             : out std_logic_vector(7 downto 0) := (others => '0');
        w_e_dm                      : out std_logic;
        alu_dm_mux                  : out std_logic;
        pc_force_override           : out std_logic;
        pc_override_offset          : out std_logic_vector(11 downto 0);
        sp_op                       : out std_logic;        --stackpointer operation type (increment(1) or decrement(0))
        use_sp_addr                 : out std_logic;         --use the stackpointer
        rcall_write                 : out std_logic;
        ret_read                    : out std_logic;
        sreg_branch_target_condition: out std_logic;
        sreg_branch_test_begin      : out std_logic;
        branch_control_enable       : out std_logic
    );
end decoder;

architecture behavioural of decoder is
begin

    -- purpose: Decodierprozess
    -- type   : combinational
    -- inputs : Instr
    -- outputs: addr_opa, addr_opb, OPCODE, w_e_regfile, w_e_SREG, ...
    dec_mux: process (Instr)
    begin  -- process dec_mux

        -- Vorzuweisung der Signale, um Latches zu verhindern
        addr_opa                        <= (others=>('0'));
        addr_opb                        <= (others=>('0'));
        alu_op_code                     <= (others=>('0'));
        w_e_regfile                     <= '0';
        w_e_SREG                        <= (others=>('0'));
        rf_immediate                    <= '0';
        alu_immediate                   <= '0';
        dbg_op_code                     <= (others=>('0'));
        immediate_value                 <= (others => '0');
        w_e_dm                          <= '0';
        alu_dm_mux                      <= '0';
        pc_override_offset              <= (others => '0');
        pc_force_override               <= '0';
        sp_op                           <= '0';
        use_sp_addr                     <= '0';
        rcall_write                     <= '0';
        ret_read                        <= '0';
        sreg_branch_target_condition    <= '0';
        sreg_branch_test_begin          <= '0';
        branch_control_enable           <= '0';

        --6bit codes
        case Instr(15 downto 10) is
            -- ADD, LSL
            when "000011" =>
                addr_opa <= Instr(8 downto 4);
                addr_opb <= Instr(9) & Instr (3 downto 0);
                alu_op_code <= op_add;
                w_e_regfile <= '1';
                w_e_SREG <= "00111111";
                dbg_op_code <= "0000"&op_add;



            when others =>

                --16bits codes
                case Instr(15 downto 0) is
                    --SEC
                    when "1001010000001000" =>
                        alu_op_code <= op_sec;
                        w_e_SREG <= "00000001";
                        dbg_op_code <= op_sec_dbg;

                    --CLC
                    when "1001010010001000" =>
                        alu_op_code <= op_clc;
                        w_e_SREG <= "00000001";
                        dbg_op_code <= op_clc_dbg;

                    --RET    
                    when "1001010100001000" =>
                        dbg_op_code <= op_ret;
                        branch_control_enable <= '1';
                        ret_read <= '1';
                        

                    when others => null;
                end case;

                --4bit codes
                case Instr(15 downto 12) is

                    -- SUB, CP, ROL, ADC
                    when "0001" =>
                        addr_opa <= Instr(8 downto 4);
                        addr_opb <= Instr(9) & Instr (3 downto 0);
                        case Instr(11 downto 10) is
                            --CP
                            when "01" =>
                                alu_op_code <= op_sub;
                                dbg_op_code <= "0000"&op_sub;
                            --SUB
                            when "10" =>
                                alu_op_code <= op_sub;
                                dbg_op_code <= "0000"&op_sub;
                            --ROLL, ADC
                            when "11" =>
                                alu_op_code <= op_adc;
                                dbg_op_code <= "0000"&op_adc;
                            when others => null;
                        end case;

                        --CP does not need to write to RF
                        if not(Instr(11 downto 10) = "01") then
                            w_e_regfile <= '1';
                        end if;
                        w_e_SREG <= "00111111";


                    --bitwise logic: AND, OR, EOR. and MOV
                    when "0010" =>
                        addr_opa <= Instr(8 downto 4);
                        addr_opb <= Instr(9) & Instr (3 downto 0);
                        w_e_regfile <= '1';

                        case Instr(11 downto 10) is
                            --AND
                            when "00" =>
                                alu_op_code <= op_and;
                                dbg_op_code <= "0000"&op_and;

                            --EOR
                            when "01" =>
                                alu_op_code <= op_eor;
                                dbg_op_code <= "0000"&op_eor;

                            --OR
                            when "10" =>
                                alu_op_code <= op_or;
                                dbg_op_code <= "0000"&op_or;

                            --MOV
                            when "11" =>
                                dbg_op_code <= "0000"&op_mov;
                                alu_op_code <= op_mov;


                            when others => null;
                        end case;

                        --SREG controll: AND, EOR and OR change the SREG and the RegFile. MOV changes the RegFile but not the SREG
                        if not (Instr(11 downto 10)="11") then
                            w_e_SREG <= "00011110"; --AND, EOR, OR
                        else
                            w_e_SREG <= "00000000"; --MOV
                        end if;

                    --LDI
                    when "1110" =>
                        addr_opa <= '1' & Instr(7 downto 4);
                        immediate_value <= Instr(11 downto 8) & Instr(3 downto 0);
                        w_e_regfile <= '1';
                        dbg_op_code <= op_ldi;
                        rf_immediate <= '1';

                    --CPI
                    when "0011" =>
                        addr_opa <= '1' & Instr(7 downto 4);
                        immediate_value <= Instr(11 downto 8) & Instr(3 downto 0);
                        alu_immediate <= '1';
                        alu_op_code <= op_sub;
                        w_e_SREG <= "00111111";
                        dbg_op_code <= "0000"&op_sub;


                    --SUBI
                    when "0101" =>
                        addr_opa <= '1' & Instr(7 downto 4);
                        immediate_value <= Instr(11 downto 8) & Instr(3 downto 0);
                        alu_immediate <= '1';
                        alu_op_code <= op_sub;
                        w_e_SREG <= "00111111";
                        w_e_regfile <= '1';
                        dbg_op_code <= "0000"&op_sub;

                    --ORI
                    when "0110" =>
                        addr_opa <= '1' & Instr(7 downto 4);
                        immediate_value <= Instr(11 downto 8) & Instr(3 downto 0);
                        alu_immediate <= '1';
                        alu_op_code <= op_or;
                        w_e_SREG <= "00011110";
                        w_e_regfile <= '1';
                        dbg_op_code <= "0000"&op_or;

                    --ANDI
                    when "0111" =>
                        addr_opa <= '1' & Instr(7 downto 4);
                        immediate_value <= Instr(11 downto 8) & Instr(3 downto 0);
                        alu_immediate <= '1';
                        alu_op_code <= op_and;
                        w_e_SREG <= "00011110";
                        w_e_regfile <= '1';
                        dbg_op_code <= "0000"&op_and;


                    --ST,LD (Store and Load)
                    when "1000" =>
                        case Instr(11 downto 9) is

                            --load
                            when "000" =>
                                dbg_op_code <= op_ld;
                                w_e_regfile <= '1';
                                alu_dm_mux <= '1';
                                addr_opa <= Instr(8 downto 4);

                            -- store
                            when "001" =>
                                w_e_dm <= '1';
                                dbg_op_code <= op_st;
                                addr_opa <= Instr(8 downto 4);

                            when others => null;
                        end case;

                    -- BRBS, BRBC    
                    when "1111" =>
                        case Instr(11 downto 10) is
                            --BRBS
                            when "00" =>
                                dbg_op_code <= "0000"&op_brbs;
                                w_e_SREG <= "00000"&Instr(2 downto 0);    --00000sss        --use the SREG signal, since its already connected to the SREG entity
                                pc_override_offset <= "00000"&Instr(9 downto 3);
                                branch_control_enable   <= '1';     --write the offset data into the Branch Control entity. it will wait for the result and adjust the PC.
                                sreg_branch_target_condition <= '1';    --the condition, which the Branch Control Entity will wait for, to adjust the PC
                                sreg_branch_test_begin <= '1';      --control signal, that lets the SREG do the comparison
   
                            --BRBC
                            when "01" =>
                                dbg_op_code <= "0000"&op_brbc;
                                w_e_SREG <= "00000"&Instr(2 downto 0);    --00000sss        --use the SREG signal, since its already connected to the SREG entity
                                pc_override_offset <= "00000"&Instr(9 downto 3);
                                branch_control_enable   <= '1';     --write the offset data into the Branch Control entity. it will wait for the result and adjust the PC.
                                sreg_branch_target_condition <= '0';    --the condition, which the Branch Control Entity will wait for, to adjust the PC
                                sreg_branch_test_begin <= '1';

                            when others => null;
                        end case;

                    --COM,ASR,DEC,INC,LSR,PUSH,POP        
                    when "1001" =>
                        case Instr(11 downto 9) is

                            --PUSH
                            when "001" =>
                                addr_opa <= Instr(8 downto 4);
                                w_e_dm <= '1';
                                dbg_op_code <= op_push;
                                sp_op <= '1';      --dec the stackpointer
                                use_sp_addr <= '1';

                            --POP
                            when "000" =>
                                addr_opa <= Instr(8 downto 4);
                                dbg_op_code <= op_pop;
                                w_e_regfile <= '1';
                                alu_dm_mux <= '1';
                                sp_op <= '0';      --inc the stackpointer
                                use_sp_addr <= '1';


                            --COM, ASR, DEC, INC, LSR
                            when "010" =>
                                case Instr(3 downto 0) is
                                    --COM
                                    when "0000" =>
                                        addr_opa <= Instr(8 downto 4);
                                        alu_op_code <= op_com;
                                        dbg_op_code <= "0000"&op_com;
                                        w_e_SREG <= "00010111";
                                        w_e_regfile <= '1';

                                    --ASR
                                    when "0101" =>
                                        addr_opa <= Instr(8 downto 4);
                                        alu_op_code <= op_asr;
                                        w_e_regfile <= '1';
                                        w_e_SREG <= "00011111";
                                        dbg_op_code <= "0000"&op_asr;


                                    --DEC
                                    when "1010" =>
                                        addr_opa <= Instr(8 downto 4);
                                        alu_immediate <= '1';
                                        immediate_value <= "00000001";
                                        alu_op_code <= op_sub;
                                        w_e_regfile <= '1';
                                        w_e_SREG <= "00011110";
                                        dbg_op_code <= "0000"&op_sub;

                                    --INC
                                    when "0011" =>
                                        addr_opa <= Instr(8 downto 4);
                                        alu_immediate <= '1';
                                        immediate_value <= "00000001";
                                        alu_op_code <= op_add;
                                        w_e_regfile <= '1';
                                        w_e_SREG <= "00011110";
                                        dbg_op_code <= "0000"&op_add;


                                    --LSR
                                    when "0110" =>
                                        addr_opa <= Instr(8 downto 4);
                                        alu_op_code <= op_lsr;
                                        dbg_op_code <= "0000"&op_lsr;
                                        w_e_regfile <= '1';
                                        w_e_SREG <= "00011111";

                                    when others => null;
                                end case;
                            when others => null;
                        end case;

                    --RJMP
                    when "1100" =>
                        dbg_op_code <= op_rjmp;
                        pc_override_offset <= Instr(11 downto 0);
                        pc_force_override <= '1';
                        branch_control_enable <= '1';

                    --RCALL
                    when "1101" =>
                        dbg_op_code <= op_rcall;
                        pc_override_offset <= Instr(11 downto 0);
                        branch_control_enable <= '1';
                        rcall_write <= '1';

                    when others => null;
                end case;
        end case;

    end process dec_mux;
end behavioural;