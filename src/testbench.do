vsim -gui work.readinp
# vsim 
# Start time: 13:09:07 on Apr 21,2019
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading work.readinp(readinpimp)
add wave sim:/readinp/*
force -freeze sim:/readinp/Input 0 0
force -freeze sim:/readinp/clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/readinp/rst 1 0
force -freeze sim:/readinp/mode 0 0
run
force -freeze sim:/readinp/clk 0 0, 1 {50 ns} -r 100
run
force -freeze sim:/readinp/rst 0 0
force -freeze sim:/readinp/Input 2 0
run
force -freeze sim:/readinp/Input 5 0
run
force -freeze sim:/readinp/mode 1 0
force -freeze sim:/readinp/Input 1 0
run
force -freeze sim:/readinp/Input 2 0
run
force -freeze sim:/readinp/Input 3 0
run
force -freeze sim:/readinp/Input 27 0
run