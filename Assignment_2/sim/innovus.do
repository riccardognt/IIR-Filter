#quit -sim
vlib work_inn
vcom -work ./work_inn ../tb/clk_gen_fm4.vhd
vcom -work ./work_inn ../tb/data_maker_new.vhd
vcom -work ./work_inn ../tb/data_sink_fm4_innovus.vhd
vlog -work ./work_inn ../innovus/myIIR2_innovus.v
vlog -work ./work_inn ../tb/tb_fir_fm4_innovus.v
vsim -L /eda/dk/nangate45/verilog/qsim2020.4 work_inn.tb_fir_fm4_innovus
vsim -L /eda/dk/nangate45/verilog/qsim2020.4 -sdfmax /tb_fir_fm4_innovus/UUT=../innovus/myIIR2_innovus.sdf work_inn.tb_fir_fm4_innovus
add wave *
vcd file ../vcd/design.vcd
vcd add /tb_fir_fm4_innovus/UUT/*
run 2 ms
