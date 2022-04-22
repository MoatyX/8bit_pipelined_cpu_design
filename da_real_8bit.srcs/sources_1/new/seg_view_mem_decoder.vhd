----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2022 01:38:10 PM
-- Design Name: 
-- Module Name: seg_view_mem_decoder - Behavioral
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

entity seg_view_mem_decoder is
    Port ( data_in : in STD_LOGIC_VECTOR (7 downto 0);
           z_addr : in STD_LOGIC_VECTOR (9 downto 0);
           ser : out STD_LOGIC_VECTOR (7 downto 0);
           seg0 : out STD_LOGIC_VECTOR (7 downto 0);
           seg1 : out STD_LOGIC_VECTOR (7 downto 0);
           seg2 : out STD_LOGIC_VECTOR (7 downto 0);
           seg3 : out STD_LOGIC_VECTOR (7 downto 0));
end seg_view_mem_decoder;

architecture Behavioral of seg_view_mem_decoder is

begin

ser     <= data_in when unsigned(z_addr) = 16#40# else (others => '0');
seg0    <= data_in when unsigned(z_addr) = 16#41# else (others => '0');
seg1    <= data_in when unsigned(z_addr) = 16#40# else (others => '0');
seg2    <= data_in when unsigned(z_addr) = 16#40# else (others => '0');
seg3    <= data_in when unsigned(z_addr) = 16#40# else (others => '0'); 

end Behavioral;
