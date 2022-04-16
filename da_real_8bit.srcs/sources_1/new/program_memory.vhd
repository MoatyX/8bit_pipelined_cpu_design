library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.pkg_instrmem.all;

-- following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_memory is
    Port ( addr : in STD_LOGIC_VECTOR (8 downto 0);
           instr : out STD_LOGIC_VECTOR (15 downto 0));
end program_memory;

architecture Behavioral of program_memory is

begin
  instr <= PROGMEM(to_integer(unsigned(addr)));

end Behavioral;