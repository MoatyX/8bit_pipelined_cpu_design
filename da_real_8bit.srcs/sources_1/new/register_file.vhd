library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity register_file is
    Port ( 
            clk: in STD_LOGIC;
            addr_opa : in STD_LOGIC_VECTOR (4 downto 0);
            addr_opb : in STD_LOGIC_VECTOR (4 downto 0);
            write_addr: in std_logic_vector (4 downto 0);
            w_e_regfile : in STD_LOGIC;
            data_opa : out STD_LOGIC_VECTOR (7 downto 0);
            data_opb : out STD_LOGIC_VECTOR (7 downto 0);
            data_in : in STD_LOGIC_VECTOR (7 downto 0)
          );
end register_file;

architecture Behavioral of register_file is
  type regs is array(31 downto 0) of std_logic_vector(7 downto 0); 
--  signal register_speicher:regs := (others=>(others=>'0'));
  signal register_speicher:regs;
begin

  -- purpose: einfacher Schreibprozess für rudimentaeres Registerfile
  -- type   : sequential
  -- inputs : clk, addr_opa, w_e_regfile, data_res
  -- outputs: register_speicher
  registerfile: process (clk)
  begin  -- process registerfile
    if clk'event and clk = '1' then  -- rising clock edge
      if w_e_regfile = '1' then
        register_speicher(to_integer(unsigned(write_addr))) <= data_in;
      end if;
    end if;
  end process registerfile;

  -- nebenlaeufiges Lesen der Registerspeicher
  data_opa <= register_speicher(to_integer(unsigned(addr_opa)));
  data_opb <= register_speicher(to_integer(unsigned(addr_opb)));
  
end Behavioral;