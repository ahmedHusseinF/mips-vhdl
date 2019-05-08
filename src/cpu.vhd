library ieee ;
  use ieee.std_logic_1164.all ;
  use ieee.numeric_std.all ;

entity cpu is
  port (
	clk: in std_logic;
	rst: in std_logic;
	Int: in std_logic;
	INPort: in std_logic_vector(15 downto 0);
	OutPort: in std_logic_vector(15 downto 0)
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
	--15-----0
	--31-----16
	--op code 15 - 11
	--1st operand 10 - 8
	--2nd operand 7 - 5
	--Imm 31 - 16
	--EA 4 - 0 + 31 - 21
signal instrSig:std_logic_vector(31 downto 0);
signal first_op_wb: std_logic_vector(2 downto 0);
signal second_op_wb:std_logic_vector(2 downto 0);
signal data_wb:std_logic_vector(31 downto 0);
begin

  -- to implement

fmw : fetch_memory_wb port map(
	clk => clk,
	rst => rst,
	enable => '1',
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
	Instr => InstrSig,
	WriteData => data_wb,
	PC_out: out std_logic_vector(31 downto 0);
	Rdst: out std_logic_vector(2 downto 0);
	ex_mem_rdst: out std_logic_vector(2 downto 0);
	Instr_WB1 => first_op_wb,
	Instr_WB2 => second_op_wb,
	INPort: in std_logic_vector(15 downto 0)
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

       sig_13:in std_logic;
       sig_20:in std_logic; --WriteInTwoReg signal
       sig_11:in std_logic;

       FirstOpData:out std_logic_vector(15 downto 0);
       SecondOpData:out std_logic_vector(15 downto 0) 
);
end architecture;