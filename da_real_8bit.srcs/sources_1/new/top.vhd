library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
--use work.pkg_processor.all;
--use work.pkg_instrmem.all;

entity toplevel is
    port (

        -- global ports
--        clk_in     : in STD_LOGIC;
        clk     : in std_logic;

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
signal cpu_reset: std_logic;
-----------------------------------

--Program Couunter
signal pc_pm_addr: std_logic_vector(8 downto 0);

--Program Memory
signal pm_dec_instr: std_logic_vector(15 downto 0);

--decoder
signal dec_rf_addr_opA          : std_logic_vector(4 downto 0);
signal dec_rf_addr_opB          : std_logic_vector(4 downto 0);
signal dec_alu_op_code          : std_logic_vector(3 downto 0);
signal dec_rf_we                : std_logic;
signal dec_sreg_we              : std_logic_vector(7 downto 0);
signal dec_rf_im                : std_logic;
signal dec_alu_im               : std_logic;
signal dec_im_val               : std_logic_vector(7 downto 0);
signal dec_dm_we                : std_logic;
signal dec_mux_alu_dm           : std_logic;
signal dec_pc_override_enable   : std_logic;
signal dec_pc_override_offset   : std_logic_vector(11 downto 0);
signal dec_sreg_override        : std_logic;
signal dec_sreg_override_val    : std_logic_vector(7 downto 0);
signal dec_sp_op                : std_logic;
signal dec_sp_use               : std_logic;

--Register File
signal rf_alu_data_a            : std_logic_vector(7 downto 0);
signal rf_alu_data_b            : std_logic_vector(7 downto 0);

--ALU
signal alu_mux_dm_output        : std_logic_vector(7 downto 0);
signal alu_sreg_new_sreg        : std_logic_vector(7 downto 0);

--SREG
signal sreg_alu_curr_status     : std_logic_vector(7 downto 0);

--Z-Address
signal dm_z_addr                    : std_logic_vector(9 downto 0);
signal z_data_src_bus               : std_logic_vector(1 downto 0);
signal z_addr_r31_we, z_addr_r30_we : std_logic := '0';
signal z_addr_out                   : std_logic_vector (9 downto 0);
signal z_data_in                    : std_logic_vector (7 downto 0);

--Stackpointer
signal sp_dm_addr                   : std_logic_vector(9 downto 0);

--Data Memory 1024
signal dm_mux_data_out                  : std_logic_vector(7 downto 0);

--Memeory Mapped Input/Output
signal io_ser           :std_logic_vector(7 downto 0);
signal io_seg0          :std_logic_vector(7 downto 0);
signal io_seg1          :std_logic_vector(7 downto 0);
signal io_seg2          :std_logic_vector(7 downto 0);
signal io_seg3          :std_logic_vector(7 downto 0);
signal port_for_btns    : std_logic_vector(7 downto 0);

--MUXing
signal mux_alu_dm_data          : std_logic_vector(7 downto 0);
signal mux_wb_im_rf_data_in     : std_logic_vector(7 downto 0);
signal mux_rf_dec_alu_data_b_in : std_logic_vector(7 downto 0);

component program_counter is
    port (
    reset               : in  std_logic;
    clk                 : in  std_logic;
    addr                : out std_logic_vector (8 downto 0);
    override_enable     : in std_logic;
    offset              : in std_logic_vector (11 downto 0)
    );
end component;

component program_memory is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component decoder is
    port(
        Instr               : in  std_logic_vector(15 downto 0);
        addr_opa            : out std_logic_vector(4 downto 0);
        addr_opb            : out std_logic_vector(4 downto 0);
        alu_op_code         : out std_logic_vector(3 downto 0);
        dbg_op_code         : out std_logic_vector(7 downto 0);
        w_e_regfile         : out std_logic;                    
        w_e_SREG            : out std_logic_vector(7 downto 0);     
        rf_immediate        : out std_logic;
        alu_immediate       : out std_logic;
        immediate_value     : out std_logic_vector(7 downto 0) := (others => '0');
        w_e_dm              : out std_logic;
        alu_dm_mux          : out std_logic;
        pc_force_override   : out std_logic;
        pc_override_offset  : out std_logic_vector(11 downto 0);
        sreg_override       : out std_logic;
        sreg_override_val   : out std_logic_vector(7 downto 0);
        sp_op               : out std_logic;
        use_sp_addr         : out std_logic
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
           status_in: in std_logic_vector(7 downto 0);
           branch_test_result: out std_logic
           );
end component;

component sreg
    Port ( clk              : in STD_LOGIC;
            reset           : in std_logic;
         w_e_sreg           : in std_logic_vector (7 downto 0);
         new_status_in      : in STD_LOGIC_VECTOR (7 downto 0);
         curr_status_out    : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');   --init everything to 0
         override           : in std_logic;
         override_val       : in std_logic_vector (7 downto 0)
        );
end component;

component z_addr
Port (   clk            : in STD_LOGIC;
         reset          : in STD_LOGIC;
         rf_addr_r30    : in STD_LOGIC;
         rf_addr_r31    : in STD_LOGIC;
         z_addr_val     : in STD_LOGIC_VECTOR (7 downto 0);
         z_addr_out     : out STD_LOGIC_VECTOR (9 downto 0));
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

begin

pc: program_counter
port map(
    reset               => cpu_reset,
    clk                 => clk,
    addr                => pc_pm_addr,
    override_enable     => '0',
    offset              => "000000000000"
);

pm: program_memory
port map(
    addr => pc_pm_addr,
    instr => pm_dec_instr
);

dec: decoder
port map (
    Instr               => pm_dec_instr,
    addr_opa            => dec_rf_addr_opA,
    addr_opb            => dec_rf_addr_opB,
    alu_op_code         => dec_alu_op_code,
    dbg_op_code         => open,
    w_e_regfile         => dec_rf_we,
    w_e_SREG            => dec_sreg_we,
    rf_immediate        => dec_rf_im,
    alu_immediate       => dec_alu_im,
    immediate_value     => dec_im_val,
    w_e_dm              => dec_dm_we,
    alu_dm_mux          => dec_mux_alu_dm,
    pc_force_override   => dec_pc_override_enable,
    pc_override_offset  => dec_pc_override_offset,
    sreg_override       => dec_sreg_override,
    sreg_override_val   => dec_sreg_override_val,
    sp_op               => dec_sp_op,
    use_sp_addr         => dec_sp_use
);

rf: register_file
port map(
    clk         => clk,
    addr_opa    => dec_rf_addr_opA,
    addr_opb    => dec_rf_addr_opB,
    write_addr  => dec_rf_addr_opA,
    w_e_regfile => dec_rf_we,
    data_opa    => rf_alu_data_a,
    data_opb    => rf_alu_data_b,
    data_in     => mux_wb_im_rf_data_in
);

alu0: ALU
port map(
    OPCODE              => dec_alu_op_code,
    OPA                 => rf_alu_data_a,
    OPB                 => mux_rf_dec_alu_data_b_in,
    RES                 => alu_mux_dm_output,
    new_status          => alu_sreg_new_sreg,
    status_in           => sreg_alu_curr_status,
    branch_test_result  => open
);

sreg0: sreg
port map(
    clk             => clk,
    reset           => cpu_reset,
    w_e_sreg        => dec_sreg_we,
    new_status_in   => alu_sreg_new_sreg,
    curr_status_out => sreg_alu_curr_status,
    override        => dec_sreg_override,
    override_val    => dec_sreg_override_val
);

z_addr0: z_addr
port map (
    clk         => clk,       
    reset       => cpu_reset,
    rf_addr_r30 => z_addr_r30_we,
    rf_addr_r31 => z_addr_r31_we,
    z_addr_val  => z_data_in,
    z_addr_out  => z_addr_out
);

sp: stackpointer
port map(
    clk     => clk,
    reset   => cpu_reset,
    op      => dec_sp_op,     
    use_sp  => dec_sp_use,
    addr    => sp_dm_addr
);

dm: data_memory_1024B
port map(
    clk             => clk,        
    write_enable    => dec_dm_we,
    z_addr          => dm_z_addr,
    z_data_in       => rf_alu_data_a,
    data            => dm_mux_data_out
);

mem_mapped_io0: mem_mapped_io
port map (
    clk         => clk,   
    w_e         => dec_dm_we,
    data        => rf_alu_data_a,
    z_addr      => z_addr_out,
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

-- Reseting the CPU
cpu_reset <= btnC AND btnD AND btnU;

-- z-addr logic: the src of the z_addr can be immdiate_values (LDI), Data memory Load (LD), MOV and the result of an ALU op
z_data_src_bus  <= dec_rf_im & dec_mux_alu_dm;        -- need to figure out the source of the data
--z_addr_r31_we   <= '1' when ((dec_rf_addr_opA(4) AND dec_rf_addr_opA(3) AND dec_rf_addr_opA(2) AND dec_rf_addr_opA(1) AND dec_rf_addr_opA(0) = '1') AND dec_rf_we = '1') else '0';
z_addr_r31_we   <= dec_rf_addr_opA(4) AND dec_rf_addr_opA(3) AND dec_rf_addr_opA(2) AND dec_rf_addr_opA(1) AND dec_rf_addr_opA(0) AND dec_rf_we;
--z_addr_r30_we   <= '1' when (dec_rf_addr_opA = "11110" AND dec_rf_we = '1') else '0';
z_addr_r30_we   <= dec_rf_addr_opA(4) AND dec_rf_addr_opA(3) AND dec_rf_addr_opA(2) AND dec_rf_addr_opA(1) AND NOT dec_rf_addr_opA(0) AND dec_rf_we;
--z_data_in       <= dec_im_val when z_data_src_bus = "10" else
--                rf_alu_data_a when z_data_src_bus = "00" else
--                mux_alu_dm_data when z_data_src_bus = "01" else (others => '0');
z_data_in       <= mux_wb_im_rf_data_in;
dm_z_addr <= sp_dm_addr when dec_sp_use = '1' else z_addr_out;


--IO
port_for_btns <= "000"&btnR&btnU&btnD&btnL&btnC;

--MUXing the data going out of the writeback stage: mux the result of the Writeback between ALU result and DM Result
mux_alu_dm_data <= alu_mux_dm_output when dec_mux_alu_dm = '0' else dm_mux_data_out;

--MUXing the data going into the rf
mux_wb_im_rf_data_in <= mux_alu_dm_data when dec_rf_im = '0' else dec_im_val;

--MUXing ALU's data_b between rf_data_b and decoder_immediate_Value
mux_rf_dec_alu_data_b_in <= rf_alu_data_b when dec_alu_im = '0' else dec_im_val;

end behavioral;


