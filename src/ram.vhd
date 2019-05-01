library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
  use std.textio.all;
  use ieee.std_logic_textio.all;


entity ram is
  generic (address_line: Integer := 32; ram_width: Integer := 16);
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
  type    ram_t  is array( (2**address_line) - 1 downto 0) of word_t;

  -- file input_ram : text;

  -- function init return RamType is
  -- begin
  --     file_open(input_ram, "ram.txt",  read_mode);
  --     while not endfile(input_ram) loop
  --       readline(input_ram, v_ILINE);
  --       read(v_ILINE, v_ADD_TERM1);
  --       read(v_ILINE, v_SPACE);           -- read in the space character
  --       read(v_ILINE, v_ADD_TERM2);

  --       -- Pass the variable to a signal to allow the ripple-carry to use it
  --       r_ADD_TERM1 <= v_ADD_TERM1;
  --       r_ADD_TERM2 <= v_ADD_TERM2;
   
  --       wait for 60 ns;
   
  --       write(v_OLINE, w_SUM, right, c_WIDTH);
  --       writeline(file_RESULTS, v_OLINE);
  --     end loop;
  --     file_close(input_ram);

      
  -- end init;


  impure function ocram_ReadMemFile(FileName : string) return ram_t is
    file FileHandle       : text open read_mode is FileName;
    variable CurrentLine  : line;
    -- variable TempWord     : STD_LOGIC_VECTOR((div_ceil(ram_width'length, 4) * 4) - 1 downto 0);
    variable Result       : ram_t := (others => (others => '0'));
    variable l: line;
  begin
    for i in 0 to (2**address_line) - 1 loop
      write(l, i);
      writeline(output, l);
      exit when endfile(FileHandle);
      
      readline(FileHandle, CurrentLine);
      read(CurrentLine, Result(i));
      -- Result(i) := resize(TempWord, ram_width'length);
    end loop;
  
    return Result;
  end function;

  signal ram_data: ram_t := ocram_ReadMemFile("ram.txt");

begin

  -- // TODO: Ask about reading and writing in same clk

  ram_proc : process( clk )
  variable l: line;
  begin
    if rising_edge(clk) then
      -- Writing to memory
      if we = '1' then
        if is_sixteen = '1' then
          ram_data(to_integer(unsigned(address))) <= data_in(16-1 downto 0);
        else
          ram_data(to_integer(unsigned(address))) <= data_in(16-1 downto 0);
          ram_data(to_integer(unsigned(address)) + 1) <= data_in(32-1 downto 16);
        end if;
      end if;
      -- Reading from memory
      if re = '1' and we = '0' then
        if is_sixteen = '1' then 
          write(l, ram_data(0));
          writeline(output, l);
          data_out(16-1 downto 0) <= ram_data(to_integer(=(address)));
          data_out(32-1 downto 16) <= (others => '0');
        else
          data_out(16-1 downto 0) <= ram_data(to_integer(unsigned(address)));
          data_out(32-1 downto 16) <= ram_data(to_integer(unsigned(address)) +1);
        end if;
      end if;
    end if;
  end process; -- ram_proc

end architecture;