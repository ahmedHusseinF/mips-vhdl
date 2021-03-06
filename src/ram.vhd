library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
  use std.textio.all;
  use ieee.std_logic_textio.all;


entity ram is
  generic (address_line: Integer := 20; ram_width: Integer := 16);
  port (
    clk: in std_logic;
    we: in std_logic;
    re: in std_logic;
    is_sixteen: in std_logic;
    address: in std_logic_vector(address_line-1 downto 0);
    data_in:  in std_logic_vector(32-1 downto 0);
    data_out: out std_logic_vector(32-1 downto 0)
  );
end ram;



architecture ram_wiring of ram is


  subtype word_t is std_logic_vector(ram_width - 1 downto 0);
  type    ram_t  is array( 0 to (2**address_line) - 1) of word_t;


  impure function ocram_ReadMemFile(FileName : string) return ram_t is
    file FileHandle       : text open read_mode is FileName;
    variable CurrentLine  : line;
    variable Result       : ram_t := (others => (others => '0'));
    variable l: line;
  begin
    for i in 0 to (2**address_line) - 1 loop
      --write(l, i);
      --writeline(output, l);
      exit when endfile(FileHandle);
      
      readline(FileHandle, CurrentLine);
      read(CurrentLine, Result(i));
    end loop;
  
    return Result;
  end function;

  
  signal RamData: ram_t := ocram_ReadMemFile("ram.txt"); --(others => (others=>'0'));

begin

  -- // TODO: Ask about reading and writing in same clk

  ram_proc : process( clk )
  variable l: line;
  begin
    if rising_edge(clk) then
      -- Writing to memory on rising_edge
      if we = '1' then
        if is_sixteen = '1' then
          RamData(to_integer(unsigned(address))) <= data_in(16-1 downto 0);
        else
          RamData(to_integer(unsigned(address))) <= data_in(16-1 downto 0);
          RamData(to_integer(unsigned(address)) + 1) <= data_in(32-1 downto 16);
        end if;
      end if;
    end if;

	if falling_edge(clk) then
		-- Reading from memory on falling edge
		if re = '1' then
        if is_sixteen = '1' then 
          data_out(16-1 downto 0) <= RamData(to_integer(unsigned(address)));
          data_out(32-1 downto 16) <= (others => '0');
        else
          data_out(16-1 downto 0) <= RamData(to_integer(unsigned(address)));
          data_out(32-1 downto 16) <= RamData(to_integer(unsigned(address)) +1);
        end if;
      end if;
	end if;
  end process; -- ram_proc

end architecture;