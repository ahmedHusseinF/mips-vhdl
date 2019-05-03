Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX1 is 
port (
    regB : in std_logic_vector(15 downto 0);
    imm : in std_logic_vector(15 downto 0);
    signal_9 : in std_logic;
    toMUX10: out std_logic_vector(15 downto 0)
);
end entity;

Architecture MUX1_Implment of MUX1 is
begin
	toMUX10 <= regB when signal_9 = '0'
	else imm when signal_9 ='1'
	else (others => '0');
end architecture;
