----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2022 05:34:10 PM
-- Design Name: 
-- Module Name: branch_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch_control is
    Port ( clk                              : in STD_LOGIC;
         reset                            : in STD_LOGIC;

         enable_bc                        : in STD_LOGIC;                         --tell the branch_control, that a branch action should happen
         rcall_write                      : in std_logic;                         --When RCALL is called
         branch_cond_ready                : in std_logic;                         --when this signal is high, branch_trigger will be read
         branch_trigger                   : in STD_LOGIC;                         --the signal which forces the PC to change

         branch_offset_in             : in STD_LOGIC_VECTOR (11 downto 0);        --target address offset (from decoder)
         current_pc                   : in std_logic_vector (8 downto 0);         --the current count of the PC (required for RCALL and RET)
         branch_offset_out            : out STD_LOGIC_VECTOR (11 downto 0);       --the address offset going into the PC
         branch_offset_saved          : out std_logic;

         pc_override_now              : out STD_LOGIC;                             --tell the pc to do the branch now
         current_pc_byte              : out std_logic_vector(7 downto 0);
         rcall_write_cond_ready       : out std_logic;
         stack_write                  : out std_logic
        );
end branch_control;

architecture Behavioral of branch_control is
    signal branch_offset                : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
    signal offset_saved                 : std_logic := '0';
    signal local_reset                  : std_logic := '0';
    signal curr_pc                      : std_logic_vector(8 downto 0);
    signal ff_h_byte                    : std_logic := '0';
    signal ff_is_stack                  : std_logic := '0';
    signal ff_h_finished                : std_logic := '0';
    signal ff_writing_finished          : std_logic := '0';
begin

    process(clk) is
    begin

        if(rising_edge(clk)) then
        
            current_pc_byte <= (others => '0');

            if(reset = '1' OR local_reset = '1') then
                branch_offset <= (others => '0');
                offset_saved <= '0';
                local_reset <= '0';
                curr_pc <= (others => '0');
                ff_h_byte <= '0';
                rcall_write_cond_ready <= '0';
                ff_is_stack <= '0';
                ff_writing_finished <= '0';
                ff_h_finished <= '0';
            end if;

            --if any branch instruction was decoded, hold the PC anyway and save the incoming branch_offset
            if(enable_bc = '1') then
                branch_offset <= branch_offset_in;
                offset_saved <= '1';
                curr_pc <= current_pc;      --save the PC
                ff_is_stack <= rcall_write;
            end if;

-------------RCALL, RJMP, BRBS, BRBC----------------------------------
            if((offset_saved AND ff_is_stack) = '1') then
            
                --1st step
                ff_h_byte <= '1';           --indicate, that the next tick, we should write the High byte of the PC
                current_pc_byte <= curr_pc(7 downto 0);      --output the low byte of the current
                rcall_write_cond_ready <= '1';
                
                --2nd step (one clk later)
                --here, we write the high byte, and send a condition ready signal
                if(ff_h_byte = '1') then
                    rcall_write_cond_ready <= '0';
                    current_pc_byte <= "0000000"&curr_pc(7);        --write the high byte
                    ff_h_finished <= '1';
                end if;
                
                if(ff_h_finished = '1') then
                    ff_writing_finished <= '1';
                end if;
                
            end if;
------------------------------------------------------------------------

            if(((offset_saved AND branch_cond_ready) )= '1') then
                local_reset <= '1';
            end if;

        end if;
    end process;

    branch_offset_out <= branch_offset;

    --trigger when the offset value has been stablized (branch_offset_saved) AND when the trigger signal is stable (branch_cond_ready) AND then based on the trigger signal itself (branch_trigger)
    pc_override_now         <= offset_saved AND branch_cond_ready AND (branch_trigger);
    branch_offset_saved     <= offset_saved;
    
    --activate control signals to enable writing to the DM, since the Decoder has been put to sleep temporary
    stack_write             <= (offset_saved AND ff_h_byte AND NOT ff_writing_finished);

end Behavioral;
