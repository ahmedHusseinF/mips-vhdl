
Library ieee;
use ieee.std_logic_1164.all;
ENTITY Fetch_Bufer IS
GENERIC ( n : integer := 16);
PORT( 
Clk,Rst,we : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0)
);
      
END Fetch_Bufer;
	 	
ARCHITECTURE Buff OF Fetch_Bufer IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
q <= (OTHERS=>'0');
ELSIF 
we= '1' THEN
q <= d;
END IF;
END PROCESS;
END Buff;



