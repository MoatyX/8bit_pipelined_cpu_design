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

begin

    status_write: process(clk) is
    begin
        if (rising_edge(clk)) then
            if(override='1') then
                for i in 7 downto 0 loop
                    if(w_e_sreg(i) = '1') then
                        curr_status_out(i) <= override_val(i);
                    end if;
                end loop;
            else
                for i in 7 downto 0 loop
                    if(w_e_sreg(i) = '1') then
                        curr_status_out(i) <= new_status_in(i);
                    end if;
                end loop;
            end if;
        end if;
    end process;

end Behavioral;