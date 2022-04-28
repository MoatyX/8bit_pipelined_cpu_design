----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2022 09:29:30 PM
-- Design Name: 
-- Module Name: z_addr - Behavioral
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

entity z_addr is
    Port ( clk                  : in STD_LOGIC;
         reset                  : in STD_LOGIC;
         addr_a                 : in std_logic_vector(4 downto 0);
         rf_write_enable_status : in std_logic;
         data_in                : in STD_LOGIC_VECTOR (7 downto 0);
         z_addr_out             : out STD_LOGIC_VECTOR (9 downto 0));
end z_addr;

architecture Behavioral of z_addr is
    signal r31 : std_logic_vector(1 downto 0) := (others=>'0');
    signal r30 : std_logic_vector(7 downto 0) := (others=>'0');

    signal rf_addr_r30            : STD_LOGIC;
    signal rf_addr_r31            : STD_LOGIC;
begin
    rf_addr_r30   <= addr_a(4) AND addr_a(3) AND addr_a(2) AND addr_a(1) AND NOT addr_a(0) AND rf_write_enable_status;
    rf_addr_r31   <= addr_a(4) AND addr_a(3) AND addr_a(2) AND addr_a(1) AND addr_a(0) AND rf_write_enable_status;
    main: process(clk)
    begin

        if(rising_edge(clk)) then

            if(reset ='0') then
                --R31
                if(rf_addr_r31 = '1') then
                    r31 <= data_in(1 downto 0);
                end if;

                --R30
                if(rf_addr_r30 = '1') then
                    r30 <= data_in;
                end if;
            else
                r30 <= (others => '0');
                r31 <= (others => '0');
            end if;


        end if;

    end process;

    z_addr_out <= r31 & r30;
end Behavioral;
