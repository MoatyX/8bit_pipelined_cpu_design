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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch_control is
    Port ( clk                          : in STD_LOGIC;
           reset                        : in STD_LOGIC;
           enable                       : in STD_LOGIC;
           sreg_condition_resolved      : in STD_LOGIC;
           sreg_target_condition        : in STD_LOGIC;
           sreg_condition_result        : in STD_LOGIC;
           sreg_branch_test             : in std_logic;
           rcall_status                 : in STD_LOGIC;
           ret_status                   : in STD_LOGIC;
           force_override               : in STD_LOGIC;
           branch_offset_in             : in STD_LOGIC_VECTOR (11 downto 0);
           branch_offset_out            : out STD_LOGIC_VECTOR (11 downto 0);
           insert_nop                   : out STD_LOGIC;
           pc_override_now              : out STD_LOGIC
           );
end branch_control;

architecture Behavioral of branch_control is
    signal branch_offset             : STD_LOGIC_VECTOR (11 downto 0);
    signal override_now              : std_logic := '0';
begin

process(clk) is
begin
       
    if(rising_edge(clk)) then
        insert_nop          <= '0';
        
        if(enable = '1') then
            branch_offset <= branch_offset_in;
        end if;
        
        if(override_now = '1') then
            override_now <= '0';
        end if;
        
        if(force_override = '1' AND override_now = '0') then
           override_now <= '1';
        end if;
        
        --if the sreg_branch_condition test resolves, compare the condition and branch if successful
        if(sreg_condition_resolved = '1') then
            if(sreg_condition_result = sreg_target_condition) then
                override_now <= '1';
                
            end if;
        end if;
        
    end if;
end process;

branch_offset_out <= branch_offset;
pc_override_now <= override_now;

end Behavioral;
