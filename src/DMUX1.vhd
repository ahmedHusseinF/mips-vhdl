Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMUX1 is 
port (
    fromMem : in std_logic_vector(31 downto 0);
    signal_8 : in std_logic_vector(1 downto 0);
    wbData: out std_logic_vector(31 downto 0);
    writePC2: out std_logic_vector(31 downto 0);
    Instr: out std_logic_vector(31 downto 0)
);
end entity;

Architecture DMUX1_Implment of DMUX1 is
begin
	wbData <= fromMem when signal_8 = "00"
		else (others => '0');
	writePC2 <= fromMem when signal_8 = "01"
		else (others => '0');
	Instr <= fromMem when signal_8 = "10";
		
end architecture;