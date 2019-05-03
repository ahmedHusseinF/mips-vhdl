Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMUX0 is 
port (
    regA : in std_logic_vector(15 downto 0);
    signal_10 : in std_logic_vector(1 downto 0);
    writePC1: out std_logic_vector(15 downto 0);
    outPort: out std_logic_vector(15 downto 0);
    toMUX11: out std_logic_vector(15 downto 0)
);
end entity;

Architecture DMUX0_Implment of DMUX0 is
begin
	writePC1 <= regA when signal_10 = "00"
		else (others => '0');
	outPort <= regA when signal_10 = "01"
		else (others => '0');
	toMUX11 <= regA when signal_10 = "10"
		else (others => '0');
end architecture;