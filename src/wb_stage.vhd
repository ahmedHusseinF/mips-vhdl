Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wb_stage is 
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
	Rdst: out std_logic_vector(2 downto 0);
	Instr_WB1: out std_logic_vector(2 downto 0);
	Instr_WB2: out std_logic_vector(2 downto 0)
);
end wb_stage;


architecture wb_stage_imp of wb_stage is 
component MUX13 is 
port (
    Instr_WB1 : in std_logic_vector(2 downto 0);
    Instr_WB2 : in std_logic_vector(2 downto 0);
    signal_19 : in std_logic;
    toForwarding: out std_logic_vector(2 downto 0)
);
end component;
component DMUX1 is 
port (
    fromMem : in std_logic_vector(31 downto 0);
    signal_8 : in std_logic_vector(1 downto 0);
    wbData: out std_logic_vector(31 downto 0);
    writePC2: out std_logic_vector(31 downto 0)
);
end component;

component MUX0 is 
port (
    INPort : in std_logic_vector(15 downto 0);
    fromMem : in std_logic_vector(31 downto 0);
    ALUResult : in std_logic_vector(15 downto 0);
    ALUMulResult: in std_logic_vector(31 downto 0);
    signal_1 : in std_logic_vector(1 downto 0);
    regWrite: out std_logic_vector(31 downto 0)
);
end component;
Signal MUX13_MUX0: std_logic_vector(31 downto 0);
begin

	Instr_WB1 <= instr_26_24_in;
	Instr_WB2 <= instr_23_21_in;
M13: MUX13 port map (
	Instr_WB1 => instr_26_24_in,
	Instr_WB2 => instr_23_21_in,
	signal_19 => signal_19,
	toForwarding => Rdst
);

D1: DMUX1 port map (
	fromMem => mem_data_in,
	signal_8 => signal_8,
	wbData => MUX13_MUX0,
	writePC2 => WritePC2
);
M0: MUX0 port map (
	INPort => INport,
	fromMem => MUX13_MUX0,
	ALUResult => alu_result_in,
	ALUMulResult => mul_result_in,
	signal_1 => signal_1,
	regWrite => WriteData
);


end architecture wb_stage_imp;