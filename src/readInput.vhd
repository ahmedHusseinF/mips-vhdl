Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity readInp is 
port (
    Input : in std_logic_vector(4 downto 0);
    Output : out std_logic_vector(4 downto 0);
clk : in std_logic;
rst : in std_logic;
mode : in std_logic
);
end entity;

Architecture readInpImp of readInp is
Signal count : std_logic_vector(4 downto 0);
Signal outCount : std_logic_vector(4 downto 0);
Signal key0 : std_logic_vector(4 downto 0);
Signal key1 : std_logic_vector(4 downto 0);
Signal key2 : std_logic_vector(4 downto 0);
Signal key3 : std_logic_vector(4 downto 0);
Signal key4 : std_logic_vector(4 downto 0);
Signal key5 : std_logic_vector(4 downto 0);
Signal key6 : std_logic_vector(4 downto 0);
Signal key7 : std_logic_vector(4 downto 0);
Signal key8 : std_logic_vector(4 downto 0);
Signal key9 : std_logic_vector(4 downto 0);
Signal keylength : std_logic_vector(4 downto 0);
begin 
process(-- sensitivity list
    clk, rst
)
begin
    -- inside the process block you can use conditions.
    if(rst = '1') then
        key0 <= "00000";
        key1 <= "00000";
	key2 <= "00000";
	key3 <= "00000";
	key4 <= "00000";
 	key5 <= "00000";
	key6 <= "00000";
	key7 <= "00000";
 	key8 <= "00000";
	key9 <= "00000";
	keylength <= "00000";
	count <= "00000";
	outCount <= "00000";
	Output <= "00000";
    elsif (mode = '0' and rising_edge(clk)) then
	--read key
	count <= std_logic_vector(unsigned(count)+1);
	if(unsigned(count) = 0) then
	key0 <= Input;
	elsif(unsigned(count) = 1) then
	key1 <= Input;
	elsif(unsigned(count) = 2) then
	key2 <= Input;
	elsif(unsigned(count) = 3) then
	key3 <= Input;
	elsif(unsigned(count) = 4) then
	key4 <= Input;
	elsif(unsigned(count) = 5) then
	key5 <= Input;
	elsif(unsigned(count) = 6) then
	key6 <= Input;
	elsif(unsigned(count) = 7) then
	key7 <= Input;
	elsif(unsigned(count) = 8) then
	key8 <= Input;
	elsif(unsigned(count) = 9) then
	key9 <= Input;
	end if;
	keylength <= std_logic_vector(unsigned(count)+1);
    elsif (mode = '1' and  rising_edge(clk)) then
	outCount <= std_logic_vector((unsigned(outCount)+1) mod unsigned(keylength));

	if(unsigned(outCount) = 0) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key0))mod 28);
	elsif(unsigned(outCount) = 1) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key1))mod 28);
	elsif(unsigned(outCount) = 2) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key2))mod 28);
	elsif(unsigned(outCount) = 3) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key3))mod 28);
	elsif(unsigned(outCount) = 4) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key4))mod 28);
	elsif(unsigned(outCount) = 5) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key5))mod 28);
	elsif(unsigned(outCount) = 6) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key6))mod 28);
	elsif(unsigned(outCount) = 7) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key7))mod 28);
	elsif(unsigned(outCount) = 8) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key8))mod 28);
	elsif(unsigned(outCount) = 9) then
	Output <= std_logic_vector((unsigned(Input) + unsigned(key9))mod 28);
	end if;
end if;
-- Process ends with this.
end process;

end architecture;
