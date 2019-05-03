Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX11 is 
port (
    regADMUX0 : in std_logic_vector(15 downto 0);
    ALUres_MEM : in std_logic_vector(15 downto 0);
    ALUres_WB : in std_logic_vector(15 downto 0);
    signal_H1 : in std_logic_vector(1 downto 0);
    toALU: out std_logic_vector(15 downto 0)
);
end entity;

Architecture MUX11_Implment of MUX11 is
begin
	toAlU <= regADMUX0 when signal_H1 = "00"
	else ALUres_MEM when signal_H1 ="01"
	else ALUres_WB when signal_H1 ="10"
	else (others => '0');
end architecture;