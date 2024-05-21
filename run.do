vlib work

vlog -coveropt 3 +cover +acc {Codes\package\shared_pkg.sv}
vlog -coveropt 3 +cover +acc {Codes\package\transaction_pkg.sv}
vlog -coveropt 3 +cover +acc {Codes\package\coverage_pkg.sv}
vlog -coveropt 3 +cover +acc {Codes\package\scoreboard_pkg.sv}

vlog -coveropt 3 +cover +acc {Codes\interface\FIFO_interface.SV}

# adding "+define+SIM" to enable assertion if not then don't forget to comment <add wave <assertion label>>
vlog +define+SIM -coveropt 3 +cover +acc {Codes\design\FIFO.sv}
#vlog -coveropt 3 +cover +acc {Codes\design\FIFO.sv}

vlog -coveropt 3 +cover +acc {Codes\reference\FIFO_ref.sv}

vlog -coveropt 3 +cover +acc {Codes\monitor\monitor.sv}
vlog -coveropt 3 +cover +acc {Codes\testbench\testbench.sv}
# this module to test the refrence model
#vlog -coveropt 3 +cover +acc {Codes\testbench\ref_tb.sv}

vlog -coveropt 3 +cover +acc {Codes\top\top.sv}

vsim -voptargs=+acc work.top -cover
add wave *
add wave -position 1 -color white sim:/top/F_if/clk
add wave -position 2 -radix unsigned sim:/top/F_if/rst_n
add wave -position 3 -radix unsigned sim:/top/F_if/wr_en
add wave -position 4 -radix unsigned sim:/top/F_if/rd_en
add wave -position 5 -radix hexadecimal sim:/top/F_if/data_in
add wave -position 6  -color yellow -radix hexadecimal sim:/top/F_if/data_out
add wave -position 7  -color Orchid -radix hexadecimal sim:/top/F_if/data_out_ref
add wave -position 8  -color yellow -radix unsigned sim:/top/F_if/wr_ack
add wave -position 9  -color Orchid -radix unsigned sim:/top/F_if/wr_ack_ref
add wave -position 12 -color yellow -radix unsigned sim:/top/F_if/full
add wave -position 13 -color Orchid -radix unsigned sim:/top/F_if/full_ref
add wave -position 14 -color yellow -radix unsigned sim:/top/F_if/empty
add wave -position 15 -color Orchid -radix unsigned sim:/top/F_if/empty_ref
add wave -position 16 -color yellow -radix unsigned sim:/top/F_if/almostfull
add wave -position 17 -color Orchid -radix unsigned sim:/top/F_if/almostfull_ref
add wave -position 18 -color yellow -radix unsigned sim:/top/F_if/almostempty
add wave -position 19 -color Orchid -radix unsigned sim:/top/F_if/almostempty_ref
add wave -position 20 -color yellow -radix unsigned sim:/top/F_if/overflow
add wave -position 21 -color Orchid -radix unsigned sim:/top/F_if/overflow_ref
add wave -position 22 -color yellow -radix unsigned sim:/top/F_if/underflow
add wave -position 23 -color Orchid -radix unsigned sim:/top/F_if/underflow_ref
add wave -position 24 -radix unsigned sim:/top/dut/count

.vcop Action toggleleafnames
## Assertion
add wave /top/dut/rst_n_assert/assert_full_rst
add wave /top/dut/rst_n_assert/assert_almostfull_rst
add wave /top/dut/rst_n_assert/assert_empty_rst
add wave /top/dut/rst_n_assert/assert_almostempty_rst

add wave /top/dut/full_count
add wave /top/dut/full_from_almost
add wave /top/dut/full_noChange
add wave /top/dut/full_inactive

add wave /top/dut/ack_active
add wave /top/dut/ack_inactive

add wave /top/dut/almostfull_count
add wave /top/dut/almostfull_from_full
add wave /top/dut/almostfull_noChange
add wave /top/dut/almostfull_inactive

add wave /top/dut/overflow_active
add wave /top/dut/overflow_wr_in
add wave /top/dut/overflow_Nfull

add wave /top/dut/almostempty_count
add wave /top/dut/almostempty_noChange
add wave /top/dut/almostempty_from_empty
add wave /top/dut/almostempty_inactive

add wave /top/dut/empty_count
add wave /top/dut/empty_noChaneg
add wave /top/dut/empty_from_almost
add wave /top/dut/empty_inactive

add wave /top/dut/underflow_active
add wave /top/dut/underflow_Nempty
add wave /top/dut/underflow_Nrd

add wave /top/dut/count_inc
add wave /top/dut/count_dec
add wave /top/dut/count_noChange

add wave /top/dut/inc_wr_ptr_assert
add wave /top/dut/inc_rd_ptr_assert
## reset assertion
add wave /top/dut/rst_n_assert/assert_count_rst
add wave /top/dut/rst_n_assert/assert_wr_ptr_rst
add wave /top/dut/rst_n_assert/assert_rd_ptr_rst
add wave /top/dut/rst_n_assert/assert_wr_akc_rst
add wave /top/dut/rst_n_assert/assert_overflow_rst
add wave /top/dut/rst_n_assert/assert_underflow_rst
add wave /top/dut/rst_n_assert/assert_data_out_rst

run -all
#quit -sim
