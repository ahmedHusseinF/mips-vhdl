Library ieee;
use ieee.std_logic_1164.all;
ENTITY reg_pc IS

PORT( Clk,Rst,enable : IN std_logic;
		   d : IN std_logic_vector(31 DOWNTO 0);
		   q : OUT std_logic_vector(31 DOWNTO 0));
END entity;
ARCHITECTURE archh OF reg_pc IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF falling_edge(Clk) and enable ='1' THEN
		q <= d;
END IF;
END PROCESS;
END archh;

