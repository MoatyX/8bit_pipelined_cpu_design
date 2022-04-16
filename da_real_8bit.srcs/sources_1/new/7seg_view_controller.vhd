----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2022 01:21:33 PM
-- Design Name: 
-- Module Name: 7seg_view_controller - Behavioral
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

entity seg_view_controller is
    Port (  clk     : in STD_LOGIC;
            reset   : in std_logic;
            
            ser      : in std_logic_vector(7 downto 0);
            seg0     : in std_logic_vector(7 downto 0);
            seg1     : in std_logic_vector(7 downto 0);
            seg2     : in std_logic_vector(7 downto 0);
            seg3     : in std_logic_vector(7 downto 0);
            
            seg     : out STD_LOGIC_VECTOR (6 downto 0);
            an      : out STD_LOGIC_VECTOR (3 downto 0);
            db      : out STD_LOGIC);
end seg_view_controller;

architecture Behavioral of seg_view_controller is

   --Use descriptive names for the states, like st1_reset, st2_search
   type state_type is (st0_seg0, st1_seg1, st2_seg2, st3_seg3);
   signal state, next_state : state_type;
   signal trig: std_logic := '0';
begin

   SYNC_PROC: process (clk)
   variable count : integer := 0;
   begin
        trig <= '0';
      if (clk'event and clk = '1') then
         count := count + 1;
         if(count = 277000) then
            trig <= '1';
         end if;
         if (reset = '1') then
            state <= st0_seg0;
         else
            if(trig ='1') then
                state <= next_state;
                trig <= '0';
                count := 0;
            end if;
         end if;
      end if;
   end process;

   --MEALY State-Machine - Outputs based on state and inputs
   OUTPUT_DECODE: process (state, seg0, seg1, seg2, seg3, ser)
   begin
      case state is
        when st0_seg0 => 
            db <= '1';
            seg <= seg0(6 downto 0);
            an <= "1110" or not ser(3 downto 0);
        when st1_seg1 =>
            db <= seg1(7);
            seg <= seg1(6 downto 0);
            an <= "1101" or not ser(3 downto 0);
        when st2_seg2 =>
            db <= '0';
            seg <= seg2(6 downto 0);
            an <= "1011" or not ser(3 downto 0);
        when st3_seg3 =>
            db <= '0';
            seg <= seg3(6 downto 0);
            an <= "0111" or not ser(3 downto 0);
        when others => null;
      end case;
   end process;

   NEXT_STATE_DECODE: process (state)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      case (state) is
        when st0_seg0 => next_state <= st1_seg1;
        when st1_seg1 => next_state <= st2_seg2;
        when st2_seg2 => next_state <= st3_seg3;
        when st3_seg3 => next_state <= st0_seg0;
        when others =>
            next_state <= st0_seg0;
      end case;
   end process;


end Behavioral;
