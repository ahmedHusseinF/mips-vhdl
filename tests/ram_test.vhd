library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_test is
  generic (n: integer := 16);
end ram_test;


architecture ram_test_arch of ram_test is

  signal address_test: std_logic_vector(32-1 downto 0);
  signal data_in_test: std_logic_vector(32-1 downto 0);
  signal data_out_test: std_logic_vector(32-1 downto 0);
  signal we_test: std_logic;
  signal re_test: std_logic;
  signal is_sixteen_test: std_logic;

  signal clk_test: std_logic;
begin

  ram_call: entity work.ram port map (clk => clk_test,
                                      we => we_test,
                                      re => re_test,
                                      is_sixteen => is_sixteen_test,
                                      address => address_test,
                                      data_in => data_in_test,
                                      data_out => data_out_test);

  -- ClockWork, normally period is 10ns
  process
  begin
    clk_test <= '0';
    wait for 5 ns;
    clk_test <= '1';
    wait for 5 ns;
  end process;

  -- My tests

  process
  begin

  is_sixteen_test <= '1';
  re_test <= '1';
  we_test <= '0';
  address_test <= "00000000000000000000000000000001";
  wait for 10 ns;
  assert (data_out_test = "1000100010001000") report "didn't reset correctly" severity error;

  report "Finish";

  wait;

  end process;


end ram_test_arch; -- ImpTestBench