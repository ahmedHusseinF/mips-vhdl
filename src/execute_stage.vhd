Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute_stage is 
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
end entity;

Architecture Ex_Implment of execute_stage is
--ALU
component ALU is 
port (
    operandA : in std_logic_vector(15 downto 0);
    operandB : in std_logic_vector(15 downto 0);
    signal_7 : in std_logic_vector(3 downto 0);
    result: out std_logic_vector(15 downto 0);
    mulRes: out std_logic_vector(31 downto 0);
    writeC: out std_logic;
    writeN: out std_logic;
    writeZ: out std_logic
);
end component;

--DMUX0
component DMUX0 is 
port (
    regA : in std_logic_vector(15 downto 0);
    signal_10 : in std_logic_vector(1 downto 0);
    writePC1: out std_logic_vector(15 downto 0);
    outPort: out std_logic_vector(15 downto 0);
    toMUX11: out std_logic_vector(15 downto 0)
);
end component;

--MUX1
component MUX1 is 
port (
    regB : in std_logic_vector(15 downto 0);
    imm : in std_logic_vector(15 downto 0);
    signal_9 : in std_logic;
    toMUX10: out std_logic_vector(15 downto 0)
);
end component;

--MUX10
component MUX10 is 
port (
    regBMUX1 : in std_logic_vector(15 downto 0);
    ALUres_MEM : in std_logic_vector(15 downto 0);
    ALUres_WB : in std_logic_vector(15 downto 0);
    signal_H0 : in std_logic_vector(1 downto 0);
    toALU: out std_logic_vector(15 downto 0)
);
end component;

--MUX11
component MUX11 is 
port (
    regADMUX0 : in std_logic_vector(15 downto 0);
    ALUres_MEM : in std_logic_vector(15 downto 0);
    ALUres_WB : in std_logic_vector(15 downto 0);
    signal_H1 : in std_logic_vector(1 downto 0);
    toALU: out std_logic_vector(15 downto 0)
);
end component;

signal opA : std_logic_vector(15 downto 0);
signal opB : std_logic_vector(15 downto 0);
signal dmux0_mux11 : std_logic_vector(15 downto 0);
signal mux1_mux10 : std_logic_vector(15 downto 0);

begin
my_alu : ALU port map(opA, opB, signal_7, ALU_result, mulRes, carryF, negativeF, zeroF);
m1 : MUX11 port map(dmux0_mux11, ALUres_MEM, ALUres_WB, signal_H1, opA);
m2 : MUX10 port map(mux1_mux10, ALUres_MEM, ALUres_WB, signal_H0, opB);
d1 : DMUX0 port map(regA, signal_10, writePC1, outPort, dmux0_mux11);
m3 : MUX1 port map(regB, imm, signal_9, mux1_mux10);
PC_out <= PC_in;
ID_EX_Rsrc <= instr26_24_in;
ID_EX_Rdst <= instr23_21_in;
instr26_24_out <= instr26_24_in;
instr23_21_out <= instr23_21_in;
end architecture;