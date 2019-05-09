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
    	sp_reg: in std_logic_vector(32-1 downto 0);
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
	Instr_WB1: out std_logic_vector(2 downto 0);
	Instr_WB2: out std_logic_vector(2 downto 0);
	INPort: in std_logic_vector(15 downto 0)
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
signal pc_execute: std_logic_vector(31 downto 0);
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
signal Instr_op1_ex_mem: std_logic_vector(2 downto 0); --to be implmented Buffer
signal Instr_op2_ex_mem: std_logic_vector(2 downto 0); --to be implmented Buffer
signal PC_decode: std_logic_vector(31 downto 0); --to be implmented Buffer
signal wb_rdst: std_logic_vector(2 downto 0); --to be implmented FU
signal ex_mem_rdst_s: std_logic_vector(2 downto 0); --to be implmented FU
signal sp_sig: std_logic_vector(31 downto 0); --to be implmented stack 
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
 
begin


--Control Unit
CU: Control_Unit port map
(
 OpCode => InstrSig(15 downto 11),
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
 Bubble => '0'  --to be implmented
 );

ea_20 <= InstrSig(4 downto 0)&InstrSig(31 downto 17);
writePC1_32 <= "0000000000000000"&writePC1_s;
fmw : fetch_memory_wb port map(
	clk => clk,
	rst => rst,
	enable => '1',
	----
    	ea_reg => ea_20,
    	pc_reg_ex => pc_execute,
    	pc_reg_fetch => pc_fetch,
    	sp_reg => sp_sig,
	----
	-- using pc here too
	alu_result_in => ALUResult_s,
	mul_result_in => ALUMul_s,
	writePC1 => writePC1_32,
	signal_5 => s5,
	----
	instr_26_24_in => Instr_op1_ex_mem,
	instr_23_21_in => Instr_op2_ex_mem,
	signal_18 => s18,
	----
	signal_1 => s1,
	signal_8 => s8,
	signal_3 => s3,
	signal_4 => s4,
	signal_6 => s6,
	signal_12 => s12,
	signal_17 => s17,
	signal_16 => s16,
	signal_19 => s19,
	instr_read => '1',  --to be implmented Hazard Unit !bubble
	----
	Instr => InstrSig,
	WriteData => data_wb,
	PC_out => pc_fetch,
	Rdst => wb_rdst,
	ex_mem_rdst => ex_mem_rdst_s,
	Instr_WB1 => first_op_wb,
	Instr_WB2 => second_op_wb,
	INPort => INPort
);


es: execute_stage port map (
    PC_in => pc_fetch,
    regA => regA_s,
    regB => regB_s,
    imm => InstrSig(31 downto 16),
    instr26_24_in => InstrSig(10 downto 8),
    instr23_21_in => InstrSig(7 downto 5),
    ALUres_MEM => ALUResult_mem_s,
    ALUres_WB => ALUResult_wb_s,
    signal_7 => s7,
    signal_9 => s9,
    signal_10 => s10,
    signal_H0 => "00",
    signal_H1 => "00",
    PC_out => pc_execute,
    outPort => OutPort,
    ALU_result => ALUResult_s,
    mulRes => ALUMul_s,
    zeroF => zeroF_s,
    carryF => carryF_s,
    negativeF => negativeF_s,
    writePC1 => writePC1_s,  --Unhandled 16 bits PC to 32 bits PC mapping triggered when jumping
    ID_EX_Rsrc => ID_EX_Rsrc_s,
    ID_EX_Rdst => ID_EX_Rdst_s,
    instr26_24_out => Instr_op1_ex_mem,
    instr23_21_out => Instr_op1_ex_mem
);

regFile : RegisterFile port map(
	clk => clk,
	rst => rst,
	e => '1',
     	FirstOpAdd => InstrSig(10 downto 8), 
       	SecondOpAdd => InstrSig(7 downto 5),
       	WriteRegAdd1 => first_op_wb,
       	WriteRegAdd2 => second_op_wb,
       	WriteRegData_32 => data_wb,
       	sig_13 => s13,
       	sig_20 => s20, 
       	sig_11 => s11,
       	FirstOpData =>regA_s,
       	SecondOpData => regB_s
);

end architecture;