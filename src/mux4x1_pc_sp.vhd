Library ieee;
use ieee.std_logic_1164.all;
entity mux4x1_pc_sp is
  port ( in1,in2,in3 :in std_logic_vector (31 downto 0);
    s:in std_logic_vector (1 downto 0);
    output : out  std_logic_vector (31 downto 0));
  end entity; 
  
  architecture  archit of mux4x1_pc_sp is
    begin 
      output<= in1 when s="00"
  else in2 when s="01"
 else in3 when s="10";

end architecture;  
