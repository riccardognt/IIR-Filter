vlib work_fm4

vcom -work ./work_fm4 ../tb/clk_gen_fm4.vhd
vcom -work ./work_fm4 ../tb/data_maker.vhd
vcom -work ./work_fm4 ../tb/data_sink_fm4.vhd

vlog -work ./work_fm4 ../netlist/myIIR2_fm4.v
vlog -work ./work_fm4 ../tb/tb_fir_fm4.v

vsim -L /eda/dk/nangate45/verilog/qsim2020.4 work_fm4.tb_fir_fm4 
vsim -L /eda/dk/nangate45/verilog/qsim2020.4 -sdftyp /tb_fir_fm4/UUT=../netlist/myIIR2_fm4.sdf work_fm4.tb_fir_fm4 
add wave sim:/tb_fir_fm4/*

vcd file ../vcd/myIIR2_syn.vcd
vcd add /tb_fir_fm4/UUT/*
run 20 us

#quit -sim

#quit 
