Library ieee;
Use ieee.std_logic_1164.all;

entity pc is 
port ( clk,rst,enable : in std_logic;
 signal_12 : in std_logic_vector(2 DOWNTO 0);
 signal_17 : in std_logic_vector(1 DOWNTO 0);
 writepc1 : IN std_logic_vector(31 DOWNTO 0);
 writepc2 : IN std_logic_vector(31 DOWNTO 0);
 OP : out std_logic_vector(31 DOWNTO 0));
end entity;

architecture archi of pc is
component my_nadder_pc_sp IS
 PORT (a, b : IN std_logic_vector(31 DOWNTO 0) ; 
 cin : IN std_logic;
 s : OUT std_logic_vector(31 DOWNTO 0);
 cout : OUT std_logic);
END component;

component reg_pc IS

PORT( Clk,Rst,enable : IN std_logic;
		   d : IN std_logic_vector(31 DOWNTO 0);
		   q : OUT std_logic_vector(31 DOWNTO 0));
END component;

component mux8x1_pc is 
port (b1,b2,b3,b4,b5 : in std_logic_vector(31 downto 0);
s:in std_logic_vector(2 downto 0);
output :out std_logic_vector(31 downto 0));

 
 end component;
 
 component mux4x1_pc_sp is
  port ( in1,in2,in3 :in std_logic_vector (31 downto 0);
    s:in std_logic_vector (1 downto 0);
    output : out  std_logic_vector (31 downto 0));
  end component; 
  
 SIGNAL temp0,temp1,temp2,feedback : std_logic_vector(31 DOWNTO 0);
 signal zero,one,two,outt : std_logic_vector(31 DOWNTO 0);
  signal cou : std_logic;
 begin
   one <= "00000000000000000000000000000001";
   two <= "00000000000000000000000000000010";
   zero <= "00000000000000000000000000000000";
  
   f0:  my_nadder_pc_sp PORT MAP(outt, one,'0',temp0,cou);
   f1: my_nadder_pc_sp PORT MAP(outt,two,'0',temp1,cou);
   f2: mux8x1_pc PORT MAP(temp2,writepc1,writepc2,zero,one,signal_12,feedback);
   f3: mux4x1_pc_sp PORT MAP(temp0,temp1,outt,signal_17,temp2);
   f4: reg_pc port map (clk,rst,enable,feedback,outt);
   OP<=feedback;

  end architecture;
