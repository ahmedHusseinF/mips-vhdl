onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/rst
add wave -noupdate /cpu/Int
add wave -noupdate /cpu/INPort
add wave -noupdate /cpu/OutPort
add wave -noupdate /cpu/CU/OpCode
add wave -noupdate /cpu/fmw/address_line
add wave -noupdate /cpu/fmw/pc_reg_fetch
add wave -noupdate /cpu/fmw/Instr
add wave -noupdate /cpu/fmw/mem_data_wb_out
add wave -noupdate /cpu/es/regA
add wave -noupdate /cpu/es/regB
add wave -noupdate /cpu/es/ALU_result
add wave -noupdate /cpu/es/mulRes
add wave -noupdate /cpu/IF_ID/d
add wave -noupdate /cpu/IF_ID/q
add wave -noupdate /cpu/ID_EX/d
add wave -noupdate /cpu/ID_EX/q
add wave -noupdate /cpu/EX_MEM/d
add wave -noupdate /cpu/EX_MEM/q
add wave -noupdate /cpu/fmw/MEM_WB_IN
add wave -noupdate /cpu/fmw/MEM_WB_OUT
add wave -noupdate /cpu/regFile/M_in1
add wave -noupdate /cpu/regFile/M_in2
add wave -noupdate /cpu/regFile/M_in3
add wave -noupdate /cpu/regFile/M_in4
add wave -noupdate /cpu/regFile/M_in5
add wave -noupdate /cpu/regFile/M_in6
add wave -noupdate /cpu/regFile/M_in7
add wave -noupdate /cpu/regFile/M_in8
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {300 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 173
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {704 ns}
mem load -filltype value -filldata 0800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(0)
mem load -filltype value -filldata 100 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(1)
mem load -filltype value -filldata 1000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(1)
mem load -filltype value -filldata 1800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(2)
mem load -filltype value -filldata 200 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(3)
mem load -filltype value -filldata 2000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(3)
mem load -filltype value -filldata 2800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(4)
mem load -filltype value -filldata 3000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(5)
mem load -filltype value -filldata 3800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(6)
mem load -filltype value -filldata 4000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(7)
mem load -filltype value -filldata 4800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(8)
mem load -filltype value -filldata 5000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(9)
mem load -filltype value -filldata 5800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(10)
mem load -filltype value -filldata 6000 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(11)
mem load -filltype value -filldata 6800 -fillradix hexadecimal /cpu/fmw/m/ram_call/RamData(12)
