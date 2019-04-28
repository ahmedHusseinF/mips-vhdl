library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use STD.textio.all;
  use ieee.std_logic_textio.all;

entity ram is
  generic (address_line: Integer := 20; ram_width: Integer := 16);
  port (
    clk: in std_logic;
    we: in std_logic;
    address: in std_logic_vector(address_line-1 downto 0);
    data_in_out: inout std_logic_vector(ram_width-1 downto 0)
  );
end ram;



architecture ram_wiring of ram is

  type RamType is array(0 to (2**address_line)-1) of std_logic_vector(ram_width-1 downto 0);
  file input_ram : text;

  function init return RamType is
  begin
      file_open(input_ram, "ram.txt",  read_mode);
      while not endfile(input_ram) loop
        readline(input_ram, v_ILINE);
        read(v_ILINE, v_ADD_TERM1);
        read(v_ILINE, v_SPACE);           -- read in the space character
        read(v_ILINE, v_ADD_TERM2);

        -- Pass the variable to a signal to allow the ripple-carry to use it
        r_ADD_TERM1 <= v_ADD_TERM1;
        r_ADD_TERM2 <= v_ADD_TERM2;
   
        wait for 60 ns;
   
        write(v_OLINE, w_SUM, right, c_WIDTH);
        writeline(file_RESULTS, v_OLINE);
      end loop;
      file_close(input_ram);

      
  end function init;

  signal ram_data: RamType := init;

begin

  ram_proc : process( clk )
  begin
    if rising_edge(clk) and we = '1' then
      ram_data(to_integer(unsigned(address))) <= data_in_out;
    end if;
  end process; -- ram_proc

  data_in_out <= ram_data(to_integer(unsigned(address)));

end architecture;