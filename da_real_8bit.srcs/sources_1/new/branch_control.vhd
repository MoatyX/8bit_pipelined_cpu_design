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
           is_stack_depended                : in std_logic;                         --set to high, when writing/reading the address on the stack is neccessary (RCALL and RET)
           branch_cond_ready                : in std_logic;                         --when this signal is high, branch_trigger will be read
           branch_trigger                   : in STD_LOGIC;                         --the signal which forces the PC to change
           
           branch_offset_in             : in STD_LOGIC_VECTOR (11 downto 0);        --target address offset (from decoder)
           branch_offset_out            : out STD_LOGIC_VECTOR (11 downto 0);       --the address offset going into the PC
           branch_offset_saved          : out std_logic;
           
           pc_override_now              : out STD_LOGIC;                             --tell the pc to do the branch now
           mux_nop                      : out std_logic
           );
end branch_control;

architecture Behavioral of branch_control is
    signal branch_offset                : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
    signal offset_saved                 : std_logic := '0';
    signal local_reset                  : std_logic := '0';
begin

process(clk) is
begin
       
    if(rising_edge(clk)) then
    
        if(reset = '1' OR local_reset = '1') then
            branch_offset <= (others => '0');
            offset_saved <= '0';
            local_reset <= '0';
            mux_nop <= '0';
        end if;
        
        --if any branch instruction was decoded, hold the PC anyway and save the incoming branch_offset
        if(enable_bc = '1') then
            branch_offset <= branch_offset_in;
            offset_saved <= '1';
            mux_nop <= '1';
        end if;
        
        if((offset_saved AND branch_cond_ready) = '1') then
            local_reset <= '1';
        end if;
        
    end if;
end process;

branch_offset_out <= branch_offset;

--trigger when the offset value has been stablized (branch_offset_saved) AND when the trigger signal is stable (branch_cond_ready) AND then based on the trigger signal itself (branch_trigger)
pc_override_now     <= offset_saved AND branch_cond_ready AND (branch_trigger);
branch_offset_saved <= offset_saved;

end Behavioral;
