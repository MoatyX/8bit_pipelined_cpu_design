library ieee;
use ieee.std_logic_1164.all;

package pkg_processor is

-- ALU op_code_in
    constant op_add : std_logic_vector(3 downto 0) := "0000";  -- Addition (opA = opA + opB)
    constant op_nop : std_logic_vector(3 downto 0) := "0000";  --NoOperation. wird als add implementiert. ergebnis wird nicht gespeichert
    constant op_sub : std_logic_vector(3 downto 0) := "0001";  -- Subtraction
    constant op_or : std_logic_vector(3 downto 0) := "0010";  -- bitwise OR

    --my own op code defines
    constant op_adc     : std_logic_vector(3 downto 0) := "0011";               --ADC, ROL
    constant op_and     : std_logic_vector(3 downto 0) := "0100";               --bitwise and
    constant op_eor     : std_logic_vector(3 downto 0) := "0101";               --bitwise xor
    constant op_mov     : std_logic_vector(3 downto 0) := "0110";               --copy registerA to registerB
    constant op_brbs    : std_logic_vector(3 downto 0) := "0111";               --Branch when bit set
    constant op_brbc    : std_logic_vector(3 downto 0) := "1000";               --Branch when bit clear
    constant op_asr     : std_logic_vector(3 downto 0) := "1001";               --arithmatic shift right
    constant op_com     : std_logic_vector(3 downto 0) := "1010";               --one complement
    constant op_lsr     : std_logic_vector(3 downto 0) := "1011";               --logical shift right
    constant op_sec     : std_logic_vector(3 downto 0) := "1100";               --Set Carry flag
    constant op_clc     : std_logic_vector(3 downto 0) := "1101";               --Clear Carry flag 
  
  
  --------------------------------------------------------------------------------
  
  -- All Op Codes (does not go in the ALU)
    constant op_ldi     : std_logic_vector(7 downto 0) := "0001" & "0000";      -- Load signal
    constant op_st      : std_logic_vector(7 downto 0) := "0010" & "0000";      -- store
    constant op_ld      : std_logic_vector(7 downto 0) := "0011" & "0000";      -- load
    constant op_sec_dbg     : std_logic_vector(7 downto 0) := "0100" & "0000";      -- Set Carry bit
    constant op_clc_dbg     : std_logic_vector(7 downto 0) := "0101" & "0000";      -- Clear Carry bit
    constant op_rjmp    : std_logic_vector(7 downto 0) := "0110" & "0000";      -- relative jump 
    constant op_push    : std_logic_vector(7 downto 0) := "0111" & "0000";      -- push register on stack
    constant op_pop     : std_logic_vector(7 downto 0) := "1000" & "0000";      -- pop a value from stack to register file
    constant op_ret     : std_logic_vector(7 downto 0) := "1001" & "0000";      -- return from subroutine
    constant op_rcall   : std_logic_vector(7 downto 0) := "1010" & "0000";      -- relative call of subroutine

end pkg_processor;
