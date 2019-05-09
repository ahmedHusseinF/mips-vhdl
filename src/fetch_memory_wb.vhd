Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_memory_wb is 
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
	Instr_WB1: out std_logic_vector(2 downto 0);
	Instr_WB2: out std_logic_vector(2 downto 0);
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
end fetch_memory_wb;

Architecture fmw_Implment of fetch_memory_wb is
	

component memory_stage is
  generic (reg_width: Integer := 16;address_line: Integer := 20; ram_width: Integer := 16);
  port (
    clk: in std_logic;
	----
    ea_reg: in std_logic_vector(address_line-1 downto 0);
    pc_reg_ex: in std_logic_vector(32-1 downto 0);
    pc_reg_fetch: in std_logic_vector(32-1 downto 0); 
    sp_reg: in std_logic_vector(32-1 downto 0);
	signal_6: in std_logic_vector(2-1 downto 0);
	----
	-- using pc here too
	alu_result_in: in std_logic_vector(16-1 downto 0);
	alu_result_out: out std_logic_vector(16-1 downto 0);
	mul_result_in: in std_logic_vector(32-1 downto 0);
	mul_result_out: out std_logic_vector(32-1 downto 0);
	signal_5: in std_logic;
	----
	instr_26_24_in: in std_logic_vector(2 downto 0);
	instr_23_21_in: in std_logic_vector(2 downto 0);
	signal_18: in std_logic;
	instr_26_24_out: out std_logic_vector(2 downto 0);
	instr_23_21_out: out std_logic_vector(2 downto 0);
	ex_mem_rdst: out std_logic_vector(2 downto 0);
	----
	signal_3: in std_logic;
	signal_4: in std_logic;
	signal_16: in std_logic;
	instr_read: in std_logic;
	mem_data_out: out std_logic_vector(32-1 downto 0)
  );
end component;
component wb_stage is 
port (
	alu_result_in: in std_logic_vector(16-1 downto 0);
	mul_result_in: in std_logic_vector(32-1 downto 0);
	----
	instr_26_24_in: in std_logic_vector(2 downto 0);
	instr_23_21_in: in std_logic_vector(2 downto 0);
	----
	mem_data_in: in std_logic_vector(32-1 downto 0);
	----
	INPort : in std_logic_vector(15 downto 0);
	----
	signal_1 : in std_logic_vector(1 downto 0);
	signal_8 : in std_logic_vector(1 downto 0);
	signal_19 : in std_logic;
	WriteData: out std_logic_vector(31 downto 0);
	WritePC2: out std_logic_vector(31 downto 0);
	Instr: out std_logic_vector(31 downto 0);
	Rdst: out std_logic_vector(2 downto 0);
	Instr_WB1: out std_logic_vector(2 downto 0);
	Instr_WB2: out std_logic_vector(2 downto 0)
);
end component;

component Bufer IS
GENERIC ( n : integer := 16);
PORT( 
Clk,Rst,we : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0)
);
			
END component;


component pc is 
port ( clk,rst,enable : in std_logic;
 signal_12 : in std_logic_vector(2 DOWNTO 0);
 signal_17 : in std_logic_vector(1 DOWNTO 0);
 writepc1 : IN std_logic_vector(31 DOWNTO 0);
 writepc2 : IN std_logic_vector(31 DOWNTO 0);
 OP : out std_logic_vector(31 DOWNTO 0));
end component;

component sp is 
port ( clk,rst,enable : in std_logic;
 signal_14 : in std_logic;
 OUTP: out std_logic_vector(31 DOWNTO 0);
 signal_15,signal_2 : in std_logic);
 
end component;

signal memory_wb_alu: std_logic_vector(15 downto 0);
signal memory_wb_mul: std_logic_vector(31 downto 0);
signal instr_26_24_mem_wb: std_logic_vector(2 downto 0);
signal instr_23_21_mem_wb: std_logic_vector(2 downto 0);
signal mem_wb_data: std_logic_vector(31 downto 0);
signal W_PC2: std_logic_vector(32-1 downto 0);
signal sp_sig: std_logic_vector(31 downto 0); --to be implmented stack 
signal sp_s15: std_logic;
signal sp_s2: std_logic;


--Intermediate signals
signal ALUResult_wb: std_logic_vector(15 downto 0);
signal ALUMul_wb: std_logic_vector(31 downto 0);
signal instr_m_wb1: std_logic_vector(2 downto 0);
signal instr_m_wb2: std_logic_vector(2 downto 0);
signal s1_wb: std_logic_vector(1 downto 0);
signal s8_wb: std_logic_vector(1 downto 0);
signal s19_wb: std_logic;
signal Instr_wb_1: std_logic_vector(2 downto 0);
signal	Instr_wb_2: std_logic_vector(2 downto 0);
signal mem_data_wb_out : std_logic_vector(31 downto 0);



--Buffer
signal MEM_WB_IN: std_logic_vector(93 downto 0);
signal MEM_WB_OUT: std_logic_vector(93 downto 0);

begin
m: memory_stage port map(
	clk => clk,
	----
    	ea_reg => ea_reg,
    	pc_reg_ex => pc_reg_ex,
    	pc_reg_fetch => pc_reg_fetch, 
    	sp_reg => sp_sig,
	signal_6 => signal_6,
	----
	-- using pc here too
	alu_result_in => alu_result_in,
	alu_result_out => memory_wb_alu,
	mul_result_in => mul_result_in,
	mul_result_out => memory_wb_mul,
	signal_5 => signal_5,
	----
	instr_26_24_in => instr_26_24_in,
	instr_23_21_in => instr_23_21_in,
	signal_18 => signal_18, 
	instr_26_24_out => instr_26_24_mem_wb,
	instr_23_21_out => instr_23_21_mem_wb,
	ex_mem_rdst => ex_mem_rdst,
	----
	signal_3 => signal_3,
	signal_4 => signal_4,
	signal_16 => signal_16,
	instr_read => instr_read,
	mem_data_out => mem_wb_data
);

wb: wb_stage port map (
	alu_result_in => ALUResult_wb,
	mul_result_in =>ALUMul_wb ,
	----
	instr_26_24_in => Instr_wb_1,
	instr_23_21_in => Instr_wb_2,
	----
	mem_data_in => mem_data_wb_out,
	----
	INPort => INPort,
	----
	signal_1 => signal_1,
	signal_8 => signal_8,
	signal_19 => signal_19,
	WriteData => WriteData,
	WritePC2 => W_PC2,
	Instr => Instr,
	Rdst => Rdst,
	Instr_WB1 => Instr_wb_1,
	Instr_WB2 => Instr_wb_2
);

p: pc port map ( clk => clk,
		 rst => rst,
		enable => enable,
 		signal_12 => signal_12,
 		signal_17 => signal_17,
 		writepc1 => writePC1,
 		writepc2 => W_PC2,
 		OP => PC_out
);

sp1: sp port map ( 
	clk => clk,
	rst => rst,
	enable => '1',
 signal_14 => s14_mem_wb_fetch,
 OUTP => sp_sig,
 signal_15 => sp_s15, --s15_mem_wb_fetch,
 signal_2 => sp_s2 --s2_mem_wb_fetch
);




--MEM/WB
MEM_WB_IN <= signal_1&signal_8&signal_19&s11_mem_wb_fetch&s13_mem_wb_fetch&s20_mem_wb_fetch&memory_wb_alu&mem_wb_data&memory_wb_mul&instr_26_24_mem_wb&instr_23_21_mem_wb;
--stage output signals
s1_wb <= MEM_WB_OUT(93 downto 92);
s8_wb <= MEM_WB_OUT(91 downto 90);
s19_wb <= MEM_WB_OUT(89);
s11_wb <= MEM_WB_OUT(88);
s13_wb <= MEM_WB_OUT(87);
s20_wb <= MEM_WB_OUT(86);
mem_data_wb_out <= MEM_WB_OUT(85 downto 54);
ALUResult_wb <= MEM_WB_OUT(53 downto 38);
ALUMul_wb <= MEM_WB_OUT(37 downto 6);
Instr_wb_1 <= MEM_WB_OUT(5 downto 3); 
Instr_wb_2 <= MEM_WB_OUT(2 downto 0);



--signals 8 bits + mem_data 32 bits + ALUResult_out 16 bits + ALUMul_out 32 bits+ opA 3 bits + opB 3 bits = 94 bits
	MEM_WB: Bufer GENERIC map(94) PORT map( 
		Clk => clk,
		Rst => rst,
		we => '1',
		d => MEM_WB_IN,
		q => MEM_WB_OUT
		);


process(clk)
begin
if rising_edge(clk) then
	if(s15_mem_wb_fetch='1') then
	sp_s15 <= s15_mem_wb_fetch;
	sp_s2 <= '0';
	else
	sp_s15 <= '0';
	sp_s2 <= '0';
	end if;
	elsif falling_edge(clk) then
		sp_s2 <= s2_mem_wb_fetch;
		sp_s15 <= '0';
	end if;		
end process;


end architecture fmw_Implment;
