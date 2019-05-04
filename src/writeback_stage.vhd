

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity writeback_stage is
  port (
    clk: in std_logic;
	----
	alu_result_in: in std_logic_vector(32-1 downto 0);
	mul_result_in: in std_logic_vector(32-1 downto 0);
	alu_result_out: out std_logic_vector(32-1 downto 0);
	mul_result_out: out std_logic_vector(32-1 downto 0);
	----
	signal_8: in std_logic_vector(2-1 downto 0);
	mem_writedata: in std_logic_vector(32-1 downto 0);
	write_pc2: out std_logic_vector(32-1 downto 0);
	instr_31_0: out std_logic_vector(32-1 downto 0);
	weird_signal: out std_logic_vector(32-1 downto 0); -- wtf is this signal, going from 00 demux0 to 01 mux0
	----
	instr_26_24: in std_logic_vector(3-1 downto 0);
	instr_23_21: in std_logic_vector(3-1 downto 0);
	r_dst: out std_logic_vector(3-1 downto 0);
	signal_18: in std_logic;
	instr_wb_1: out std_logic_vector(3-1 downto 0);
	instr_wb_2: out std_logic_vector(3-1 downto 0)
  );
end writeback_stage;


architecture writeback_stage_arch of writeback_stage is

begin

	process (clk)
	begin

		if rising_edge(clk) then
		----
			if signal_18 = '0' then
				r_dst <= instr_26_24;
			else 
				r_dst <= instr_23_21;
			end if;
			instr_wb_1 <= instr_23_21;
			instr_wb_2 <= instr_26_24;
		----
			alu_result_out <= alu_result_in;
			mul_result_out <= mul_result_in;
		----
			if signal_8 = "00" then
				weird_signal <= mem_writedata;
			elsif signal_8 = "01" then
				write_pc2 <= mem_writedata;
			elsif signal_8 = "10" then
				instr_31_0 <= mem_writedata;
			end if;
		----
		end if;
		
	end process;


end architecture;