library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Define Addresses of Registers mapped to IO
package pkg_io is

constant pinc_addr          : integer := 51;
constant pinb_addr          : integer := 54;
constant pind_addr          : integer := 48;

constant portc_addr         : integer := 53;        --LED[15:8]
constant portb_addr         : integer := 56;        --LED[7:0]

constant ser_addr           : integer := 64;
constant seg0_n_addr        : integer := 65;
constant seg1_n_addr        : integer := 66;
constant seg2_n_addr        : integer := 67;
constant seg3_n_addr        : integer := 68;

end package;