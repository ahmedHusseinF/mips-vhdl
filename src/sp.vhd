  library ieee;
Use ieee.std_logic_1164.all;

entity sp is 
port ( clk,rst,enable : in std_logic;
 signal_14 : in std_logic;
 OUTP: out std_logic_vector(31 DOWNTO 0);
 signal_15,signal_2 : in std_logic);
 
end entity;

architecture archit of sp is
component my_nadder_pc_sp IS
 PORT (a, b : IN std_logic_vector(31 DOWNTO 0) ; 
 cin : IN std_logic;
 s : OUT std_logic_vector(31 DOWNTO 0);
 cout : OUT std_logic);
END component;

component mux4x1_pc_sp is
  port ( in1,in2,in3 :in std_logic_vector (31 downto 0);
    s:in std_logic_vector (1 downto 0);
    output : out  std_logic_vector (31 downto 0));
  end component; 

component mux2x1_sp is
  port ( in1,in2 :in std_logic_vector (31 downto 0);
    s:in std_logic;
    output : out  std_logic_vector (31 downto 0));
  end component; 
  
  component reg_sp IS

PORT( Clk,Rst,enable : IN std_logic;
		   d : IN std_logic_vector(31 DOWNTO 0);
		   q : OUT std_logic_vector(31 DOWNTO 0));
END component;

  
 SIGNAL temp0,temp1,temp2,temp3,outt : std_logic_vector(31 DOWNTO 0);
 signal one,two,feedback,negone,negtwo : std_logic_vector(31 DOWNTO 0);
 signal signal_15_2 : std_logic_vector(1 DOWNTO 0);
  signal cou : std_logic;
 begin
   one <= "00000000000000000000000000000001";
   two <= "00000000000000000000000000000010";
   negone <= "11111111111111111111111111111111";
   negtwo <= "11111111111111111111111111111110";
   
   
  
   f0: my_nadder_pc_sp PORT MAP(outt, temp0,'0',temp2,cou);
   f1: my_nadder_pc_sp PORT MAP(outt,temp1,'0',temp3,cou);
   f2: mux2x1_sp  PORT MAP(one,two,signal_14,temp0);
   f3: mux2x1_sp  PORT MAP(negone,negtwo,signal_14,temp1);
   f4: mux4x1_pc_sp PORT MAP(outt,temp2,temp3,signal_15_2,feedback);
   f5: reg_sp port map (clk,rst,enable,feedback,outt);
    OUTP <= feedback;
    signal_15_2(0)<=signal_15;
    signal_15_2(1)<=signal_2;
  
   

  end architecture;
