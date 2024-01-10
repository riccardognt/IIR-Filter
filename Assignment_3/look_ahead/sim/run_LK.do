
vlib WORK
vcom -work ./WORK ../src/ADD.vhd
vcom -work ./WORK ../src/FF.vhd
vcom -work ./WORK ../src/MULT.vhd
vcom -work ./WORK ../src/REG.vhd
vcom -work ./WORK ../src/REGNOEN.vhd
vcom -work ./WORK ../src/SUBTRACT.vhd
vcom -work ./WORK ../src/myIIR2.vhd

vcom -work ./WORK ../tb/clk_gen.vhd
vcom -work ./WORK ../tb/data_maker.vhd
vcom -work ./WORK ../tb/data_sink.vhd
vlog -work ./WORK ../tb/tb_fir.v

vsim WORK.tb_fir -t ns -voptargs=+acc
add wave -position insertpoint sim:/tb_fir/*
run 50 us

#quit -sim
#quit
