----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2022 02:50:06 PM
-- Design Name: 
-- Module Name: top_testbench - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity toplevel_tb is

end toplevel_tb;

-------------------------------------------------------------------------------

architecture behaviour of toplevel_tb is

  component toplevel
    port (
        clk              : in  STD_LOGIC;
        led                 : out std_logic_vector(15 downto 0) := (others => '1');
        sw                  : in std_logic_vector(15 downto 0);
        seg                 : out std_logic_vector(6 downto 0) := (others => '1');
        btnU                : in STD_LOGIC;
        btnD                : in STD_LOGIC;
        btnC                : in STD_LOGIC;
        btnL                : in STD_LOGIC;
        btnR                : in STD_LOGIC
      );
  end component;

  -- component ports
  signal reset          : STD_LOGIC;
  signal clk            : STD_LOGIC:='0';

  signal port_out_B      : STD_LOGIC_VECTOR (7 downto 0);
  signal port_out_C      : STD_LOGIC_VECTOR (7 downto 0);
  signal sw              : std_logic_vector(15 downto 0) := "0000000101000101";
  signal dbg_op_code     : std_logic_vector(7 downto 0);
  signal btnU    :  STD_LOGIC;
  signal btnD    :  STD_LOGIC;
  signal btnC    :  STD_LOGIC;
  signal btnL    :  STD_LOGIC;
  signal btnR    :  STD_LOGIC;
  
begin  -- behaviour

  -- component instantiation
  DUT: toplevel
    port map (
      btnC              => reset,
      clk               => clk,
      led               => open,
      sw                => sw,
      seg               => open,
      btnU              => reset,
      btnD              => reset,
      btnL              => btnL,
      btnR              => btnR
      );

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    reset <= '1';
    wait for 20ns;
    wait for 101ns;
    reset <= '0';
    wait;

  end process WaveGen_Proc;

  

end behaviour;

-------------------------------------------------------------------------------

configuration toplevel_tb_behaviour_cfg of toplevel_tb is
  for behaviour
  end for;
end toplevel_tb_behaviour_cfg;
