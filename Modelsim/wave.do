# wave.do

# Resume on errors
onerror {resume}

# Activate the next waveform pane
quietly WaveActivateNextPane {} 0

# Add clock and key signals from the top module
add wave -noupdate -label CLOCK_50 -radix binary /project/CLOCK_50
add wave -noupdate -label KEY -radix binary /project/KEY

# Add VGA signals
add wave -noupdate -label VGA_R -radix hexadecimal /project/VGA_R
add wave -noupdate -label VGA_G -radix hexadecimal /project/VGA_G
add wave -noupdate -label VGA_B -radix hexadecimal /project/VGA_B
add wave -noupdate -label VGA_HS -radix binary /project/VGA_HS
add wave -noupdate -label VGA_VS -radix binary /project/VGA_VS
add wave -noupdate -label VGA_BLANK_N -radix binary /project/VGA_BLANK_N
add wave -noupdate -label VGA_SYNC_N -radix binary /project/VGA_SYNC_N
add wave -noupdate -label VGA_CLK -radix binary /project/VGA_CLK

# Add signals related to dino movement
add wave -noupdate -label dinoX -radix decimal /project/dinoX
add wave -noupdate -label dinoY -radix decimal /project/dinoY
add wave -noupdate -label isJumping -radix binary /project/isJumping

# Add cactus position signals
add wave -noupdate -label cactusOneX -radix decimal /project/cactusOneX
add wave -noupdate -label cactusOneY -radix decimal /project/cactusOneY
add wave -noupdate -label cactusActive -radix binary /project/cactusActive

# Add colour output for VGA
add wave -noupdate -label colour -radix hexadecimal /project/colour

# Add LED output signals
add wave -noupdate -label LEDR -radix binary /project/LEDR

# Add HEX displays
add wave -noupdate -label HEX0 -radix hexadecimal /project/HEX0
add wave -noupdate -label HEX1 -radix hexadecimal /project/HEX1

# Add sound-related signals
add wave -noupdate -label playsound -radix binary /project/playsound

# Add random value signals
add wave -noupdate -label random_value -radix binary /project/random_value

# Update tree to reflect the new additions
TreeUpdate [SetDefaultTree]

# Add a divider for organization
add wave -noupdate -divider VGA Signals
add wave -noupdate -divider Dino Controls
add wave -noupdate -divider Cactus Controls
add wave -noupdate -divider Output Displays

# Cursor configuration
WaveRestoreCursors {{Cursor 1} {10000 ps} 0}
quietly wave cursor active 1

# Configure the waveform viewer display
configure wave -namecolwidth 80
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

# Update waveform view to reflect changes
update

# Restore zoom settings for viewing from 0 to 120 ns
WaveRestoreZoom {0 ps} {120 ns}