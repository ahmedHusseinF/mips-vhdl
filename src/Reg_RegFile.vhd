Library ieee;
use ieee.std_logic_1164.all;
ENTITY Reg_RegFile IS
GENERIC ( n : integer := 16);
PORT( 
Clk,Rst,we : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0)
);
      
END Reg_RegFile;
	
ARCHITECTURE a_my_nDFF OF Reg_RegFile IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
                 q <= (OTHERS=>'0');
ELSIF 
rising_edge(clk) and we= '1' THEN
		q <= d;
END IF;
END PROCESS;
END a_my_nDFF;




