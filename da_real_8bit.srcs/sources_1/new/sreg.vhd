library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sreg is
    Port ( clk              : in STD_LOGIC;
            reset           : in std_logic;
         w_e_sreg           : in std_logic_vector (7 downto 0);
         new_status_in      : in STD_LOGIC_VECTOR (7 downto 0);
         curr_status_out    : out STD_LOGIC_VECTOR (7 downto 0) := (others => '0');   --init everything to 0
         override           : in std_logic;
         override_val       : in std_logic_vector (7 downto 0)
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
    
        if(w_e_sreg(7)='1') then
            if(override = '1') then
                interrupt <= override_val(7);
            else
                interrupt <= new_status_in(7);
            end if;
        end if;
        
        if(w_e_sreg(6)='1') then
            if(override = '1') then
                bit_copy_storage <= override_val(6);
            else
                bit_copy_storage <= new_status_in(6);
            end if;
        end if;
        
        if(w_e_sreg(5)='1') then
            if(override = '1') then
                half_carry <= override_val(5);
            else
                half_carry <= new_status_in(5);
            end if;
        end if;
        
        if(w_e_sreg(4)='1') then
            if(override = '1') then
                sign_bit <= override_val(4);
            else
                sign_bit <= new_status_in(4);
            end if;
        end if;
        
        if(w_e_sreg(3)='1') then
            if(override = '1') then
                overflow <= override_val(3);
            else
                overflow <= new_status_in(3);
            end if;
        end if;
        
        if(w_e_sreg(2)='1') then
            if(override = '1') then
                negative <= override_val(2);
            else
                negative <= new_status_in(2);
            end if;
        end if;
        
        if(w_e_sreg(1)='1') then
            if(override = '1') then
                zero <= override_val(1);
            else
                zero <= new_status_in(1);
            end if;
        end if;
        
        if(w_e_sreg(0)='1') then
            if(override = '1') then
                carry <= override_val(0);
            else
                carry <= new_status_in(0);
            end if;
        end if;
        
    end if;
end process;

curr_status_out <= interrupt & bit_copy_storage & half_carry & sign_bit & overflow & negative & zero & carry;

end Behavioral;