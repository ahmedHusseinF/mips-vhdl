Library ieee;
use ieee.std_logic_1164.all;

entity Decoder_RegFile is 

port(
inn : IN std_logic_vector (2 DOWNTO 0);
outt : out std_logic_vector(7 downto 0);
e : in std_logic
);

end Decoder_RegFile;
Architecture myModel of Decoder_RegFile is


begin
outt<= "00000001" when inn="000" and e='1'
else   "00000010" when inn="001" and e='1'
else   "00000100" when inn="010" and e='1'
else   "00001000" when inn="011" and e='1'
else   "00010000" when inn="100" and e='1'
else   "00100000" when inn="101" and e='1'
else   "01000000" when inn="110" and e='1'
else   "10000000" when inn="111" and e='1'
else   "00000000";


end Architecture;
