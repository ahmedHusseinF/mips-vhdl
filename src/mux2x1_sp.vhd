Library ieee;
use ieee.std_logic_1164.all;
entity mux2x1_sp is
  port ( in1,in2 :in std_logic_vector (31 downto 0);
    s:in std_logic;
    output : out  std_logic_vector (31 downto 0));
  end entity; 
  
  architecture  archit of mux2x1_sp is
    begin 
      output<= in1 when s='0'
  else in2 when s='1' ;
 

end architecture; 
