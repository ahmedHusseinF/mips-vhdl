Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX0 is 
port (
    INPort : in std_logic_vector(15 downto 0);
    fromMem : in std_logic_vector(31 downto 0);
    ALUResult : in std_logic_vector(15 downto 0);
    ALUMulResult: in std_logic_vector(31 downto 0);
    signal_1 : in std_logic_vector(1 downto 0);
    regWrite: out std_logic_vector(31 downto 0)
);
end entity;

Architecture MUX0_Implment of MUX0 is
signal INport_32: std_logic_vector(31 downto 0);
signal ALUResult_32: std_logic_vector(31 downto 0);
begin
    INPort_32 <= "0000000000000000"&INport;
    ALUResult_32 <= "0000000000000000"&ALUResult;
	regWrite <= INPort_32 when signal_1 = "00"
	else fromMem when signal_1 = "01"
	else ALUResult_32 when signal_1 = "10"
	else ALUMulResult when signal_1 = "11"
	else (others => '0');
end architecture;