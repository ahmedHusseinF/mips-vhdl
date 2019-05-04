Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
port (
    operandA : in std_logic_vector(15 downto 0);
    operandB : in std_logic_vector(15 downto 0);
    signal_7 : in std_logic_vector(3 downto 0);
    result: out std_logic_vector(15 downto 0);
    mulRes: out std_logic_vector(31 downto 0);
    writeC: out std_logic;
    writeN: out std_logic;
    writeZ: out std_logic
);
end entity;

Architecture ALU_Implment of ALU is
--
component my_nadder IS
Generic (n : integer := 16);
PORT    (a, b : in std_logic_vector(n-1 downto 0) ;
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END component;
signal carryBit : std_logic;
signal toAddA : std_logic_vector(15 downto 0);
signal toAddB : std_logic_vector(15 downto 0);
signal addRes : std_logic_vector(15 downto 0);
begin 
add : my_nadder generic map(16) port map(toAddA, toAddB, '0', addRes, carryBit);

writeC <= '1' when signal_7 = "0000"
	else '0' when signal_7 = "0001"
	else carryBit;
writeN <= '1' when signed(addRes) < 0
	else '1' when (signed(operandA)*signed(operandB)) < 0
	else '0';
writeZ <= '1' when addRes = "0000000000000000"
	else '1' when (operandA = "0000000000000000" or operandB = "0000000000000000") 
	else '0';
toAddA <= operandA when signal_7 = "0011"
	else operandA when signal_7 = "0100"
	else operandA when signal_7 = "0110"
	else operandA when signal_7 = "1000";
toAddB <= "0000000000000001" when signal_7 = "0011"
	else "1111111111111111" when signal_7 = "0100"
	else operandB when signal_7 = "0110"
	else std_logic_vector(unsigned(not operandB)+1) when signal_7 = "1000"
	else (others => '0');
result <= not operandA  when signal_7 = "0010"
	else addRes when signal_7 = "0011"
 	else addRes when signal_7 = "0100"
	else operandA when signal_7 = "0101"
	else addRes when signal_7 = "0110"
	else addRes when signal_7 = "1000"
	else operandA and operandB when signal_7 ="1001"
	else operandA or operandB when signal_7 = "1010"
	else std_logic_vector(shift_left(unsigned(operandA), to_integer(unsigned(operandB)))) when signal_7 = "1011"
	else std_logic_vector(shift_right(unsigned(operandA), to_integer(unsigned(operandB)))) when signal_7 = "1100";

mulRes <= std_logic_vector(unsigned(operandA) * unsigned(operandB)) when signal_7 = "0111"
	else (others => '0');
end architecture;





