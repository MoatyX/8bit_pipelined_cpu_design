library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sreg is
    Port ( clk              : in STD_LOGIC;
            reset           : in std_logic;
         w_e_sreg           : in std_logic_vector (7 downto 0);
         new_status_in      : in STD_LOGIC_VECTOR (7 downto 0);
         curr_status_out    : out STD_LOGIC_VECTOR (7 downto 0)
        );
end sreg;

architecture Behavioral of sreg is

signal interrupt        : std_logic := '0';     -- I-flag
signal bit_copy_storage : std_logic := '0';     -- T-flag
signal half_carry       : std_logic := '0';     -- H-flag
signal sign_bit         : std_logic := '0';     -- S-flag
signal overflow         : std_logic := '0';     -- V-flag
signal negative         : std_logic := '0';     -- N-flag
signal zero             : std_logic := '0';     -- Z-flag
signal carry            : std_logic := '0';     -- C-flag

begin

status_write: process(clk) is
begin
    if(rising_edge(clk)) then
        if(reset = '1') then
            interrupt           <= '0';
            bit_copy_storage    <= '0';
            half_carry          <= '0';
            sign_bit            <= '0';
            overflow            <= '0';
            negative            <= '0';
            zero                <= '0';
            carry               <= '0';
        else
            if(w_e_sreg(7)='1') then
                interrupt <= new_status_in(7);
            end if;
            
            if(w_e_sreg(6)='1') then
                bit_copy_storage <= new_status_in(6);
            end if;
            
            if(w_e_sreg(5)='1') then
                half_carry <= new_status_in(5);
            end if;
            
            if(w_e_sreg(4)='1') then
                sign_bit <= new_status_in(4);
            end if;
            
            if(w_e_sreg(3)='1') then
                overflow <= new_status_in(3);
            end if;
            
            if(w_e_sreg(2)='1') then
                negative <= new_status_in(2);
            end if;
            
            if(w_e_sreg(1)='1') then
                zero <= new_status_in(1);
            end if;
            
            if(w_e_sreg(0)='1') then
                carry <= new_status_in(0);
            end if;
        end if;
        
    end if;
end process;

curr_status_out <= interrupt & bit_copy_storage & half_carry & sign_bit & overflow & negative & zero & carry;

end Behavioral;