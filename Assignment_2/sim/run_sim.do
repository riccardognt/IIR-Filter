vlib work

vcom -work ./work ../src/ADD.vhd
vcom -work ./work ../src/FF.vhd
vcom -work ./work ../src/MULT.vhd
vcom -work ./work ../src/REG.vhd
vcom -work ./work ../src/REGNOEN.vhd
vcom -work ./work ../src/SUBTRACT.vhd
vcom -work ./work ../src/myIIR2.vhd

vcom -work ./work ../tb/clk_gen.vhd
vcom -work ./work ../tb/data_maker_new.vhd
vcom -work ./work ../tb/data_sink.vhd
vlog -work ./work ../tb/tb_fir.v

vsim work.tb_fir -t ns -voptargs=+acc
add wave -position insertpoint sim:/tb_fir/*

run 50 us

#quit -sim
#quit

