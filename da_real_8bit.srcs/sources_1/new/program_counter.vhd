----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/23/2015 08:30:37 PM
-- Design Name: 
-- Module Name: Program_Counter - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
  port (
    reset               : in  std_logic;
    clk                 : in  std_logic;
    addr                : out std_logic_vector (8 downto 0);
    override_enable     : in std_logic;
    offset              : in std_logic_vector (11 downto 0)
    );
end program_counter;

architecture Behavioral of program_counter is
  signal PC_reg : std_logic_vector(8 downto 0) := (others => '0');
begin
  count : process (clk)
  begin  -- process count
    if clk'event and clk = '1' then     -- rising clock edge
      if reset = '1' then               -- synchronous reset (active high)
        PC_reg <= (others => '0');
      else
        if (override_enable='1') then
--            PC_reg <= std_logic_vector(signed(PC_reg) + signed(offset(8 downto 0)) - 1);
        else
            PC_reg <= std_logic_vector(unsigned(PC_reg) + 1);
        end if;
      end if;
    end if;
  end process count;

 addr <= PC_reg;

end Behavioral;
