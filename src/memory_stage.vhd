
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity memory_stage is
  generic (reg_width: Integer := 16;address_line: Integer := 20; ram_width: Integer := 16);
  port (
    clk: in std_logic;
	----
    ea_reg: in std_logic_vector(address_line-1 downto 0);
    pc_reg: in std_logic_vector(32-1 downto 0);
    sp_reg: in std_logic_vector(32-1 downto 0);
	address_selection: in std_logic_vector(1 downto 0);
	----
	-- using pc here too
	alu_result_in: in std_logic_vector(31 downto 0);
	alu_result_out: out std_logic_vector(31 downto 0);
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
	mem_data_out: out std_logic_vector(32-1 downto 0)
  );
end memory_stage;


architecture mem_stage_arch of memory_stage is

	signal ram_address: std_logic_vector(address_line-1 downto 0);
	signal write_enable_internal: std_logic;
	signal read_enable_internal: std_logic;
	signal is_sixteen_internal: std_logic;
	signal data_in_internal: std_logic_vector(32-1 downto 0);
	signal data_out_internal: std_logic_vector(32-1 downto 0);
begin
	 ram_call: entity work.ram port map (
										clk => clk,
	                                    we => write_enable_internal,
	                                    re => read_enable_internal,
	                                    is_sixteen => is_sixteen_internal,
	                                    address => ram_address,
	                                    data_in => data_in_internal,
	                                    data_out => data_out_internal
									);

	process (clk)
	begin

		if rising_edge(clk) then
			----
			if address_selection = "00" then
				ram_address <= sp_reg(20-1 downto 0); -- Stack Pointer
			elsif address_selection = "01" then
				ram_address <= std_logic_vector(shift_left(unsigned(ea_reg), 2)); -- shift extended for EA
			elsif address_selection = "10" then
				ram_address <= pc_reg(20-1 downto 0); -- PC 
			end if;
			write_enable_internal <= signal_3;
			read_enable_internal <= signal_4;
			is_sixteen_internal <= signal_16;
			if signal_5 = '0' then
					data_in_internal <= pc_reg;
			else
					data_in_internal <= alu_result_in;
			end if;
			mem_data_out <= data_out_internal; -- to output
			----
			instr_26_24_out <= instr_26_24_in;
			instr_23_21_out <= instr_23_21_in;
			if signal_18 = '0' then
				ex_mem_rdst <= instr_26_24_in;
			else
				ex_mem_rdst <= instr_23_21_in;
			end if;
			----
			alu_result_out <= alu_result_in;
		end if;

	end process;


end architecture;