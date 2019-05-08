Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX13 is 
port (
    Instr_WB1 : in std_logic_vector(2 downto 0);
    Instr_WB2 : in std_logic_vector(2 downto 0);
    signal_19 : in std_logic;
    toForwarding: out std_logic_vector(2 downto 0)
);
end entity;

Architecture MUX13_Implment of MUX13 is
begin
	toForwarding <= Instr_WB1 when signal_19 = '0'
	else Instr_WB2 when signal_19 ='1'
	else (others => '0');
end architecture;