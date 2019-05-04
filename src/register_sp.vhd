Library ieee;
use ieee.std_logic_1164.all;
ENTITY reg_sp IS

PORT( Clk,Rst,enable : IN std_logic;
		   d : IN std_logic_vector(31 DOWNTO 0);
		   q : OUT std_logic_vector(31 DOWNTO 0));
END reg_sp;
ARCHITECTURE archh OF reg_sp IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		q <= "00000000000100000000000000000000";
ELSIF rising_edge(Clk) and enable ='1' THEN
		q <= d;
END IF;
END PROCESS;
END archh;

