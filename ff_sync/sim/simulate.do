vlib cdc_lib

vcom ../rtl/ff_sync.vhd -work cdc_lib -2008
vcom ../tb/tb_ff_sync.vhd -work cdc_lib -2008

vsim cdc_lib.tb_ff_sync
add wave sim:/tb_ff_sync/uut/*

run -all
