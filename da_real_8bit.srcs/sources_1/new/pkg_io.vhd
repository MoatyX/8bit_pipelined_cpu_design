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

constant pinc_addr          : integer := 16#33#;
constant pinb_addr          : integer := 16#36#;
constant pind_addr          : integer := 16#30#;

constant portc_addr         : integer := 16#35#;        --LED[15:8]
constant portb_addr         : integer := 16#38#;        --LED[7:0]

constant ser_addr           : integer := 16#40#;
constant seg0_n_addr        : integer := 16#41#;
constant seg1_n_addr        : integer := 16#42#;
constant seg2_n_addr        : integer := 16#43#;
constant seg3_n_addr        : integer := 16#44#;

end package;