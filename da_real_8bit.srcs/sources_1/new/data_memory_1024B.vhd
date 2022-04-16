----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2022 02:01:15 AM
-- Design Name: 
-- Module Name: data_memory_1024B - Behavioral
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

entity data_memory_1024B is
    Port ( clk : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           z_addr : in STD_LOGIC_VECTOR (9 downto 0);
           z_data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data : out STD_LOGIC_VECTOR (7 downto 0));
end data_memory_1024B;

architecture Behavioral of data_memory_1024B is

  type regs is array(1023 downto 0) of std_logic_vector(7 downto 0); 
  signal data_mem: regs;

begin

data_write: process(clk)
begin
    if(rising_edge(clk)) then
        if write_enable = '1' then
                data_mem(to_integer(unsigned(z_addr))) <= z_data_in;
        end if;
    end if;
end process;

data <= data_mem(to_integer(unsigned(z_addr)));
end Behavioral;
