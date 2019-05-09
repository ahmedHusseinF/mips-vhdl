Library ieee;
Use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.numeric_std.all;

entity Control_Unit is 
port
(
 OpCode: in std_logic_vector(4 DOWNTO 0);
 INTR : in std_logic;
 RST: in std_logic;
 Sig_1:out std_logic_vector(1 DOWNTO 0);
 Sig_2,Sig_3,Sig_4,Sig_5 : out std_logic;
 Sig_6 :out std_logic_vector(1 DOWNTO 0);
 Sig_7 :out std_logic_vector(3 DOWNTO 0);
 Sig_8 :out std_logic_vector(1 DOWNTO 0);
 Sig_9 :out std_logic;
 Sig_10:out std_logic_vector(1 DOWNTO 0);
 Sig_11 :out std_logic;
 Sig_12 :out std_logic_vector(2 DOWNTO 0);
 Sig_13,Sig_14,Sig_15,Sig_16 :out std_logic;
 Sig_17 : out std_logic_vector(1 DOWNTO 0);
 Sig_18,Sig_19,Sig_20:out std_logic ;
 Sig_21:out std_logic_vector (1 DOWNTO 0);
 Bubble: in std_logic
 );
 

end entity;


architecture Control_Unit1 of Control_Unit is
begin


process (OpCode, RST)
begin

	-- intialize all as if it were a NOP inst.
if(RST='1') then
Sig_1 <="00";
Sig_2 <='0';
Sig_3  <='0';
Sig_4  <='0';
Sig_5  <='0' ;
Sig_6  <="11";
Sig_7  <="0000";
Sig_8  <="10";
Sig_9  <='0';
Sig_10 <="00";
Sig_11 <='0' ;
Sig_12 <="000";
Sig_13 <='0';
Sig_14 <='0';
Sig_15 <='0';
Sig_16 <='0';
Sig_17 <="10";
Sig_18 <='0';
Sig_19 <='0';
Sig_20 <='0';
Sig_21 <="00";

else

Sig_1 <="00";
Sig_2 <='0';
Sig_3  <='0';
Sig_4  <='0';
Sig_5  <='0' ;
Sig_6  <="00";
Sig_7  <="0000";
Sig_8  <="00";
Sig_9  <='0';
Sig_10 <="00";
Sig_11 <='0' ;
Sig_12 <="000";
Sig_13 <='0';
Sig_14 <='0';
Sig_15 <='0';
Sig_16 <='0';
Sig_17 <="00";
Sig_18 <='0';
Sig_19 <='0';
Sig_20 <='0';
Sig_21 <="00";
		
	
       --change values according to Function and opcode -- > overwrite values.

	IF(OpCode="00001") then --SETC
        	 Sig_5<='1';
         	 Sig_8<="10";
	 	 Sig_10<="10";
	            

	elsif(OpCode="00010") then --CLRC
                 Sig_5<='1';
		 Sig_7  <="0001";
         	 Sig_8<="10";
	 	 Sig_10<="10";
		 	 
        elsif(OpCode="00011") then --NOT
 		 Sig_1<="10";	         
                 Sig_5<='1';
		 Sig_7 <="0010";
         	 Sig_8<="10";
	 	 Sig_10<="10";
                 Sig_11<='1';
         	 

        elsif(OpCode="00100") then --INC
		 Sig_1<="10";	         
                 Sig_5<='1';
		 Sig_7 <="0011";
         	 Sig_8<="10";
	 	 Sig_10<="10";
                 Sig_11<='1';
                  

        elsif(OpCode="00101") then --DEC

		 Sig_1<="10";	         
                 Sig_5<='1';
		 Sig_7 <="0100";
         	 Sig_8<="10";
	 	 Sig_10<="10";
                 Sig_11<='1';

        elsif(OpCode="00110") then --OUT 
                 Sig_5<='1';
		 Sig_8<="10";
		 Sig_10<="01";
                 
        elsif(OpCode="00111") then --IN
		 Sig_1<="00";
 		 Sig_8<="10";
		 Sig_11<='1';

        elsif(OpCode="01000") then --MOV
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="0101";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';
		 

        elsif(OpCode="01001") then --ADD
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="0110";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';	
		 
        elsif(OpCode="01010") then --MUL
		 Sig_1<="11";
		 Sig_5<='1';
		 Sig_7<="0111";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';
		 Sig_20<='1';

        elsif(OpCode="01011") then --SUB
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1000";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';

        elsif(OpCode="01100") then --AND
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1001";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';

        elsif(OpCode="01101") then --OR
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1010";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
 		 Sig_13<='1';
		 Sig_18<='1';
		 Sig_19<='1';

        elsif(OpCode="01110") then --SHL
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1011";
		 Sig_8<="10";
		 Sig_9<='1';
		 Sig_10<="10";
		 Sig_11<='1';
		 Sig_17<="01";
 

        elsif(OpCode="01111") then --SHR
		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1100";
		 Sig_8<="10";
		 Sig_9<='1';
		 Sig_10<="10";
		 Sig_11<='1';
		 Sig_17<="01";

        elsif(OpCode="10000") then --PUSH
		 Sig_3<='1';
		 Sig_5<='1';
		 Sig_7<="1101";
		 Sig_8<="10";
		 Sig_10<="10";
		 

	elsif(OpCode="10001") then --POP
		 Sig_1<="01";
		 Sig_4<='1';
		 Sig_5<='1';
		 Sig_7<="1101";
		 Sig_8<="10";
		 Sig_10<="10";
		 Sig_11<='1';
	 	 Sig_15<='1';

	elsif(OpCode="10010") then --LDM
 		 Sig_1<="10";
		 Sig_5<='1';
		 Sig_7<="1110";
		 Sig_8<="10";
		 Sig_9<='1';
		 Sig_10<="10";
		 Sig_11<='1';
		 Sig_17<="01";

        elsif(OpCode="10011") then --LDD 
		 Sig_1<="01";		 
		 Sig_3<='1';
		 Sig_5<='1';
		 Sig_6<="01";
	 	 Sig_10<="10";
		 Sig_11<='1';
		 Sig_17<="01";

		 
	elsif(OpCode="10100") then --STD
		 Sig_3<='1';
		 Sig_5<='1';
	 	 Sig_6<="01";
		 Sig_7<="1101";
		 Sig_8<="10";
		 Sig_10<="10";
                 Sig_17<="01";
		 
	elsif(OpCode="10101") then --JZ
			
		 Sig_2<='1';
		 Sig_5<='1';
		 Sig_8<="10";
		 Sig_12<="001";
		 Sig_21<="00";
	 	 
	elsif(OpCode="10110") then --JN
		 Sig_2<='1';
		 Sig_5<='1';
		 Sig_8<="10";
		 Sig_12<="001";
		 Sig_21<="01";

	elsif(OpCode="10111") then --JC
		 Sig_2<='1';
		 Sig_5<='1';
		 Sig_8<="10";
		 Sig_12<="001";
		 Sig_21<="10";

	elsif(OpCode="11000") then --JMP

		 Sig_2<='1';
		 Sig_5<='1';
		 Sig_8<="10";
		 Sig_12<="001";
		 Sig_21<="11";

	 --elsif(OpCode="11001") then --Call
		 
		
	--elsif(OpCode="11010") then --RET

	--elsif(OpCode="11011") then --RTI

	else -- NOP its deafult as we assumed from first intialization.
		
	END IF;
	end if;

if(Bubble='1')
then

Sig_1 <="00";
Sig_2 <='0';
Sig_3  <='0';
Sig_4  <='0';
Sig_5  <='0' ;
Sig_6  <="00";
Sig_7  <="0000";
Sig_8  <="00";
Sig_9  <='0';
Sig_10 <="00";
Sig_11 <='0' ;
Sig_12 <="000";
Sig_13 <='0';
Sig_14 <='0';
Sig_15 <='0';
Sig_16 <='0';
Sig_17 <="10";
Sig_18 <='0';
Sig_19 <='0';
Sig_20 <='0';
Sig_21 <="00";

end if;

end process;

end Control_Unit1;
