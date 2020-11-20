vlib cdc_lib

vcom ../rtl/toggle_sync.vhd -2008 -work cdc_lib
vcom ../tb/tb_toggle_sync.vhd -2008 -work cdc_lib

vsim cdc_lib.tb_toggle_sync
add wave sim:/tb_toggle_sync/uut/*
run -all
