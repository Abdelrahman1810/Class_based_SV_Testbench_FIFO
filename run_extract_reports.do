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

vsim -coverage -vopt work.top -c -do "coverage save -onexit -du FIFO -directive -codeAll cover.ucdb; run -all"
coverage report -detail -cvg -directive -comments -output {Reports/Coverage group report/COV_GRP_FIFO.txt} {}
# if you want to see waveform you have top comment "quit -sim" instruction 
quit -sim
vcover report cover.ucdb -details -all -annotate -output {Reports/code coverage report/CODE_COVER_FIFO.txt}
vcover report -html cover.ucdb -output {Reports/code_cover_report_html/.} 