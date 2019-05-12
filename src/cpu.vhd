library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity cpu is
  port (
	clk: in std_logic;
	rst: in std_logic;
	Int: in std_logic;
	INPort: in std_logic_vector(15 downto 0);
	OutPort: out std_logic_vector(15 downto 0)
  );
end cpu; 

architecture cpu_wiring of cpu is

	component Bufer IS
	GENERIC ( n : integer := 16);
	PORT( 
	Clk,Rst,we : IN std_logic;
	d : IN std_logic_vector(n-1 DOWNTO 0);
	q : OUT std_logic_vector(n-1 DOWNTO 0)
	);
				
	END component;


component fetch_memory_wb is 
generic (reg_width: Integer := 16;address_line: Integer := 20; ram_width: Integer := 16);
port (
	clk: in std_logic;
	rst: in std_logic;
	enable: in std_logic;
	----
    	ea_reg: in std_logic_vector(address_line-1 downto 0);
    	pc_reg_ex: in std_logic_vector(32-1 downto 0);
    	pc_reg_fetch: in std_logic_vector(32-1 downto 0); 
    	--sp_reg: in std_logic_vector(32-1 downto 0);
	----
	-- using pc here too
	alu_result_in: in std_logic_vector(16-1 downto 0);
	mul_result_in: in std_logic_vector(32-1 downto 0);
	writePC1: in std_logic_vector(32-1 downto 0);
	signal_5: in std_logic;
	----
	instr_26_24_in: in std_logic_vector(2 downto 0);
	instr_23_21_in: in std_logic_vector(2 downto 0);
	signal_18: in std_logic;
	----
	signal_1: in std_logic_vector(1 downto 0);
	signal_8: in std_logic_vector(1 downto 0);
	signal_3: in std_logic;
	signal_4: in std_logic;
	signal_6: in std_logic_vector(2-1 downto 0);
	signal_12: in std_logic_vector(2 downto 0);
	signal_17: in std_logic_vector(1 downto 0);
	signal_16: in std_logic;
	signal_19: in std_logic;
	instr_read: in std_logic;
	----
	Instr: out std_logic_vector(31 downto 0);
	WriteData: out std_logic_vector(31 downto 0);
	PC_out: out std_logic_vector(31 downto 0);
	Rdst: out std_logic_vector(2 downto 0);
	ex_mem_rdst: out std_logic_vector(2 downto 0);
	Instr_WB1_out: out std_logic_vector(2 downto 0);
	Instr_WB2_out: out std_logic_vector(2 downto 0);
	INPort: in std_logic_vector(15 downto 0);
	s11_mem_wb_fetch : in std_logic;
	s13_mem_wb_fetch : in std_logic;
	s20_mem_wb_fetch : in std_logic;
	s14_mem_wb_fetch : in std_logic;
	s15_mem_wb_fetch : in std_logic;
	s2_mem_wb_fetch : in std_logic;
	s13_wb: out std_logic;
  s11_wb: out std_logic;
  s20_wb: out std_logic
);
end component;



component RegisterFile is 
  
  port(
       clk,rst,e:in std_logic;
       FirstOpAdd : in std_logic_vector(2 downto 0); 
       SecondOpAdd: in std_logic_vector(2 downto 0);
       WriteRegAdd1: in std_logic_vector(2 downto 0);
       WriteRegAdd2: in std_logic_vector(2 downto 0);
       WriteRegData_32:in std_logic_vector(31 downto 0);
       sig_13:in std_logic;
       sig_20:in std_logic; --WriteInTwoReg signal
       sig_11:in std_logic;
       FirstOpData:out std_logic_vector(15 downto 0);
       SecondOpData:out std_logic_vector(15 downto 0)    
       );
  end component RegisterFile;

component Control_Unit is 
port
(
 clk: in std_logic;
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
 Bubble: in std_logic;
zf: in std_logic;
nf: in std_logic;
cf: in std_logic
 );
 

end component;

component execute_stage is 
port (
    PC_in : in std_logic_vector(31 downto 0);
    regA : in std_logic_vector(15 downto 0);
    regB : in std_logic_vector(15 downto 0);
    imm : in std_logic_vector(15 downto 0);
    instr26_24_in: in std_logic_vector(2 downto 0);
    instr23_21_in: in std_logic_vector(2 downto 0);
    ALUres_MEM : in std_logic_vector(15 downto 0);
    ALUres_WB : in std_logic_vector(15 downto 0);
    signal_7 : in std_logic_vector(3 downto 0);
    signal_9 : in std_logic;
    signal_10 : in std_logic_vector(1 downto 0);
    signal_H0 : in std_logic_vector(1 downto 0);
    signal_H1 : in std_logic_vector(1 downto 0);
    PC_out : out std_logic_vector(31 downto 0);
    outPort : out std_logic_vector(15 downto 0);
    ALU_result : out std_logic_vector(15 downto 0);
    mulRes : out std_logic_vector(31 downto 0);
    zeroF : out std_logic;
    carryF : out std_logic;
    negativeF : out std_logic;
    writePC1 : out std_logic_vector(15 downto 0);  --Unhandled 16 bits PC to 32 bits PC mapping triggered when jumping
    ID_EX_Rsrc : out std_logic_vector(2 downto 0);
    ID_EX_Rdst : out std_logic_vector(2 downto 0);
    instr26_24_out: out std_logic_vector(2 downto 0);
    instr23_21_out: out std_logic_vector(2 downto 0)
);
end component;


	--15-----0
	--31-----16
	--op code 15 - 11
	--1st operand 10 - 8
	--2nd operand 7 - 5
	--Imm 31 - 16
	--EA 4 - 0 + 31 - 18
signal instrSig:std_logic_vector(31 downto 0);
signal first_op_wb: std_logic_vector(2 downto 0);
signal second_op_wb:std_logic_vector(2 downto 0);
signal data_wb:std_logic_vector(31 downto 0);
signal pc_fetch: std_logic_vector(31 downto 0);
signal regA_s: std_logic_vector(15 downto 0);
signal regB_s: std_logic_vector(15 downto 0);
signal ALUResult_mem_s: std_logic_vector(15 downto 0); --FU to be implmented
signal ALUResult_wb_s: std_logic_vector(15 downto 0); --FU to be implmented
signal ALUResult_s: std_logic_vector(15 downto 0); 
signal ALUMul_s: std_logic_vector(31 downto 0); 
signal zeroF_s: std_logic;			--to be implmented Jump
signal negativeF_s: std_logic;	--to be implmented Jump
signal carryF_s: std_logic;			--to be implmented Jump
signal writePC1_s: std_logic_vector(15 downto 0); --to be implmented Jump
signal ID_EX_Rsrc_s: std_logic_vector(2 downto 0); --to be implmented FU
signal ID_EX_Rdst_s : std_logic_vector(2 downto 0); --to be implmented FU
signal wb_rdst: std_logic_vector(2 downto 0); --to be implmented FU
signal ex_mem_rdst_s: std_logic_vector(2 downto 0); --to be implmented FU
signal writePC1_32: std_logic_vector(31 downto 0);
signal ea_20: std_logic_vector(19 downto 0);

signal s1: std_logic_vector(1 downto 0);
signal s2: std_logic;
signal s3: std_logic;
signal s4: std_logic;
signal s5: std_logic;
signal s6: std_logic_vector(1 downto 0);
signal s7: std_logic_vector(3 downto 0);
signal s8: std_logic_vector(1 downto 0);
signal s9: std_logic;
signal s10: std_logic_vector(1 downto 0);
signal s11: std_logic;
signal s12: std_logic_vector(2 downto 0);
signal s13: std_logic;
signal s14: std_logic;
signal s15: std_logic;
signal s16: std_logic;
signal s17: std_logic_vector(1 downto 0);
signal s18: std_logic;
signal s19: std_logic;
signal s20: std_logic;
signal s21: std_logic_vector(1 downto 0);
 

--Signals to buffers
signal IF_ID_IN: std_logic_vector(63 downto 0);
signal IF_ID_OUT: std_logic_vector(63 downto 0);

signal ID_EX_IN: std_logic_vector(137 downto 0);
signal ID_EX_OUT: std_logic_vector(137 downto 0);

signal EX_MEM_IN: std_logic_vector(130 downto 0);
signal EX_MEM_OUT: std_logic_vector(130 downto 0);

--Intermediate signals
signal pc_decode: std_logic_vector(31 downto 0);
signal Instr_decode: std_logic_vector(31 downto 0);
---------------------
signal s2_ex :std_logic;
signal s3_ex :std_logic;
signal s4_ex :std_logic;
signal s5_ex :std_logic;
signal s6_ex : std_logic_vector(1 downto 0);
signal s8_ex :std_logic_vector(1 downto 0);
signal s11_ex :std_logic;
signal s12_ex :std_logic_vector(2 downto 0);
signal s14_ex :std_logic;
signal s15_ex :std_logic;
signal s16_ex :std_logic;
signal s17_ex :std_logic_vector(1 downto 0);
signal s18_ex :std_logic;
signal s19_ex :std_logic;
signal s20_ex :std_logic;
signal s21_ex :std_logic_vector(1 downto 0);
----------------------
signal s7_ex: std_logic_vector(3 downto 0);
signal s9_ex: std_logic;
signal s10_ex: std_logic_vector(1 downto 0);
signal regA_ex: std_logic_vector(15 downto 0);
signal regB_ex: std_logic_vector(15 downto 0);
signal Imm_execute: std_logic_vector(15 downto 0);
signal ea_ex: std_logic_vector(19 downto 0);
signal pc_execute: std_logic_vector(31 downto 0);
signal pc_execute_out: std_logic_vector(31 downto 0);
signal opA_ex: std_logic_vector(2 downto 0);
signal opB_ex: std_logic_vector(2 downto 0);
signal opA_ex_out: std_logic_vector(2 downto 0);
signal opB_ex_out: std_logic_vector(2 downto 0);
signal s1_ex: std_logic_vector(1 downto 0);
signal s13_ex: std_logic;
signal s1_mem_wb_fetch: std_logic_vector(1 downto 0);
signal s2_mem_wb_fetch: std_logic;
signal s3_mem_wb_fetch: std_logic;
signal s4_mem_wb_fetch: std_logic;
signal s5_mem_wb_fetch: std_logic;
signal s6_mem_wb_fetch: std_logic_vector(1 downto 0);
signal s8_mem_wb_fetch: std_logic_vector(1 downto 0);
signal s11_mem_wb_fetch: std_logic;
signal s12_mem_wb_fetch: std_logic_vector(2 downto 0);
signal s13_mem_wb_fetch: std_logic;  
signal s14_mem_wb_fetch: std_logic;
signal s15_mem_wb_fetch: std_logic;
signal s16_mem_wb_fetch: std_logic;
signal s17_mem_wb_fetch: std_logic_vector(1 downto 0);
signal s18_mem_wb_fetch: std_logic;
signal s19_mem_wb_fetch: std_logic;
signal s20_mem_wb_fetch: std_logic;
signal s21_mem_wb_fetch: std_logic_vector(1 downto 0);
signal ALUResult_MEM: std_logic_vector(15 downto 0);
signal ALUMUL_MEM: std_logic_vector(31 downto 0);
signal pc_memory: std_logic_vector(31 downto 0);
signal opA_mem: std_logic_vector(2 downto 0);
signal opB_mem: std_logic_vector(2 downto 0);
signal ea_mem: std_logic_vector(19 downto 0);
signal s13_decode: std_logic;
signal s11_decode: std_logic;
signal s20_decode: std_logic;

begin
IF_ID_IN <= pc_fetch&InstrSig;
--Stage output signals
pc_decode <= IF_ID_OUT(63 downto 32);
Instr_decode <= IF_ID_OUT(31 downto 0);
-----------------------------------------------------------

--ID/EX
ea_20 <= Instr_decode(4 downto 0)&Instr_decode(31 downto 17);
ID_EX_IN <= s1&s2&s3&s4&s5&s6&s7&s8&s9&s10&s11&s12&s13&s14&s15&s16&s17&s18&s19&s20&s21&regA_s&regB_s&(Instr_decode(31 downto 16))&ea_20&pc_decode&(Instr_decode(10 downto 5));


s1_ex <= ID_EX_OUT(137 downto 136);

s2_ex <= ID_EX_OUT(135);
s3_ex <= ID_EX_OUT(134);
s4_ex <= ID_EX_OUT(133);
s5_ex <= ID_EX_OUT(132);
s6_ex <= ID_EX_OUT(131 downto 130);

s7_ex <= ID_EX_OUT(129 downto 126);

s8_ex <= ID_EX_OUT(125 downto 124);

s9_ex <= ID_EX_OUT(123);
s10_ex <= ID_EX_OUT(122 downto 121);

s11_ex <= ID_EX_OUT(120);
s12_ex <= ID_EX_OUT(119 downto 117);

s13_ex <= ID_EX_OUT(116);

s14_ex <= ID_EX_OUT(115);
s15_ex <= ID_EX_OUT(114);
s16_ex <= ID_EX_OUT(113);
s17_ex <= ID_EX_OUT(112 downto 111);
s18_ex <= ID_EX_OUT(110);
s19_ex <= ID_EX_OUT(109);
s20_ex <= ID_EX_OUT(108);
s21_ex <= ID_EX_OUT(107 downto 106);

regA_ex <= ID_EX_OUT(105 downto 90);
regB_ex <= ID_EX_OUT(89 downto 74);
Imm_execute <= ID_EX_OUT(73 downto 58);
ea_ex <= ID_EX_OUT(57 downto 38);
pc_execute <= ID_EX_OUT(37 downto 6);
opA_ex <= ID_EX_OUT(5 downto 3);
opB_ex <= ID_EX_OUT(2 downto 0);

--EX/MEM

EX_MEM_IN <= ea_ex&s1_ex&s2_ex&s3_ex&s4_ex&s5_ex&s6_ex&s8_ex&s11_ex&s12_ex&s13_ex&s14_ex&s15_ex&s16_ex&s17_ex&s18_ex&s19_ex&s20_ex&s21_ex&ALUResult_s&ALUMul_s&pc_execute_out&opA_ex_out&opB_ex_out;
--Stage output signals

ea_mem <= EX_MEM_OUT(130 downto 111);
s1_mem_wb_fetch <= EX_MEM_OUT(110 downto 109);  
s2_mem_wb_fetch <= EX_MEM_OUT(108); 
s3_mem_wb_fetch <= EX_MEM_OUT(107); 
s4_mem_wb_fetch <= EX_MEM_OUT(106); 
s5_mem_wb_fetch <= EX_MEM_OUT(105);
s6_mem_wb_fetch <= EX_MEM_OUT(104 downto 103);
s8_mem_wb_fetch <= EX_MEM_OUT(102 downto 101);
s11_mem_wb_fetch <= EX_MEM_OUT(100);
s12_mem_wb_fetch <= EX_MEM_OUT(99 downto 97);
s13_mem_wb_fetch <= EX_MEM_OUT(96);
 s14_mem_wb_fetch <= EX_MEM_OUT(95);
 s15_mem_wb_fetch <= EX_MEM_OUT(94);
 s16_mem_wb_fetch <= EX_MEM_OUT(93);
 s17_mem_wb_fetch <= EX_MEM_OUT(92 downto 91);
 s18_mem_wb_fetch <= EX_MEM_OUT(90);
 s19_mem_wb_fetch <= EX_MEM_OUT(89);
 s20_mem_wb_fetch <= EX_MEM_OUT(88);
 s21_mem_wb_fetch <= EX_MEM_OUT(87 downto 86);

ALUResult_MEM <= EX_MEM_OUT(85 downto 70);
ALUMUL_MEM <= EX_MEM_OUT(69 downto 38);
pc_memory <= EX_MEM_OUT(37 downto 6);
opA_mem <= EX_MEM_OUT(5 downto 3);
opB_mem <= EX_MEM_OUT(2 downto 0);
process(rst, clk)
begin
if rst = '1' then

	
	
else
--IF/ID

--stage output signals


--control signals 32 + REGA 16 + REGB 16 + IMM 16 + EA 20 + PC 32 + opA 3 bits + opB 3 bits = 138 bits

---------------------------------------------------------------


	

--control signals 25 bits + ALUResult 16 bits + ALUMul 32 bits + PC 32 bits + opA 3 bits + opB 3 bits = 111 bits
--------------------------------------------------------------------------------------------
end if;


end process;


--pc_fetch , InstrSig  ==> 32+32 = 64
	IF_ID: Bufer GENERIC map(64) PORT map( 
		Clk => clk,
		Rst => rst,
		we => '1',
		d => IF_ID_IN,
		q => IF_ID_OUT
		);



	ID_EX: Bufer GENERIC map(138) PORT map( 
		Clk => clk,
		Rst => rst,
		we => '1',
		d => ID_EX_IN,
		q => ID_EX_OUT
		);




	EX_MEM: Bufer GENERIC map(131) PORT map( 
		Clk => clk,
		Rst => rst,
		we => '1',
		d => EX_MEM_IN,
		q => EX_MEM_OUT
		);
	
--Control Unit
CU: Control_Unit port map
(
	clk => clk,
 OpCode => Instr_decode(15 downto 11),
 INTR => Int,
 RST => rst,
 Sig_1 => s1,
 Sig_2 => s2,
 Sig_3 => s3,
 Sig_4 => s4,
 Sig_5 => s5,
 Sig_6 => s6,
 Sig_7 => s7,
 Sig_8 => s8,
 Sig_9 => s9,
 Sig_10 => s10,
 Sig_11 => s11,
 Sig_12 => s12,
 Sig_13 => s13,
 Sig_14 => s14,
 Sig_15 => s15,
 Sig_16 => s16,
 Sig_17 => s17,
 Sig_18 => s18,
 Sig_19 => s19,
 Sig_20 => s20,
 Sig_21 => s21,
 Bubble => '0',  --to be implmented
 zf => zeroF_s,
nf => negativeF_s,
 cf => carryF_s
 
 );

writePC1_32 <= "0000000000000000"&writePC1_s;
fmw : fetch_memory_wb port map(
	clk => clk,
	rst => rst,
	enable => '1',
	----
    	ea_reg => ea_mem,
    	pc_reg_ex => pc_memory,
    	pc_reg_fetch => pc_fetch,
    --	sp_reg => sp_sig,
	----
	-- using pc here too
	alu_result_in => ALUResult_MEM,
	mul_result_in => ALUMUL_MEM,
	writePC1 => writePC1_32,
	signal_5 => s5_mem_wb_fetch,
	----
	instr_26_24_in => opA_mem,
	instr_23_21_in => opB_mem,
	signal_18 => s18_mem_wb_fetch,
	----
	signal_1 => s1_mem_wb_fetch,
	signal_8 => s8_mem_wb_fetch,
	signal_3 => s3_mem_wb_fetch,
	signal_4 => s4_mem_wb_fetch,
	signal_6 => s6_mem_wb_fetch,
	signal_12 => s12_mem_wb_fetch,
	signal_17 => s17_mem_wb_fetch,
	signal_16 => s16_mem_wb_fetch,
	signal_19 => s19_mem_wb_fetch,
	instr_read => '1',  --to be implmented Hazard Unit !bubble
	----
	Instr => InstrSig,
	WriteData => data_wb,
	PC_out => pc_fetch,
	Rdst => wb_rdst,
	ex_mem_rdst => ex_mem_rdst_s,
	Instr_WB1_out => first_op_wb,
	Instr_WB2_out => second_op_wb,
	INPort => INPort,
	s11_mem_wb_fetch => s11_mem_wb_fetch,
	s13_mem_wb_fetch => s13_mem_wb_fetch,
	s20_mem_wb_fetch => s20_mem_wb_fetch,
	s14_mem_wb_fetch => s14_mem_wb_fetch,
	s15_mem_wb_fetch => s15_mem_wb_fetch,
	s2_mem_wb_fetch => s2_mem_wb_fetch,
	s13_wb => s13_decode,
  s11_wb => s11_decode,
  s20_wb => s20_decode
);


es: execute_stage port map (
    PC_in => pc_execute,
    regA => regA_ex,
    regB => regB_ex,
    imm => Imm_execute,
    instr26_24_in => opA_ex,
    instr23_21_in => opB_ex,
    ALUres_MEM => ALUResult_mem_s,
    ALUres_WB => ALUResult_wb_s,
    signal_7 => s7_ex,
    signal_9 => s9_ex,
    signal_10 => s10_ex,
    signal_H0 => "00",
    signal_H1 => "00",
    PC_out => pc_execute_out,
    outPort => OutPort,
    ALU_result => ALUResult_s,
    mulRes => ALUMul_s,
    zeroF => zeroF_s,
    carryF => carryF_s,
    negativeF => negativeF_s,
    writePC1 => writePC1_s,  --Unhandled 16 bits PC to 32 bits PC mapping triggered when jumping
    ID_EX_Rsrc => ID_EX_Rsrc_s,
    ID_EX_Rdst => ID_EX_Rdst_s,
    instr26_24_out => opA_ex_out,
    instr23_21_out => opB_ex_out
);

regFile : RegisterFile port map(
	clk => clk,
	rst => rst,
	e => '1',
     	FirstOpAdd => Instr_decode(10 downto 8), 
       	SecondOpAdd => Instr_decode(7 downto 5),
       	WriteRegAdd1 => first_op_wb,
       	WriteRegAdd2 => second_op_wb,
       	WriteRegData_32 => data_wb,
       	sig_13 => s13_decode,
       	sig_20 => s20_decode, 
       	sig_11 => s11_decode,
       	FirstOpData =>regA_s,
       	SecondOpData => regB_s
);



end architecture;