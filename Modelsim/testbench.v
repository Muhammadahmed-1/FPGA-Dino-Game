`timescale 1ns / 1ps

module testbench;

    // Parameter for clock period (20 ns for 50 MHz)
    parameter CLOCK_PERIOD = 20;

    // Declare Inputs as reg
    reg CLOCK_50;
    reg [2:0] KEY;
    reg PS2_CLK;
    reg PS2_DAT;
    reg AUD_ADCDAT;

    // Declare Outputs as wire
    wire [7:0] VGA_R, VGA_G, VGA_B;
    wire VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK;
    wire [9:0] LEDR;
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
    wire AUD_XCK, AUD_DACDAT, FPGA_I2C_SCLK;
    wire AUD_BCLK, AUD_ADCLRCK, AUD_DACLRCK;
    wire FPGA_I2C_SDAT;
    wire playsound;
    wire up_pressed;
    //wire isJumping;
    // Instantiate the Unit Under Test (UUT)
    project uut (
        .CLOCK_50(CLOCK_50),
        .KEY(KEY),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7),
        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_BCLK(AUD_BCLK),
        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_DACLRCK(AUD_DACLRCK),
        .FPGA_I2C_SDAT(FPGA_I2C_SDAT),
        .AUD_XCK(AUD_XCK),
        .AUD_DACDAT(AUD_DACDAT),
        .FPGA_I2C_SCLK(FPGA_I2C_SCLK)
    );

    // Clock Generation: Toggle CLOCK_50 every CLOCK_PERIOD/2
    initial begin
        CLOCK_50 = 1'b0;
        forever #(CLOCK_PERIOD / 2) CLOCK_50 = ~CLOCK_50;
    end

    // Initialize Inputs and Apply Stimulus
    initial begin
        // Initialize all keys to not pressed (assuming active low)
        KEY = 3'b111;
        
        // Initialize PS2 signals to idle state
        PS2_CLK = 1'b1;
        PS2_DAT = 1'b1;
        
        // Initialize Audio input
        AUD_ADCDAT = 1'b0;
        
        // Wait for global reset
        #100;
        
        // Apply Reset: Assuming KEY[0] is reset (active low)
        KEY[0] = 1'b0;  // Assert reset
        #100;
        KEY[0] = 1'b1;  // Deassert reset
        
        // Simulate a Jump: Press and release KEY[1]
        #200;
        KEY[1] = 1'b0;  // Press KEY[1]
        #50;
        KEY[1] = 1'b1;  // Release KEY[1]
        
        // Simulate Multiple Jumps
        #300;
        KEY[1] = 1'b0;  // Press KEY[1]
        #50;
        KEY[1] = 1'b1;  // Release KEY[1]
        
        #300;
        KEY[1] = 1'b0;  // Press KEY[1]
        #50;
        KEY[1] = 1'b1;  // Release KEY[1]
        
        // Optionally, simulate PS2 key presses
        // Uncomment and modify the following lines if PS2 key simulation is required
        /*
        #400;
        send_ps2_key(8'h75); // Example: Up Arrow key make code
        */
        
        // End of simulation after a certain time
        #1000;
        $finish;
    end

    // Task to Simulate PS2 Key Press (Optional)
    /*
    task send_ps2_key;
        input [7:0] scancode;
        integer i;
        begin
            // Start bit
            PS2_DAT = 1'b0;
            #100;
            
            // Send scancode bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                PS2_DAT = scancode[i];
                #100;
                PS2_CLK = 1'b0;
                #50;
                PS2_CLK = 1'b1;
                #50;
            end
            
            // Stop bit
            PS2_DAT = 1'b1;
            #100;
        end
    endtask
    */

    // Monitor Output Signals
    initial begin
        $monitor("Time=%0t | KEY=%b | up_pressed=%b | playsound=%b | dinoY=%d | cactusOneX=%d | LEDR=%b",
                 $time, KEY, up_pressed, playsound, uut.dinoY, uut.cactusOneX, LEDR);
    end

endmodule
