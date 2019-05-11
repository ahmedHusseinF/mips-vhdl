onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/rst
add wave -noupdate /cpu/pc_fetch
add wave -noupdate /cpu/instrSig
add wave -noupdate /cpu/pc_decode
add wave -noupdate /cpu/Instr_decode
add wave -noupdate /cpu/s1
add wave -noupdate /cpu/s2
add wave -noupdate /cpu/s3
add wave -noupdate /cpu/s4
add wave -noupdate /cpu/s5
add wave -noupdate /cpu/s6
add wave -noupdate /cpu/s7
add wave -noupdate /cpu/s8
add wave -noupdate /cpu/s9
add wave -noupdate /cpu/s10
add wave -noupdate /cpu/s11
add wave -noupdate /cpu/s12
add wave -noupdate /cpu/s13
add wave -noupdate /cpu/s14
add wave -noupdate /cpu/s15
add wave -noupdate /cpu/s16
add wave -noupdate /cpu/s17
add wave -noupdate /cpu/s18
add wave -noupdate /cpu/s19
add wave -noupdate /cpu/s20
add wave -noupdate /cpu/s21
add wave -noupdate /cpu/s7_ex
add wave -noupdate /cpu/s9_ex
add wave -noupdate /cpu/s10_ex
add wave -noupdate /cpu/regA_ex
add wave -noupdate /cpu/regB_ex
add wave -noupdate /cpu/Imm_execute
add wave -noupdate /cpu/ea_ex
add wave -noupdate /cpu/pc_execute
add wave -noupdate /cpu/opA_ex
add wave -noupdate /cpu/opB_ex
add wave -noupdate /cpu/regFile/M_in1
add wave -noupdate /cpu/regFile/M_in2
add wave -noupdate /cpu/regFile/M_in3
add wave -noupdate /cpu/regFile/M_in4
add wave -noupdate /cpu/regFile/M_in5
add wave -noupdate /cpu/regFile/M_in6
add wave -noupdate /cpu/regFile/M_in7
add wave -noupdate /cpu/regFile/M_in8
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {299 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {4726 ns}
