library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
library work;
use work.pkg_processor.all;


entity ALU is
    Port ( OPCODE : in STD_LOGIC_VECTOR (3 downto 0);
           OPA : in STD_LOGIC_VECTOR (7 downto 0);
           OPB : in STD_LOGIC_VECTOR (7 downto 0);
           RES : out STD_LOGIC_VECTOR (7 downto 0);
           new_status : out STD_LOGIC_VECTOR (7 downto 0);
           status_in: in std_logic_vector(7 downto 0);
           branch_test_result: out std_logic
           );
end ALU;

architecture Behavioral of ALU is
  signal z : std_logic := '0';            -- Zero Flag
  signal c : std_logic := '0';            -- Carry Flag
  signal v : std_logic := '0';            -- Overflow Flag
  signal n : std_logic := '0';            -- negative flag
  signal s : std_logic := '0';            -- sign flag
  signal erg : std_logic_vector(7 downto 0);  -- Zwischenergebnis
begin
  -- purpose: Kern-ALU zur Berechnung des Datenausganges
  -- type   : combinational
  -- inputs : OPA, OPB, OPCODE
  -- outputs: erg
  kern_ALU: process (OPA, OPB, OPCODE, status_in)
  begin  -- process kern_ALU
    erg <= "00000000";                  -- verhindert Latches
    branch_test_result <= '0';
    case OPCODE is
      -- ADD --> Addition
      when op_add =>
        erg <= std_logic_vector(unsigned(OPA) + unsigned(OPB));
      -- SUB
      when op_sub =>
        erg <= std_logic_vector(unsigned(OPA) - unsigned(OPB));
      -- OR
      when op_or =>
        erg <= OPA or OPB;
      
      --ADC and ROL
      when op_adc =>
        erg <= std_logic_vector(unsigned(OPA) + unsigned(OPB) + unsigned((status_in and "00000001")));
        
      when op_and =>
        erg <= OPA and opB;
        
      when op_eor =>
        erg <= OPA xor OPB;
        
      when op_mov =>
        erg <= opB;
        
      when op_brbs =>
        erg <= status_in AND OPB;
        branch_test_result <= (OPB(7) AND status_in(7)) or 
                       (OPB(6) AND status_in(6)) or 
                       (OPB(5) AND status_in(5)) or 
                       (OPB(4) AND status_in(4)) or 
                       (OPB(3) AND status_in(3)) or 
                       (OPB(2) AND status_in(2)) or 
                       (OPB(1) AND status_in(1)) or 
                       (OPB(0) AND status_in(0));
        
      when op_brbc =>
        erg <= (not status_in) AND OPB;
        branch_test_result <= (OPB(7) AND not status_in(7)) or 
                       (OPB(6) AND not status_in(6)) or 
                       (OPB(5) AND not status_in(5)) or 
                       (OPB(4) AND not status_in(4)) or 
                       (OPB(3) AND not status_in(3)) or 
                       (OPB(2) AND not status_in(2)) or 
                       (OPB(1) AND not status_in(1)) or 
                       (OPB(0) AND not status_in(0));
      
      
      when op_com =>
        erg <= std_logic_vector(255 - unsigned(OPA));
      
      
      when op_asr =>
        erg <= std_logic_vector(shift_right(signed(OPA), 1));
      
      when op_lsr =>
        erg <= std_logic_vector(shift_right(unsigned(OPA), 1));
      
      
      
          
      when others => null;
    end case;
  end process kern_ALU;

  -- purpose: berechnet die Statusflags
  -- type   : combinational
  -- inputs : OPA, OPB, OPCODE, erg
  -- outputs: z, c, v, n
  Berechnung_SREG: process (OPA, OPB, OPCODE, erg)
  begin  -- process Berechnung_SREG
    z <= (NOT erg(7) AND NOT erg(6) AND NOT erg(5) AND NOT erg(4) AND NOT erg(3) AND NOT erg(2) AND NOT erg(1) AND NOT erg(0));
    n <= erg(7);

    c <= '0';                           -- um Latches zu verhindern
    v <= '0';
    
    case OPCODE is
      -- ADD
      when op_add =>
        c<=(OPA(7) AND OPB(7)) OR (OPB(7) AND (not erg(7))) OR ((not erg(7)) AND OPA(7));
        v<=(OPA(7) AND OPB(7) AND (not erg(7))) OR ((not OPA(7)) and (not OPB(7)) and  erg(7));

      -- SUB
      when op_sub =>
        c<=(not OPA(7) and OPB(7)) or (OPB(7) and erg(7)) or (not OPA(7) and erg(7));
        v<=(OPA(7) and not OPB(7) and not erg(7)) or (not OPA(7) and OPB(7) and erg(7));

      -- OR
      when op_or =>
        c<='0';
        v<='0';

      --ADC and ROL
      when op_adc =>
        --h?
        c <= (opA(7) and opB(7)) or (opB(7) and not erg(7)) or (not erg(7) and opA(7));
        v <= (opA(7) and opB(7) and not erg(7)) or (not opA(7) and not opB(7) and erg(7));
        
      when op_and =>
        v <= '0';
        
      when op_eor =>
        v <= '0';

      
      when op_com =>
        v <= '0';
        c <= '1';
      
      
      when op_asr =>
        c <= opA(0);
        v <= erg(7) xor OPA(0);
      
      
      when op_lsr =>
        v <= '0' xor OPA(0);
        c <= OPA(0);
      
      when others => null;
    end case;
    
  end process Berechnung_SREG;  

  s <= v xor n;
  RES <= erg;
  new_status <= '0' & '0' & '0' & s & v & n & z & c;
  
end Behavioral;