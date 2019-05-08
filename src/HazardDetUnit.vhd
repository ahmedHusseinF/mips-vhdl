library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Detection_Unit is port(
IDEX_MemRead:            in std_logic; 	
IDEX_RD:                 in std_logic_vector (2 downto 0);
IFID_RS:                 in std_logic_vector (2 downto 0);
IFID_RD:                 in std_logic_vector (2 downto 0);
Bubble:                  out std_logic 


); 
end entity Hazard_Detection_Unit;

architecture Hazard_Detection_Unit_Arch of Hazard_Detection_Unit is 
begin

Process (IDEX_MemRead,IDEX_RD,IFID_RS,IFID_RD)
begin

if ( IDEX_MemRead='1' ) then
	if ( ( IDEX_RD = IFID_RS ) or (IDEX_RD = IFID_RD ) ) then
		
		Bubble <= '1';
	else
		Bubble <='0';
	end if;	

else
	        Bubble   <= '0';
	
end if;	

end process;

end Hazard_Detection_Unit_Arch;
