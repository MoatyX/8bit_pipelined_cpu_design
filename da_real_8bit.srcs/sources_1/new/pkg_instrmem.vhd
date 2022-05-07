library ieee;
use ieee.std_logic_1164.all;
-- ---------------------------------------------------------------------------------
-- Memory initialisation package
-- ---------------------------------------------------------------------------------
package pkg_instrmem is

	type t_instrMem   is array(0 to 512-1) of std_logic_vector(15 downto 0);
	constant PROGMEM : t_instrMem := (
		"1110000000000011",
		"1011111100001110",
		"1110111100001111",
		"1011111100001101",
		"0000000000000000",
		"1110000000000001",
		"1110111111111111",
		"1110111100001110",
		"1001010100000011",
		"1001010100000011",
		"1110011100001111",
		"1001010100000011",
		"1110000000000001",
		"1001010100001010",
		"1001010100001010",
		"1110100000000000",
		"1001010100001010",
		"1110000000000001",
		"1110000000010001",
		"0000111100000001",
		"1110111100001111",
		"1110000000010001",
		"0000111100000001",
		"1110000000001000",
		"1110000000011000",
		"0000111100010000",
		"1110011100001111",
		"1110000000010001",
		"0000111100000001",
		"1110010000000000",
		"0000111100000000",
		"0000111100000000",
		"1110000000000000",
		"1110000000010000",
		"1001010010001000",
		"0001111100000001",
		"1001010000001000",
		"0001111100000001",
		"1110000000001110",
		"1110000000010001",
		"1001010000001000",
		"0001111100000001",
		"1110111100001110",
		"1110000000010001",
		"1001010000001000",
		"0001111100000001",
		"1110011100001110",
		"1110000000010001",
		"1001010000001000",
		"0001111100000001",
		"1110010000000000",
		"0001111100000000",
		"0001111100000000",
		"1110000000000001",
		"1110000000010001",
		"0001101100000001",
		"1110000100000000",
		"1110000000010001",
		"0001101100000001",
		"1110100000000000",
		"1110000000010001",
		"0001101100000001",
		"1110000000000001",
		"1110000000010010",
		"0001101100000001",
		"1110000000000001",
		"0101000000000001",
		"1110000100000000",
		"0101000000000001",
		"1110011100001110",
		"0101000000000001",
		"1110000000000001",
		"0101000000000010",
		"1110000000000001",
		"1110000000010001",
		"0001011100000001",
		"1110000100000000",
		"1110000000010001",
		"0001011100000001",
		"1110100000000000",
		"1110000000010001",
		"0001011100000001",
		"1110000000000001",
		"1110000000010010",
		"0001011100000001",
		"1110000000000001",
		"0011000000000001",
		"1110000100000000",
		"0011000000000001",
		"1110011100001110",
		"0011000000000001",
		"1110000000000001",
		"0011000000000010",
		"1100000000000011",
		"0000000000000000",
		"0000000000000000",
		"1100000000000010",
		"0000000000000000",
		"1100111111111100",
		"0000000000000000",
		"1001010000001000",
		"1001010010001000",
		"1001010000001000",
		"1111000000100000",
		"0000000000000000",
		"1001010010001000",
		"1111000000001000",
		"1100000000000010",
		"1001010000001000",
		"1111001111011000",
		"0000000000000000",
		"1001010010001000",
		"1111010000100000",
		"0000000000000000",
		"1001010000001000",
		"1111010000001000",
		"1100000000000010",
		"1001010010001000",
		"1111011111011000",
		"0000000000000000",
		"1110001100000111",
		"0010111000010000",
		"0010110000100001",
		"0010110100100010",
		"0010111100010000",
		"1110101000001010",
		"1001010100000000",
		"1001010100000000",
		"1110101000001010",
		"1110111100011111",
		"1110010100100101",
		"0010011100000001",
		"0010011100000010",
		"1110101000001010",
		"1110101000011010",
		"1110010100100101",
		"0010001100000001",
		"0010001100000010",
		"1110101000001010",
		"0111101000001010",
		"0111010100000101",
		"1110101000001010",
		"1110010100010101",
		"1110000000100000",
		"0010101100000001",
		"0010101100000010",
		"1110101000001010",
		"0110010100000101",
		"0110000000000000",
		"1110000000000010",
		"1001010100000110",
		"1001010100000110",
		"1001010100000110",
		"1110010000000010",
		"1001010100000101",
		"1001010100000101",
		"1110100000000010",
		"1001010100000101",
		"1001010100000101",
		"1110011100001011",
		"0010111000000000",
		"1001001000001111",
		"1001000101001111",
		"1110000100000111",
		"1001001100001111",
		"1001000010101111",
		"1100000000000100",
		"1001001100001111",
		"1110000100000010",
		"1001000100001111",
		"1001010100001000",
		"1101000000000011",
		"1110101000001010",
		"1101111111111001",
		"1100000000000100",
		"1001001100001111",
		"1110010100000101",
		"1001000100001111",
		"1001010100001000",
		"1110011100000011",
		"1110101000001010",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000000000000",
		"1100000000000001",
		"1100000000100001",
		"1110000011110000",
		"1110000000100011",
		"1110000000001010",
		"1110000000010000",
		"0000111100010000",
		"0000111100010001",
		"0000111100010001",
		"0000111100000001",
		"0000111100000010",
		"0010111100010000",
		"0000111100010010",
		"0010111111100000",
		"1000001100010000",
		"1000000111100000",
		"1000001100000000",
		"1000000111100000",
		"1000001100100000",
		"1000000000010000",
		"0001011000010010",
		"1111010001101001",
		"1110000000000001",
		"1110000000011011",
		"0010111111110000",
		"0010111111100001",
		"1000001100100000",
		"1000000111110000",
		"1000001100000000",
		"1000000111100000",
		"1000001100100000",
		"1000000000100000",
		"0001011000100010",
		"1111010000001001",
		"1100000000010101",
		"1110000011110000",
		"1110001100001000",
		"1001010100000000",
		"1110010011100001",
		"1000001100000000",
		"1110000000000110",
		"1001010100000000",
		"1110010011100010",
		"1000001100000000",
		"1110011100000111",
		"1001010100000000",
		"1110010011100011",
		"1000001100000000",
		"1110011100000001",
		"1001010100000000",
		"1110010011100100",
		"1000001100000000",
		"1110010011100000",
		"1110000000001111",
		"1000001100000000",
		"1100000000010100",
		"1110000011110000",
		"1110011000001101",
		"1001010100000000",
		"1110010011100001",
		"1000001100000000",
		"1110011000001101",
		"1001010100000000",
		"1110010011100010",
		"1000001100000000",
		"1110011100000111",
		"1001010100000000",
		"1110010011100011",
		"1000001100000000",
		"1110011100000011",
		"1001010100000000",
		"1110010011100100",
		"1000001100000000",
		"1110010011100000",
		"1110000000001111",
		"1000001100000000",
		"1110001111100000",
		"1110000011110000",
		"1000000100000000",
		"0111000000000010",
		"1111010001010001",
		"1110001111100011",
		"1110000011110000",
		"1000000100000000",
		"0111000000000001",
		"1111010001010001",
		"1110001111100110",
		"1110000011110000",
		"1000000100000000",
		"0111000000000001",
		"1111010001010001",
		"1110000000010010",
		"1110001111100101",
		"1110000011110000",
		"1000001100010000",
		"1100000000001001",
		"1110000000010100",
		"1110001111100101",
		"1110000011110000",
		"1000001100010000",
		"1100000000000100",
		"1110111100011111",
		"1110001111101000",
		"1110000011110000",
		"1000001100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000011100000",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110010100000101",
		"1110111111101111",
		"1110000011110001",
		"1000001100000000",
		"1000000100010000",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1110000000000001",
		"1110000000010010",
		"1110000000100011",
		"1110000000110001",
		"1001001100001111",
		"1001001100011111",
		"1001001100101111",
		"1001000100001111",
		"1001000100011111",
		"1001000100101111",
		"1100111100101000",
		
		others => (others => '0')
	);

end package pkg_instrmem;
