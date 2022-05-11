----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2022 02:22:31 PM
-- Design Name: 
-- Module Name: rcall_ret_controller - Behavioral
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

entity rcall_ret_controller is
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
end rcall_ret_controller;

architecture Behavioral of rcall_ret_controller is
    signal writing          : std_logic;
    signal incoming_offset  : std_logic_vector(11 downto 0);
    signal rcall_finish     : std_logic;
begin

write_offset: process(clk)
begin
    if(falling_edge(clk)) then
        if(reset = '1') then
            incoming_offset <= (others => '0');
        end if;
        
        if(enable = '1') then
            incoming_offset <= target_offset;
        end if;
        
    end if;
end process;

process(clk) is
begin
    if(rising_edge(clk)) then
        sp_op <= '0';
        sp_use <= '0';
        dataMem_we <= '0';
        
        if(reset = '1') then
            writing <= '0';
            rcall_finish <= '0';
        end if;
    
        if((rcall_write = '1' OR writing = '1') AND rcall_finish = '0') then
            sp_op <= '1';
            sp_use <= '1';
            dataMem_we <= '1';
            
            if(writing = '0') then
                writing <= '1';
                --send the first byte
                offset_byte <= incoming_offset(7 downto 0);
            else
                --we reach this area when we already have sent the first byte (Low byte)
                offset_byte <= "0000" & incoming_offset(11 downto 8);
                rcall_finish <= '1';
            end if;
            
            
        end if;
    end if;
    

end process;

rcall_write_finish <= rcall_finish;
target_offset_out <= incoming_offset;

end Behavioral;
