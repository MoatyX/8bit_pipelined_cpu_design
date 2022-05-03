library ieee;
use ieee.std_logic_1164.all;
-- ---------------------------------------------------------------------------------
-- Memory initialisation package
-- ---------------------------------------------------------------------------------
package pkg_instrmem is

	type t_instrMem   is array(0 to 512-1) of std_logic_vector(15 downto 0);
	constant PROGMEM : t_instrMem := (
		"0000000000000000",
		"1110000011110010",
		"1110000011100011",
		"0000111111111110",
		"0000000000000000",
		
		others => (others => '0')
	);

end package pkg_instrmem;
