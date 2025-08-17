# stop any simulation that is currently running
quit -sim



# create the default "work" library
vlib work;

# Corrected vlog command in testbench.tcl
vlog ../project.v ../sound.v ../KEYBOARD.v ../Audio_Controller.v ../PS2_Controller.v ../vga_adapter/*.v


# compile the Verilog code of the testbench
vlog *.v
# start the Simulator, including some libraries that may be needed
vsim work.testbench -Lf 220model -Lf altera_mf_ver -Lf verilog
# show waveforms specified in wave.do
do wave.do
# advance the simulation the desired amount of time
run 800 ns
