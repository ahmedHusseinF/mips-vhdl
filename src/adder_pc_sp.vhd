Library ieee;
use ieee.std_logic_1164.all;
ENTITY  my_nadder_pc_sp IS
 
PORT (a, b : IN std_logic_vector(31 DOWNTO 0) ; 
 cin : IN std_logic;
 s : OUT std_logic_vector(31 DOWNTO 0);
 cout : OUT std_logic);
END  my_nadder_pc_sp;

ARCHITECTURE a_my_nadder OF  my_nadder_pc_sp IS 
COMPONENT my_adder IS 
PORT( a,b,cin : IN std_logic; 
s,cout : OUT std_logic); 
END COMPONENT;
 SIGNAL Temp : std_logic_vector(31 DOWNTO 0); 
begin 
  f0: my_adder PORT MAP(a(0),b(0),cin,s(0),temp(0));
loop1: FOR i IN 1 TO 31 GENERATE
fx: my_adder PORT MAP(a(i),b(i),temp(i-1),s(i),temp(i));
END GENERATE;
end architecture;
