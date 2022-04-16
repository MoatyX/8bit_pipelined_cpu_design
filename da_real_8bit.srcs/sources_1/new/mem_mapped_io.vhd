----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2022 12:46:51 PM
-- Design Name: 
-- Module Name: mem_mapped_io - Behavioral
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
use work.pkg_io.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_mapped_io is
    Port ( clk      : in STD_LOGIC;
           w_e      : in STD_LOGIC;
           data     : in std_logic_vector(7 downto 0);
           z_addr   : in STD_LOGIC_VECTOR (9 downto 0);
           portb    : out STD_LOGIC_VECTOR (7 downto 0);
           portc    : out STD_LOGIC_VECTOR (7 downto 0);
           io_addr  : out std_logic;
           ser      : out std_logic_vector(7 downto 0);
           seg0     : out std_logic_vector(7 downto 0);
           seg1     : out std_logic_vector(7 downto 0);
           seg2     : out std_logic_vector(7 downto 0);
           seg3     : out std_logic_vector(7 downto 0);
           pinb_in  : in std_logic_vector(7 downto 0);
           pinc_in  : in std_logic_vector(7 downto 0);
           pind_in  : in std_logic_vector(7 downto 0)
           );
end mem_mapped_io;

architecture Behavioral of mem_mapped_io is

signal pinb     : std_logic_vector(7 downto 0);
signal pinc     : std_logic_vector(7 downto 0);
signal pind     : std_logic_vector(7 downto 0);

begin

mux_ports: process(clk) is
begin
    if(rising_edge(clk)) then
        if(w_e='1') then
            case z_addr is
                when std_logic_vector(to_unsigned(portb_addr, 10))  => portb <= pinb;
                when std_logic_vector(to_unsigned(portc_addr, 10))  => portc <= pinc;
                when std_logic_vector(to_unsigned(ser_addr, 10))    => ser <= data;
                when std_logic_vector(to_unsigned(seg0_n_addr, 10)) => seg0 <= data;
                when std_logic_vector(to_unsigned(seg1_n_addr, 10)) => seg1 <= data;
                when std_logic_vector(to_unsigned(seg2_n_addr, 10)) => seg2 <= data;
                when std_logic_vector(to_unsigned(seg3_n_addr, 10)) => seg3 <= data;
                when others => null;
            end case;
        end if;
    end if;
end process;

save_mem: process(clk) is
begin
    if(rising_edge(clk)) then
        case z_addr is
            when std_logic_vector(to_unsigned(pinb_addr, 10)) => pinb <= pinb_in;
            when std_logic_vector(to_unsigned(pinc_addr, 10)) => pinc <= pinc_in;
            when std_logic_vector(to_unsigned(pind_addr, 10)) => pind <= pind_in;
            when others => null;
        end case;
    end if;
end process;


end Behavioral;
