library ieee;
use ieee.std_logic_1164.all;
-- ---------------------------------------------------------------------------------
-- Memory initialisation package
-- ---------------------------------------------------------------------------------
package pkg_instrmem is

	type t_instrMem   is array(0 to 512-1) of std_logic_vector(15 downto 0);
	constant PROGMEM : t_instrMem := (
		"0000000000000000",
		"1110000000000101",
		"1110000011110011",
		"1110111111101111",
		"1000001100000000",
		"0000000000000000",
		"1110000000000000",
		"1000000100000000",
		"0000000000000000",
		"0000000000000000",
		
		others => (others => '0')
	);

end package pkg_instrmem;
