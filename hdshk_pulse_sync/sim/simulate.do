vlib cdc_lib

vcom ../../ff_sync/rtl/ff_sync.vhd -2008 -work cdc_lib
vcom ../rtl/hdshk_pulse_sync.vhd -2008 -work cdc_lib
vcom ../tb/tb_hdshk_pulse_sync.vhd -2008 -work cdc_lib

vsim cdc_lib.tb_hdshk_pulse_sync
add wave sim:/tb_hdshk_pulse_sync/uut/*
run -all
