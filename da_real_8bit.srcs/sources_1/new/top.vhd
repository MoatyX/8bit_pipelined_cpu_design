library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity toplevel is
    port (

        -- global ports
        clk_in     : in STD_LOGIC;
--        clk     : in std_logic;

        led     : out std_logic_vector(15 downto 0) := (others => '1');
        sw      : in std_logic_vector(15 downto 0);
        seg     : out std_logic_vector(6 downto 0) := (others => '1');
        an      : out std_logic_vector(3 downto 0) := (others => '0');
        dp      : out std_logic := '1';

        btnU    : in STD_LOGIC;
        btnD    : in STD_LOGIC;
        btnC    : in STD_LOGIC;
        btnL    : in STD_LOGIC;
        btnR    : in STD_LOGIC
    );

end toplevel;

architecture behavioral of toplevel is

--CPU
signal clk      : std_logic;
signal cpu_reset: std_logic;
-----------------------------------

--Program Couunter
signal pc_pm_addr: std_logic_vector(8 downto 0);

--Program Memory
signal pm_dec_instr: std_logic_vector(15 downto 0);

--decoder
signal dec_rf_addr_opA                      : std_logic_vector(4 downto 0);
signal dec_rf_addr_opB                      : std_logic_vector(4 downto 0);
signal dec_alu_op_code                      : std_logic_vector(3 downto 0);
signal dec_rf_we                            : std_logic;
signal dec_sreg_we                          : std_logic_vector(7 downto 0);
signal dec_rf_im                            : std_logic;
signal dec_alu_im                           : std_logic;
signal dec_im_val                           : std_logic_vector(7 downto 0);
signal dec_dm_we                            : std_logic;
signal dec_mux_alu_dm                       : std_logic;
signal dec_bc_override_enable               : std_logic;
signal dec_bc_override_offset               : std_logic_vector(11 downto 0);
signal dec_sp_op                            : std_logic;
signal dec_sp_use                           : std_logic;
signal dec_bc_enable                        : std_logic;
signal dec_bc_sreg_branch_target_condition  : std_logic;
signal dec_bc_sreg_branch_test_begin        : std_logic;
signal dec_pc_hold                          : std_logic;
signal dec_rcall_write                      : std_logic;

--Register File
signal rf_alu_data_a            : std_logic_vector(7 downto 0);
signal rf_alu_data_b            : std_logic_vector(7 downto 0);

--ALU
signal alu_data_output          : std_logic_vector(7 downto 0);
signal alu_sreg_new_sreg        : std_logic_vector(7 downto 0);

--SREG
signal sreg_alu_curr_status     : std_logic_vector(7 downto 0);
signal sreg_branch_result       : std_logic;

--Z-Address
signal z_addr_out                   : std_logic_vector (9 downto 0);

--Stackpointer
signal sp_dm_addr                   : std_logic_vector(9 downto 0);

--Data Memory 1024
signal dm_data_out                  : std_logic_vector(7 downto 0);

--Memeory Mapped Input/Output
signal io_ser           :std_logic_vector(7 downto 0);
signal io_seg0          :std_logic_vector(7 downto 0);
signal io_seg1          :std_logic_vector(7 downto 0);
signal io_seg2          :std_logic_vector(7 downto 0);
signal io_seg3          :std_logic_vector(7 downto 0);
signal port_for_btns    : std_logic_vector(7 downto 0);

--Branch Control
signal bc_pc_override_now       : std_logic;
signal bc_pc_override_offset    : std_logic_vector(11 downto 0);
signal bc_mux_nop               : std_logic;

--rcall_ret
signal rrc_dm_data_src      : std_logic;
signal rcc_sp_op            : std_logic;
signal rcc_sp_use           : std_logic;
signal rcc_dm_we            : std_logic;
signal rcc_bc_rcall_finish  : std_logic;
signal rcc_byte             : std_logic_vector(7 downto 0);
signal rcc_offset_out       : std_logic_vector(11 downto 0);


--MUXing
signal mux_alu_data_b               : std_logic_vector(7 downto 0);
signal mux_exec_data_out            : std_logic_vector(7 downto 0);
signal mux_z_addr_src               : std_logic_vector(9 downto 0);
signal mux_wb_data                  : std_logic_vector(7 downto 0);
signal mux_instruction              : std_logic_vector(15 downto 0);
signal mux_bc_override_now          : std_logic;
signal mux_bc_override_offset       : std_logic_vector(11 downto 0);

----------------------Pipelining Signals--------------------------------------------------------

--Decode <-----> RegFile
signal pl_rf_alu_op_code              : std_logic_vector(3 downto 0);
signal pl_rf_rf_we                    : std_logic;
signal pl_rf_sreg_we                  : std_logic_vector(7 downto 0);
signal pl_rf_rf_im                    : std_logic;
signal pl_rf_alu_im                   : std_logic;
signal pl_rf_im_val                   : std_logic_vector(7 downto 0)    := (others => '0');
signal pl_rf_dataMem_we               : std_logic;
signal pl_rf_mux_alu_dm               : std_logic;
signal pl_rf_sp_op                    : std_logic;
signal pl_rf_sp_use                   : std_logic;
signal pl_rf_addr_a                   : std_logic_vector(4 downto 0);
signal pl_rf_addr_b                   : std_logic_vector(4 downto 0);
signal pl_rf_sreg_branch_test           : std_logic;
signal pl_rf_sreg_branch_target         : std_logic;
signal pl_rf_rrc_offset                 : std_logic_vector(11 downto 0);
signal pl_rf_rrc_offset_byte            : std_logic_vector(7 downto 0);
signal pl_rf_rrc_dm_data_src            : std_logic;
signal pl_rf_rrc_bc_rcall_finish        : std_logic;

--RegFile <-----> Execute
signal pl_exec_addr_a                   : std_logic_vector(4 downto 0);
signal pl_exec_addr_b                   : std_logic_vector(4 downto 0);
signal pl_exec_data_a                   : std_logic_vector(7 downto 0);
signal pl_exec_data_b                   : std_logic_vector(7 downto 0);
signal pl_exec_alu_op                   : std_logic_vector(3 downto 0);
signal pl_exec_rf_we                    : std_logic;
signal pl_exec_sreg_we                  : std_logic_vector(7 downto 0);
signal pl_exec_rf_im                    : std_logic;
signal pl_exec_alu_im                   : std_logic;
signal pl_exec_im_val                   : std_logic_vector(7 downto 0)  := (others => '0');
signal pl_exec_dm_we                    : std_logic;
signal pl_exec_mux_alu_dm               : std_logic;
signal pl_exec_sp_op                    : std_logic;
signal pl_exec_sp_use                   : std_logic;
signal pl_exec_sreg_branch_test           : std_logic;
signal pl_exec_sreg_branch_target         : std_logic;
signal pl_exec_rrc_offset                 : std_logic_vector(11 downto 0);
signal pl_exec_rrc_offset_byte            : std_logic_vector(7 downto 0);
signal pl_exec_rrc_dm_data_src            : std_logic;
signal pl_exec_rrc_bc_rcall_finish        : std_logic;

--Execute <-----> Writeback
signal pl_wb_addr_a                     : std_logic_vector(4 downto 0);
signal pl_wb_rf_we                      : std_logic;
signal pl_wb_mux_alu_dm                 : std_logic;
signal pl_wb_dm_data                    : std_logic_vector(7 downto 0);
signal pl_wb_alu_data                   : std_logic_vector(7 downto 0);
signal pl_wb_sreg_branch_test           : std_logic;
signal pl_wb_sreg_branch_result         : std_logic;
signal pl_wb_rrc_offset                 : std_logic_vector(11 downto 0);
signal pl_wb_rrc_bc_rcall_finish        : std_logic;


--Executre Feedforwarding mechanic
signal rf_feedfwd_data_a_condition      : std_logic := '0';
signal rf_feedfwd_data_b_condition      : std_logic := '0';
signal rf_feedfwd_data_a_out            : std_logic_vector(7 downto 0);
signal rf_feedfwd_data_b_out            : std_logic_vector(7 downto 0);
signal exec_feedfwd_data_a_condition    : std_logic := '0';
signal exec_feedfwd_data_b_condition    : std_logic := '0';
signal exec_feedfwd_data_a_out          : std_logic_vector(7 downto 0);
signal exec_feedfwd_data_b_out          : std_logic_vector(7 downto 0);
signal pre_exec_feedfwd_data_a_condition: std_logic; 
signal pre_exec_feedfwd_data_b_condition: std_logic;
signal pre_exec_feedfwd_data_a_condition2: std_logic; 
signal pre_exec_feedfwd_data_b_condition2: std_logic;

signal pl_mux_bc_override_now          : std_logic;
signal pl_mux_bc_override_offset       : std_logic_vector(11 downto 0);

--------------------------------------------------------------------------------

component program_counter is
    port (
    reset               : in  std_logic;
    clk                 : in  std_logic;
    addr                : out std_logic_vector (8 downto 0);
    override_enable     : in std_logic;
    offset              : in std_logic_vector (11 downto 0);
    hold                : in std_logic
    );
end component;

component program_memory is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component decoder is
    port(
        Instr                       : in  std_logic_vector(15 downto 0);
        addr_opa                    : out std_logic_vector(4 downto 0);
        addr_opb                    : out std_logic_vector(4 downto 0);
        alu_op_code                 : out std_logic_vector(3 downto 0);
        dbg_op_code                 : out std_logic_vector(7 downto 0);
        w_e_regfile                 : out std_logic;
        w_e_SREG                    : out std_logic_vector(7 downto 0);
        rf_immediate                : out std_logic;
        alu_immediate               : out std_logic;
        immediate_value             : out std_logic_vector(7 downto 0) := (others => '0');
        w_e_dm                      : out std_logic;
        alu_dm_mux                  : out std_logic;
        pc_force_hold               : out std_logic;
        pc_force_override           : out std_logic;
        pc_override_offset          : out std_logic_vector(11 downto 0);
        sp_op                       : out std_logic;
        use_sp_addr                 : out std_logic;
        rcall_write                 : out std_logic;
        ret_read                    : out std_logic;
        rcall_ret_writter_enable    : out std_logic;
        sreg_branch_target_condition: out std_logic;
        sreg_branch_test_begin      : out std_logic;
        branch_control_enable       : out std_logic
    );
end component;

component register_file
    Port ( 
            clk: in STD_LOGIC;
            addr_opa : in STD_LOGIC_VECTOR (4 downto 0);
            addr_opb : in STD_LOGIC_VECTOR (4 downto 0);
            write_addr: in std_logic_vector (4 downto 0);
            w_e_regfile : in STD_LOGIC;
            data_opa : out STD_LOGIC_VECTOR (7 downto 0);
            data_opb : out STD_LOGIC_VECTOR (7 downto 0);
            data_in : in STD_LOGIC_VECTOR (7 downto 0)
          );
end component;

component ALU
    Port ( OPCODE : in STD_LOGIC_VECTOR (3 downto 0);
           OPA : in STD_LOGIC_VECTOR (7 downto 0);
           OPB : in STD_LOGIC_VECTOR (7 downto 0);
           RES : out STD_LOGIC_VECTOR (7 downto 0);
           new_status : out STD_LOGIC_VECTOR (7 downto 0);
           status_in: in std_logic_vector(7 downto 0)
           );
end component;

component sreg
    Port (  clk                : in STD_LOGIC;
            reset              : in std_logic;
            w_e_sreg           : in std_logic_vector (7 downto 0);
            new_status_in      : in STD_LOGIC_VECTOR (7 downto 0);
            sreg_branch_test   : in std_logic;
            curr_status_out    : out STD_LOGIC_VECTOR (7 downto 0);
            sreg_branch_result : out std_logic
        );
end component;

component z_addr
Port (   clk                    : in STD_LOGIC;
         reset                  : in STD_LOGIC;
         addr_a                 : in std_logic_vector(4 downto 0);
         rf_write_enable_status : in std_logic;
         data_in                : in STD_LOGIC_VECTOR (7 downto 0);
         z_addr_out             : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component stackpointer
Port (clk       : in STD_LOGIC;
      reset     : in STD_LOGIC;
      op        : in STD_LOGIC;
      use_sp    : in STD_LOGIC;
      addr      : out STD_LOGIC_VECTOR (9 downto 0));
end component;

component data_memory_1024B
    Port ( clk          : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           z_addr       : in STD_LOGIC_VECTOR (9 downto 0);
           z_data_in    : in STD_LOGIC_VECTOR (7 downto 0);
           data         : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component mem_mapped_io
    Port (   clk        : in STD_LOGIC;
             reset      : in std_logic;
             w_e        : in STD_LOGIC;
             data       : in std_logic_vector(7 downto 0);
             z_addr     : in STD_LOGIC_VECTOR (9 downto 0);
             portb      : out STD_LOGIC_VECTOR (7 downto 0);
             portc      : out STD_LOGIC_VECTOR (7 downto 0);
             io_addr    : out std_logic;
             ser        : out std_logic_vector(7 downto 0);
             seg0       : out std_logic_vector(7 downto 0);
             seg1       : out std_logic_vector(7 downto 0);
             seg2       : out std_logic_vector(7 downto 0);
             seg3       : out std_logic_vector(7 downto 0);
             pinb_in    : in std_logic_vector(7 downto 0);
             pinc_in    : in std_logic_vector(7 downto 0);
             pind_in    : in std_logic_vector(7 downto 0)
            );
end component;

component seg_view_controller
    Port (  clk     : in STD_LOGIC;
            reset   : in std_logic;
            
            ser      : in std_logic_vector(7 downto 0);
            seg0     : in std_logic_vector(7 downto 0);
            seg1     : in std_logic_vector(7 downto 0);
            seg2     : in std_logic_vector(7 downto 0);
            seg3     : in std_logic_vector(7 downto 0);
            
            seg     : out STD_LOGIC_VECTOR (6 downto 0);
            an      : out STD_LOGIC_VECTOR (3 downto 0);
            db      : out STD_LOGIC);
end component;

component clk_wiz_0
    port (
        clk_out1: out std_logic;
        reset: in std_logic;
        locked: out std_logic;
        clk_in1: in std_logic
    );
end component;

component branch_control
    port(
           clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           enable                       : in STD_LOGIC;
           sreg_condition_resolved      : in STD_LOGIC;
           sreg_target_condition        : in STD_LOGIC;
           sreg_condition_result        : in STD_LOGIC;
           sreg_branch_test             : in std_logic;
           force_override               : in STD_LOGIC;
           branch_offset_in             : in STD_LOGIC_VECTOR (11 downto 0);
           branch_offset_out            : out STD_LOGIC_VECTOR (11 downto 0);
           insert_nop                   : out STD_LOGIC;
           pc_override_now              : out STD_LOGIC
    );
end component;

component rcall_ret_controller
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           ret_read : in STD_LOGIC;
           rcall_write : in STD_LOGIC;
           target_offset : in STD_LOGIC_VECTOR (11 downto 0);
           target_offset_out : out STD_LOGIC_VECTOR (11 downto 0);
           rcall_write_finish : out STD_LOGIC;
           offset_byte : out STD_LOGIC_VECTOR (7 downto 0);
           sp_use : out STD_LOGIC;
           sp_op : out STD_LOGIC;
           dataMem_we : out STD_LOGIC);
end component;           

begin

pc: program_counter
port map(
    reset               => cpu_reset,
    clk                 => clk,
    addr                => pc_pm_addr,
    override_enable     => bc_pc_override_now,
    offset              => bc_pc_override_offset,
    hold                => dec_pc_hold
);

pm: program_memory
port map(
    addr => pc_pm_addr,
    instr => pm_dec_instr
);

dec: decoder
port map (
    Instr                               => mux_instruction,
    addr_opa                            => dec_rf_addr_opA,
    addr_opb                            => dec_rf_addr_opB,
    alu_op_code                         => dec_alu_op_code,
    dbg_op_code                         => open,
    w_e_regfile                         => dec_rf_we,
    w_e_SREG                            => dec_sreg_we,
    rf_immediate                        => dec_rf_im,
    alu_immediate                       => dec_alu_im,
    immediate_value                     => dec_im_val,
    w_e_dm                              => dec_dm_we,
    alu_dm_mux                          => dec_mux_alu_dm,
    pc_force_override                   => dec_bc_override_enable,
    pc_override_offset                  => dec_bc_override_offset,
    sp_op                               => dec_sp_op,
    use_sp_addr                         => dec_sp_use,
    branch_control_enable               => dec_bc_enable,
    sreg_branch_target_condition        => dec_bc_sreg_branch_target_condition,
    sreg_branch_test_begin              => dec_bc_sreg_branch_test_begin,
    pc_force_hold                       => dec_pc_hold,
    rcall_write                         => dec_rcall_write
);

rf: register_file
port map(
    clk         => clk,
    addr_opa    => pl_rf_addr_a,
    addr_opb    => pl_rf_addr_b,
    write_addr  => pl_wb_addr_a,
    w_e_regfile => pl_wb_rf_we,
    data_opa    => rf_alu_data_a,
    data_opb    => rf_alu_data_b,
    data_in     => mux_wb_data
);

alu0: ALU
port map(
    OPCODE              => pl_exec_alu_op,
    OPA                 => exec_feedfwd_data_a_out,
    OPB                 => mux_alu_data_b,
    RES                 => alu_data_output,
    new_status          => alu_sreg_new_sreg,
    status_in           => sreg_alu_curr_status
);

sreg0: sreg
port map(
    clk                 => clk,
    reset               => cpu_reset,
    w_e_sreg            => pl_exec_sreg_we,
    new_status_in       => alu_sreg_new_sreg,
    curr_status_out     => sreg_alu_curr_status,
    sreg_branch_result  => sreg_branch_result,
    sreg_branch_test    => pl_exec_sreg_branch_test
);

z_addr0: z_addr
port map (
    clk                     => clk,       
    reset                   => cpu_reset,
    addr_a                  => pl_exec_addr_a,
    rf_write_enable_status  => pl_exec_rf_we,
    data_in                 => mux_exec_data_out,
    z_addr_out              => z_addr_out
);

sp: stackpointer
port map(
    clk     => clk,
    reset   => cpu_reset,
    op      => pl_exec_sp_op,     
    use_sp  => pl_exec_sp_use,
    addr    => sp_dm_addr
);

dm: data_memory_1024B
port map(
    clk             => clk,        
    write_enable    => pl_exec_dm_we,
    z_addr          => mux_z_addr_src,
    z_data_in       => pl_exec_data_a,
    data            => dm_data_out
);

mem_mapped_io0: mem_mapped_io
port map (
    clk         => clk,
    reset       => cpu_reset,   
    w_e         => pl_exec_dm_we,
    data        => pl_exec_data_a,
    z_addr      => mux_z_addr_src,
    portb       => led(7 downto 0),
    portc       => led(15 downto 8),
    io_addr     => open,
    ser         => io_ser,
    seg0        => io_seg0,
    seg1        => io_seg1,
    seg2        => io_seg2,
    seg3        => io_seg3,
    pinb_in     => sw(7 downto 0),
    pinc_in     => sw(15 downto 8),
    pind_in     => port_for_btns
);

seg_view_controller0: seg_view_controller
port map(
    clk     => clk,
    reset   => cpu_reset,  
    ser     => io_ser,
    seg0    => io_seg0,
    seg1    => io_seg1,
    seg2    => io_seg2,
    seg3    => io_seg3,
    seg     => seg,
    an      => an,
    db      => dp
);

--clk <= clk_in;
clk_wiz: clk_wiz_0
port map (
    clk,
    cpu_reset,
    open,
    clk_in
);

branch_control0: branch_control
port map(
    clk                         => clk,
    reset                       => cpu_reset,
    enable                      => dec_bc_enable,
    sreg_condition_resolved     => pl_wb_sreg_branch_test,
    sreg_target_condition       => dec_bc_sreg_branch_target_condition,   
    sreg_condition_result       => pl_wb_sreg_branch_result,  
    sreg_branch_test            => dec_bc_sreg_branch_test_begin,              
    force_override              => dec_bc_override_enable,        
    branch_offset_in            => dec_bc_override_offset,
    branch_offset_out           => bc_pc_override_offset,
    pc_override_now             => bc_pc_override_now,
    insert_nop                  => bc_mux_nop
);

stack_branch_ctrl: rcall_ret_controller
port map (
    clk                     => clk,
    reset                   => cpu_reset,
    enable                  => dec_rcall_write,
    ret_read                => '0',
    rcall_write             => dec_rcall_write,
    target_offset           => dec_bc_override_offset,
    target_offset_out       => rcc_offset_out,
    rcall_write_finish      => rcc_bc_rcall_finish,
    offset_byte             => rcc_byte,
    sp_use                  => rcc_sp_use,
    sp_op                   => rcc_sp_op,
    dataMem_we              => rcc_dm_we
);

process(clk)
begin
    if(rising_edge(clk)) then
        if(cpu_reset = '1') then
            pl_mux_bc_override_now <= '0';
            pl_mux_bc_override_offset <= (others => '0');
        else
            pl_mux_bc_override_now <= mux_bc_override_now;
            pl_mux_bc_override_offset <= mux_bc_override_offset;            
        end if;
    end if;
end process;

--pipeline Fetch -> RegRead
process(clk)
begin
    if(rising_edge(clk)) then
        if(cpu_reset = '1') then
            pl_rf_alu_op_code                   <= (others => '0');
            pl_rf_rf_we                         <= '0';      
            pl_rf_sreg_we                       <= (others => '0');   
            pl_rf_dataMem_we                    <= '0';
            pl_rf_mux_alu_dm                    <= '0'; 
            pl_rf_sp_op                         <= '0';      
            pl_rf_sp_use                        <= '0';     
            pl_rf_im_val                        <= (others => '0');    
            pl_rf_alu_im                        <= '0';     
            pl_rf_addr_a                        <= (others => '0');
            pl_rf_addr_b                        <= (others => '0');
            pl_rf_rf_im                         <= '0';
            pre_exec_feedfwd_data_a_condition   <= '0';
            pre_exec_feedfwd_data_b_condition   <= '0';
            pl_rf_sreg_branch_target            <= '0';
            pl_rf_sreg_branch_test              <= '0';
            pl_rf_rrc_offset                    <= (others => '0');         
            pl_rf_rrc_offset_byte               <= (others => '0');  
            pl_rf_rrc_dm_data_src               <= '0';    
            pl_rf_rrc_bc_rcall_finish           <= '0';            
        else
            pl_rf_alu_op_code                   <= dec_alu_op_code;
            pl_rf_rf_we                         <= dec_rf_we;      
            pl_rf_sreg_we                       <= dec_sreg_we;    
            pl_rf_dataMem_we                    <= dec_dm_we;      
            pl_rf_mux_alu_dm                    <= dec_mux_alu_dm; 
            pl_rf_sp_op                         <= dec_sp_op;      
            pl_rf_sp_use                        <= dec_sp_use;     
            pl_rf_im_val                        <= dec_im_val;     
            pl_rf_alu_im                        <= dec_alu_im;     
            pl_rf_addr_a                        <= dec_rf_addr_opA;
            pl_rf_addr_b                        <= dec_rf_addr_opB;
            pl_rf_rf_im                         <= dec_rf_im;
            pre_exec_feedfwd_data_a_condition   <= exec_feedfwd_data_a_condition;
            pre_exec_feedfwd_data_b_condition   <= exec_feedfwd_data_b_condition;
            pl_rf_sreg_branch_target            <= dec_bc_sreg_branch_target_condition;
            pl_rf_sreg_branch_test              <= dec_bc_sreg_branch_test_begin;
            pl_rf_rrc_offset                    <= rcc_offset_out;
            pl_rf_rrc_offset_byte               <= rcc_byte;
            pl_rf_rrc_dm_data_src               <= dec_rcall_write;            
            pl_rf_rrc_bc_rcall_finish           <= rcc_bc_rcall_finish;                        
        end if;
    end if;
end process;

--Pipeline RegFile --> Execute
process(clk)
begin
    if(rising_edge(clk)) then
        if(cpu_reset = '1') then
            pl_exec_addr_a                          <= (others => '0');  
            pl_exec_addr_b                          <= (others => '0');
            pl_exec_data_a                          <= (others => '0');
            pl_exec_data_b                          <= (others => '0');
            pl_exec_alu_op                          <= (others => '0');
            pl_exec_rf_we                           <= '0';
            pl_exec_sreg_we                         <= (others => '0');
            pl_exec_rf_im                           <= '0';
            pl_exec_alu_im                          <= '0';
            pl_exec_im_val                          <= (others => '0');
            pl_exec_dm_we                           <= '0';
            pl_exec_mux_alu_dm                      <= '0';
            pl_exec_sp_op                           <= '0';
            pl_exec_sp_use                          <= '0';
            pre_exec_feedfwd_data_a_condition2      <= '0';
            pre_exec_feedfwd_data_b_condition2      <= '0';
            pl_exec_sreg_branch_test                <= '0';
            pl_exec_sreg_branch_target              <= '0';
            pl_exec_rrc_bc_rcall_finish             <= '0';
            pl_exec_rrc_dm_data_src                 <= '0';
            pl_exec_rrc_offset                      <= (others => '0');
            pl_exec_rrc_offset_byte                 <= (others => '0');
        else
            pl_exec_addr_a                          <= pl_rf_addr_a; 
            pl_exec_addr_b                          <= pl_rf_addr_b;
            pl_exec_data_a                          <= rf_feedfwd_data_a_out;
            pl_exec_data_b                          <= rf_feedfwd_data_b_out;
            pl_exec_alu_op                          <= pl_rf_alu_op_code;
            pl_exec_rf_we                           <= pl_rf_rf_we;
            pl_exec_sreg_we                         <= pl_rf_sreg_we;
            pl_exec_rf_im                           <= pl_rf_rf_im;
            pl_exec_alu_im                          <= pl_rf_alu_im;
            pl_exec_im_val                          <= pl_rf_im_val;
            pl_exec_dm_we                           <= pl_rf_dataMem_we;
            pl_exec_mux_alu_dm                      <= pl_rf_mux_alu_dm;
            pl_exec_sp_op                           <= pl_rf_sp_op;
            pl_exec_sp_use                          <= pl_rf_sp_use;
            pre_exec_feedfwd_data_a_condition2      <= pre_exec_feedfwd_data_a_condition;
            pre_exec_feedfwd_data_b_condition2      <= pre_exec_feedfwd_data_b_condition;
            pl_exec_sreg_branch_target              <= pl_rf_sreg_branch_target;
            pl_exec_sreg_branch_test                <= pl_rf_sreg_branch_test;
            pl_exec_rrc_bc_rcall_finish             <= pl_rf_rrc_bc_rcall_finish;
            pl_exec_rrc_dm_data_src                 <= pl_rf_rrc_dm_data_src;
            pl_exec_rrc_offset                      <= pl_rf_rrc_offset;
            pl_exec_rrc_offset_byte                 <= pl_rf_rrc_offset_byte;            
        end if;
    end if;
end process;

process(clk)
begin
    if(rising_edge(clk)) then
        if(cpu_reset = '1') then
            pl_wb_addr_a                <= (others => '0');
            pl_wb_alu_data              <= (others => '0');
            pl_wb_rf_we                 <= '0';
            pl_wb_dm_data               <= (others => '0');
            pl_wb_mux_alu_dm            <= '0';
            pl_wb_sreg_branch_result    <= '0';
            pl_wb_sreg_branch_test      <= '0';
            pl_wb_rrc_bc_rcall_finish   <= '0';
            pl_wb_rrc_offset            <= (others => '0');
        else
            pl_wb_addr_a                <= pl_exec_addr_a;
            pl_wb_alu_data              <= mux_exec_data_out;
            pl_wb_rf_we                 <= pl_exec_rf_we;
            pl_wb_dm_data               <= dm_data_out;
            pl_wb_mux_alu_dm            <= pl_exec_mux_alu_dm;
            pl_wb_sreg_branch_result    <= sreg_branch_result;
            pl_wb_sreg_branch_test      <= pl_exec_sreg_branch_test;
            pl_wb_rrc_bc_rcall_finish   <= pl_exec_rrc_bc_rcall_finish;
            pl_wb_rrc_offset            <= pl_exec_rrc_offset;            
        end if;
    end if;
end process;

-- Reseting the CPU
cpu_reset <= btnC AND btnD AND btnU;

--IO
port_for_btns <= "000"&btnR&btnU&btnD&btnL&btnC;

----MUXing ALU's data_b between the incoming data_b and decoder_immediate_Value (important for CPI, ANDI...etc)
mux_alu_data_b <= exec_feedfwd_data_b_out when pl_exec_alu_im = '0' else pl_exec_im_val;

--MUX the final data output of the execute stage
mux_exec_data_out <= alu_data_output when pl_exec_rf_im = '0' else pl_exec_im_val;

--MUX the source of the z_addr
mux_z_addr_src  <= z_addr_out when pl_exec_sp_use = '0' else sp_dm_addr;

--MUX the final data coming out of the pipelines going into the RF
mux_wb_data <= pl_wb_alu_data when pl_wb_mux_alu_dm = '0' else pl_wb_dm_data;

--MUX the instruction going into the decoder. used for inserting NOPs to force the CPU to wait
mux_instruction <= pm_dec_instr when bc_mux_nop = '0' else (others => '0');

--MUX where the PC override now signal is coming from (important for RCALL and RET)
mux_bc_override_now <= dec_bc_override_enable when pl_wb_rrc_bc_rcall_finish = '0'  else '1';
mux_bc_override_offset  <= dec_bc_override_offset when pl_wb_rrc_bc_rcall_finish = '0' else pl_wb_rrc_offset;


--Execute Stage - ALU_In Feedfwd mechanic
exec_feedfwd_data_a_condition   <= '1' when (dec_rf_addr_opA = pl_rf_addr_a AND dec_rf_we = '1') else '0';
exec_feedfwd_data_b_condition   <= '1' when (dec_rf_addr_opB = pl_rf_addr_a AND dec_rf_we = '1') else '0';
exec_feedfwd_data_a_out         <= pl_exec_data_a when pre_exec_feedfwd_data_a_condition2 = '0' else mux_wb_data;
exec_feedfwd_data_b_out         <= pl_exec_data_b when pre_exec_feedfwd_data_b_condition2 = '0' else mux_wb_data;

--Decode Stage - RegFile_Out Feedfwd Mechanic
rf_feedfwd_data_a_condition   <= '1' when (pl_rf_addr_a = pl_wb_addr_a AND pl_wb_rf_we = '1') else '0';
rf_feedfwd_data_b_condition   <= '1' when (pl_rf_addr_b = pl_wb_addr_a AND pl_wb_rf_we = '1') else '0';
rf_feedfwd_data_a_out         <= rf_alu_data_a when rf_feedfwd_data_a_condition = '0' else mux_wb_data;
rf_feedfwd_data_b_out         <= rf_alu_data_b when rf_feedfwd_data_b_condition = '0' else mux_wb_data;

end behavioral;


