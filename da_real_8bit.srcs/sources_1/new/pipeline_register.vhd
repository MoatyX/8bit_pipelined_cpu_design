----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2022 01:17:33 PM
-- Design Name: 
-- Module Name: pipeline_register - Behavioral
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


--this is a generic D-Flip-Flop that is meant to be used in pipelining
entity pipeline_register is
    generic (reg_width: integer);
    Port (  clk : in STD_LOGIC;
            reset: in std_logic;
            data_in: in std_logic_vector(reg_width-1 downto 0);
            data_out: out std_logic_vector(reg_width-1 downto 0) := (others =>'0')
            );
end pipeline_register;

architecture Behavioral of pipeline_register is

begin

process (clk)
begin
   if clk'event and clk='1' then
      if reset='1' then
         data_out <= (others => '0');
      else
         data_out <= data_in;
      end if;
   end if;
end process;


end Behavioral;
