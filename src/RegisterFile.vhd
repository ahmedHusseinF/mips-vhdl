library ieee;
use ieee.std_logic_1164.all;
entity RegisterFile is 
  
  port(
       clk,rst,e:in std_logic;
       FirstOpAdd : in std_logic_vector(2 downto 0); 
       SecondOpAdd: in std_logic_vector(2 downto 0);
       WriteRegAdd1: in std_logic_vector(2 downto 0);
       WriteRegAdd2: in std_logic_vector(2 downto 0);
       WriteRegData_16:in std_logic_vector(15 downto 0);
       WriteRegData_32:in std_logic_vector(31 downto 0);
       sig_13:in std_logic;
       sig_20:in std_logic; --WriteInTwoReg signal
       sig_11:in std_logic;
       FirstOpData:out std_logic_vector(15 downto 0);
       SecondOpData:out std_logic_vector(15 downto 0)    
       );

  end entity RegisterFile;
  
architecture RF of RegisterFile is 
  
  component Reg_RegFile
  is Generic ( n : integer := 16);
  port( Clk,Rst,we: in std_logic; 
        d : in std_logic_vector(n-1 downto 0); 
        q : out std_logic_vector(n-1 downto 0));
  end component Reg_RegFile;

  component Decoder_RegFile
  is port(inn :in std_logic_vector(2 downto 0);
          outt :out std_logic_vector(7 downto 0);
          e :in std_logic);
  end component Decoder_RegFile;

  component mux8x1_RegFile
  is port ( A1,A2,A3,A4,A5,A6,A7,A8 : in std_logic_vector(15 downto 0);
            s:in std_logic_vector(2 downto 0);
            output :out std_logic_vector(15 downto 0)); 
  end component mux8x1_RegFile;

signal D_Out:std_logic_vector (7 DOWNTO 0);
signal D1_Out:std_logic_vector (7 DOWNTO 0);
signal D2_Out:std_logic_vector (7 DOWNTO 0);
signal D3_Out:std_logic_vector (7 DOWNTO 0);
signal M_in1,M_in2,M_in3,M_in4,M_in5,M_in6,M_in7,M_in8:std_logic_vector(15 downto 0);
signal WriteRegAdd:std_logic_vector (2 DOWNTO 0);

signal WriteEnable_16 :std_logic;
signal WriteEnable_32 :std_logic;
 
signal WriteRegData_1 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_2 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_3 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_4 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_5 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_6 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_7 : std_logic_vector(15 DOWNTO 0);
signal WriteRegData_8 : std_logic_vector(15 DOWNTO 0);

begin
   -- I want to write in Rsrc or Rdest
   WriteRegAdd <= WriteRegAdd1 when sig_13='0' 
          else    WriteRegAdd2 when sig_13='1' ;

   --Enables of the decoders---------------------------------------------------------------
   WriteEnable_16 <= (sig_11 and (not sig_20));
   WriteEnable_32 <= (sig_11 and  sig_20);
   --Oring the outputs  of the decoders to prevent overwrite---------------------------------
   D_out<= D1_Out or D2_Out or D3_Out;
   
  -- If we want to write in the two registers at the same time-------------------------------
  D:  Decoder_RegFile port map(WriteRegAdd1,D1_Out,WriteEnable_32);
  D1: Decoder_RegFile port map(WriteRegAdd2,D2_Out,WriteEnable_32);

  -- This Decoder will be enabled at the default right operation 16 bit in one registers-----
  D2: Decoder_RegFile port map(WriteRegAdd,D3_Out,WriteEnable_16);

  -- Which Data will be in the register--------------------------------------------------------
  WriteRegData_1<= WriteRegData_16 when sig_20='0'
              else WriteRegData_32(15 DownTO 0) when  sig_20='1' and WriteRegAdd1="000"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="000";
  WriteRegData_2<= WriteRegData_16 when sig_20='0'
              else WriteRegData_32(15 DownTO 0) when  sig_20='1' and WriteRegAdd1="001"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="001";
  WriteRegData_3<= WriteRegData_16 when sig_20='0'
	      else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="010"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="010";
  WriteRegData_4<= WriteRegData_16 when sig_20='0'
	      else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="011"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="011";
  WriteRegData_5<= WriteRegData_16 when sig_20='0'
	      else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="100"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="100";
  WriteRegData_6<= WriteRegData_16 when sig_20='0'
	      else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="101"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="101";
  WriteRegData_7<= WriteRegData_16 when sig_20='0'
              else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="110"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="110";
 WriteRegData_8<= WriteRegData_16 when sig_20='0'
              else WriteRegData_32(15 DownTO 0) when sig_20='1' and WriteRegAdd1="111"
              else WriteRegData_32(31 DownTO 16) when sig_20='1' and WriteRegAdd2="111";
  ---------------------------------------------------------------------------------------------

  
   
  
  -- Our 7 GP Registers-----------------------------------------------------------------------
  R1: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(0),WriteRegData_1,M_in1);
  R2: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(1),WriteRegData_2,M_in2);
  R3: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(2),WriteRegData_3,M_in3);
  R4: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(3),WriteRegData_4,M_in4);
  R5: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(4),WriteRegData_5,M_in5);
  R6: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(5),WriteRegData_6,M_in6);
  R7: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(6),WriteRegData_7,M_in7);
  R8: Reg_RegFile generic map (n => 16) port map(clk,rst,D_Out(7),WriteRegData_8,M_in8);
------------------------------------------------------------------------------------------------
  M1 : mux8x1_RegFile port map(M_in1,M_in2,M_in3,M_in4,M_in5,M_in6,M_in7,M_in8,FirstOpAdd,FirstOpData);
  M2 : mux8x1_RegFile port map(M_in1,M_in2,M_in3,M_in4,M_in5,M_in6,M_in7,M_in8,SecondOpAdd,SecondOpData);
  

end architecture RF;
