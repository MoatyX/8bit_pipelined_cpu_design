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

begin


end Behavioral;
