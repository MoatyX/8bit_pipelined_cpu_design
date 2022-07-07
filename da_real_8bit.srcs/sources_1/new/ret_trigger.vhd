----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/06/2022 07:00:04 PM
-- Design Name: 
-- Module Name: ret_trigger - Behavioral
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

entity ret_trigger is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           byte_in : in STD_LOGIC_VECTOR (7 downto 0);
           cond_ready : out STD_LOGIC;
           branch_trigger : out STD_LOGIC;
           pc_target_addr   : out std_logic_vector(8 downto 0)
           );
end ret_trigger;

architecture Behavioral of ret_trigger is
signal ff_low_byte          : std_logic;
signal high_bit             : std_logic;
signal low_byte             : std_logic_vector(7 downto 0);
signal cond_rdy             : std_logic;
signal local_reset          : std_logic;
begin

process(clk)
begin

if(rising_edge(clk)) then
    
    if((reset OR local_reset) = '1') then
        ff_low_byte     <= '0';
        high_bit        <= '0';
        low_byte        <= (others => '0');
        cond_rdy        <= '0';
    end if;
    
    
    if(enable = '1') then
    
        --1st step, we recieve the high byte automatically with the enable signal
        high_bit <= byte_in(0);
        ff_low_byte <= '1';
    
    end if;
    
    --2nd step: we recieve the low byte and ask the branch_control to trigger a jmp
    if(ff_low_byte = '1') then
        low_byte <= byte_in;
        cond_rdy <= '1';
    end if;
    
    if(cond_rdy <= '1') then
        local_reset <= '1';
    end if;
    
end if;

end process;

cond_ready <= cond_rdy;
branch_trigger <= cond_rdy;
pc_target_addr <= high_bit & low_byte;

end Behavioral;
