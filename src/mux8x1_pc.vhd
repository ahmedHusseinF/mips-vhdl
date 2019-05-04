library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_pc is 
port (b1,b2,b3,b4,b5 : in std_logic_vector(31 downto 0);
s:in std_logic_vector(2 downto 0);
output :out std_logic_vector(31 downto 0));
 

end entity mux8x1_pc;

architecture arch of mux8x1_pc is 
begin 
 
  output<=b1 when s="000"
   else b2 when s="001"
   else b3 when s="010"
   else b4 when s="011"
   else b5 when s="100";
 
      
 

end architecture;
           
 
