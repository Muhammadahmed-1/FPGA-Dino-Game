

module Keyboard (
	// Inputs
	CLOCK_50,
	reset,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
   up_pressed // this goes into the game module 
	
);


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/
parameter UP = 8'h75;

/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
//input		[3:0]	KEY;
input reset;


// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output       up_pressed ;


/*output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;*/
//tput [9:0] LEDR;
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;
reg        [6:0]   HEX0_1;  // Internal register for HEX0
reg        [6:0]   HEX1_1;
reg        [25:0]  clock_counter; 
reg                reset_1sec; 
	reg  up_pressed;
	reg  released_key;	

	// State Machine Registers

	/*****************************************************************************
	 *                         Finite State Machine(s)                           *
	 *****************************************************************************/


	/*****************************************************************************
	 *                             Sequential Logic                              *
	 *****************************************************************************/
/*prformed keyboard pressing as an individual component to test various scenarios in three iterations in order for it to work as desired
Tested the logic on the FPGA board using the HEX display
*/

	// In this code the when keyboard key is pressed up the hex displays UP and data revieced // pased into with ps2 key data and it will reset to 00 after 1 second i used a clock counter to do that 
//wire reset;
//assign reset = KEY[0];
//In this iteration I used the break code release key flag for the keyboard to accurately indicate when key is pressednd and released
//Notes:
//When a user releases a key on KEYBOARD there is a release (break code) code commonly F0. I can use that as a //lease key flag so my keyboard can work as desired.
//could have used FSM here ..
//iteration 3
always @(posedge CLOCK_50)
 begin
    if (reset) 
	 begin
        HEX0_dis <= 7'b1000000; 
        HEX1_dis <= 7'b1000000; 
        up_pressed_key <= 1'b0;
        key_release <= 1'b0;
    end else if (ps2_key_pressed) 
	 begin
        if (key_release) begin
            if (ps2_key_data == UP) 
				begin
                up_pressed_key <= 1'b0;  
                HEX1_dis <= 7'b1000000; 
                HEX0_dis <= 7'b1000000;  
            end
            key_release <= 1'b0;
        end else if (ps2_key_data == 8'hF0)
		  begin
            key_release <= 1'b1;  
        end else if (ps2_key_data == UP) 
		  begin
            up_pressed_key <= 1'b1;  
            HEX1_dis <= 7'b1000001;  
            HEX0_dis <= 7'b0001100;  
        end
    end
end
//iteration2 
//Upon keypress we need to use a key release flag (similar to speaker key release that uses FPGA board KEY) //however it wouldn't release the key 
/*
wire reset;
assign reset = KEY[0];
reg upkey_pressed;

always @(posedge CLOCK_50) begin
    if (!reset) begin
        upkey_pressed <= 1'b0;
        HEX0_1 <= 7'b1000000;
        HEX1_1 <= 7'b1000000;
    end
    else if (ps2_key_pressed) begin
        if (ps2_key_data == UP && !upkey_pressed) begin
            upkey_pressed <= 1'b1;
            HEX1_1 <= 7'b1000001;  // this displays U P
            HEX0_1 <= 7'b0000110;
        end
        else if (ps2_key_data != UP && upkey_pressed) begin
            upkey_pressed <= 1'b0;
            HEX0_1 <= 7'b1000000;
            HEX1_1 <= 7'b1000000;
        end
    end
    else if (!ps2_key_pressed && upkey_pressed) begin
        upkey_pressed <= 1'b0;
        HEX0_1 <= 7'b1000000;
        HEX1_1 <= 7'b1000000;
    end
end
*/
//iteration1
/* // did this in three stages 1)Key pressed and reset back to 00 using clock counter for half a second
// with PS2 key data and it will reset to 00 after 1 second I used a clock counter to do that
always @(posedge CLOCK_50) begin
  if (!KEY[0]) begin
    HEX0_1 <= 7'b1111111;
    HEX1_1 <= 7'b1111111;
    clock_counter <= 26'b0;
    reset_lsec <= 1'b0;
  end else if (ps2_key_pressed) begin
    // When key is pressed HEX displays UP and data revied is passed
    if (ps2_key_data == "UP") begin
      HEX1_1 <= 7'b1000001;
      HEX0_1 <= 7'b0001100;
    end else begin
      HEX1_1 <= 7'b1111111;
      HEX0_1 <= 7'b1111111;
    end
    counter <= 0;
    reset_lsec <= 1'b1;
  end else if (reset_lsec) begin
    if (clock_counter == 50_000_000 - 1) begin
      // Debugging setting the display to 00
      HEX0_1 <= 7'b0000000;
      HEX1_1 <= 7'b0000000;
      clock_counter <= 26'b0;
      reset_lsec <= 1'b0;
    end else begin
      clock_counter <= clock_counter + 1;
    end
  end
end
*/
/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/
/*assign HEX2 = 7'h7F;//7bit binary 7'b0111111
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;*/
assign HEX0 = HEX0_dis;
assign HEX1 = HEX1_dis;
//assign HEX0 = 7'h7F;
//assgin HEX1 = 7'h7F;
//assign LEDR[1] = 1'b0;
 assign up_pressed = up_pressed_key;



/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

PS2_Controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

/*Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.hex_number			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX0)
);*/

/*Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.hex_number			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.seven_seg_display	(HEX1)
);
*/

endmodule
