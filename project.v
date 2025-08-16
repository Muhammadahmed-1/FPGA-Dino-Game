module project(CLOCK_50,SW, LEDR, KEY, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_CLK,PS2_CLK,PS2_DAT, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,FPGA_I2C_SDAT,AUD_XCK,AUD_DACDAT,FPGA_I2C_SCLK);
	input CLOCK_50;
	input [0:0]SW;
	input [3:0] KEY;
	output [7:0] VGA_R, VGA_G, VGA_B;
	output VGA_HS, VGA_VS,VGA_BLANK_N, VGA_SYNC_N, VGA_CLK;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7; 
	inout PS2_CLK; 
	input AUD_ADCDAT;
	inout	AUD_BCLK;
   inout	AUD_ADCLRCK;
   inout	AUD_DACLRCK;
  
    inout FPGA_I2C_SDAT;

   output	AUD_XCK;
   output	AUD_DACDAT;	
	output				FPGA_I2C_SCLK;

inout PS2_DAT; 

	reg [2:0] dinoPattern [0:7][0:7];
	reg [2:0] legLeftColour;
	reg [2:0] legRightColour;
		reg isJumping; 
		
  assign HEX4 = 7'h7F;
  assign HEX5 = 7'h7F;

   wire up_pressed; 
	//up_pressed would the output from the keyboard
	//essentially the ps2_key_pressed from the ps2 controller will tell us that keyboard key is pressed then it would send a signal of key press
   //the up pressed would tell us
   KEYBOARD K1(CLOCK_50,!KEY[0],PS2_CLK,PS2_DAT, HEX0, HEX1, up_pressed); 
	wire playsound;
	sound s1(CLOCK_50,!KEY[0],AUD_ADCDAT,AUD_BCLK,AUD_ADCLRCK,AUD_DACLRCK,FPGA_I2C_SDAT,AUD_XCK,AUD_DACDAT,FPGA_IC2_SCLK,playsound);
	wire HSecEn;
	half_second_counter a1 (CLOCK_50, !KEY[0], HSecEn);
	assign LEDR[1] = playsound; 
  
	//scoreincrements s4(KEY[0],CLOCK_50,HEX2,HEX3);

reg [1:0]state_rn;
reg [1:0]nextState;		
parameter START_SCREEN = 2'b00 , GAME_RUNNING = 2'b01 ,game_over = 2'b10;

reg plot;

reg key2_release;
wire starting_signal;

wire reset1;
assign reset1 = KEY[0];

//this FSM basically intergrates with the game logic to show different menus	 
//STATE TRANSITION 
    always @(*)
	 begin
        case (state_rn)
       START_SCREEN: 
				begin
                if (starting_signal)
                    nextState = GAME_RUNNING;
                else
                    nextState = START_SCREEN;
            end
		 GAME_RUNNING: 
		 begin
            if (gameOver)
                nextState = game_over;
            else
                nextState = GAME_RUNNING;
        end
            /*GAME_RUNNING:
            begin
                next_state = GAME_RUNNING;
            end*/
		game_over:
		begin
            if (starting_signal)
				begin
                nextState = GAME_RUNNING;
					 //game_over <= 0 ; //cant do this
			   end		 
            else
               nextState = game_over;
      end
      default: 
				begin
                nextState = START_SCREEN;
            end
        endcase
    end
	 
	 
	 
   wire score_start;
	assign score_start= (state_rn == GAME_RUNNING);
	 scoreincrements s4(KEY[0],score_start,CLOCK_50,HEX2,HEX3);

    always @(posedge CLOCK_50 or negedge reset1)
 begin
        if (!reset1) 
      begin
            state_rn <= START_SCREEN;
            key2_release <= 1'b1;
        end else 
		  begin
            key2_release<= KEY[2];
								
            state_rn <= nextState;
        end
    end
	  
    assign starting_signal = (!KEY[2]) && (key2_release);

	 
always @(posedge CLOCK_50) begin
	 if (state_rn == GAME_RUNNING) 
	 begin
		if(isJumping) begin 
			legLeftColour <= 3'b010;
			legRightColour <= 3'b010;
		end
      else if (HSecEn) begin
         legLeftColour <= 3'b111;
         legRightColour <= 3'b010;
      end else begin
         legLeftColour <= 3'b010;
         legRightColour <= 3'b111; 
      end

      dinoPattern[7][3] <= legLeftColour;
      dinoPattern[7][6] <= legRightColour;
   end
end 
    
    initial begin
        dinoPattern[0][0] = 3'b111; dinoPattern[0][1] = 3'b111; dinoPattern[0][2] = 3'b001; dinoPattern[0][3] = 3'b010;
        dinoPattern[0][4] = 3'b010; dinoPattern[0][5] = 3'b010; dinoPattern[0][6] = 3'b010; dinoPattern[0][7] = 3'b111;
        
        dinoPattern[1][0] = 3'b111; dinoPattern[1][1] = 3'b111; dinoPattern[1][2] = 3'b111; dinoPattern[1][3] = 3'b010;
        dinoPattern[1][4] = 3'b000; dinoPattern[1][5] = 3'b010; dinoPattern[1][6] = 3'b000; dinoPattern[1][7] = 3'b010;

        dinoPattern[2][0] = 3'b111; dinoPattern[2][1] = 3'b111; dinoPattern[2][2] = 3'b001; dinoPattern[2][3] = 3'b010;
        dinoPattern[2][4] = 3'b010; dinoPattern[2][5] = 3'b010; dinoPattern[2][6] = 3'b010; dinoPattern[2][7] = 3'b010;
        
        dinoPattern[3][0] = 3'b111; dinoPattern[3][1] = 3'b111; dinoPattern[3][2] = 3'b111; dinoPattern[3][3] = 3'b010;
        dinoPattern[3][4] = 3'b011; dinoPattern[3][5] = 3'b011; dinoPattern[3][6] = 3'b011; dinoPattern[3][7] = 3'b111;
        
        dinoPattern[4][0] = 3'b111; dinoPattern[4][1] = 3'b111; dinoPattern[4][2] = 3'b001; dinoPattern[4][3] = 3'b010;
        dinoPattern[4][4] = 3'b010; dinoPattern[4][5] = 3'b011; dinoPattern[4][6] = 3'b011; dinoPattern[4][7] = 3'b010;
        
        dinoPattern[5][0] = 3'b010; dinoPattern[5][1] = 3'b111; dinoPattern[5][2] = 3'b111; dinoPattern[5][3] = 3'b010;
        dinoPattern[5][4] = 3'b011; dinoPattern[5][5] = 3'b011; dinoPattern[5][6] = 3'b011; dinoPattern[5][7] = 3'b111;
        
        dinoPattern[6][0] = 3'b111; dinoPattern[6][1] = 3'b010; dinoPattern[6][2] = 3'b010; dinoPattern[6][3] = 3'b010;
        dinoPattern[6][4] = 3'b011; dinoPattern[6][5] = 3'b011; dinoPattern[6][6] = 3'b011; dinoPattern[6][7] = 3'b111;
        
        dinoPattern[7][0] = 3'b111; dinoPattern[7][1] = 3'b111; dinoPattern[7][2] = 3'b111;
        dinoPattern[7][3] = 3'b000; 
        dinoPattern[7][4] = 3'b111; dinoPattern[7][5] = 3'b111;
        dinoPattern[7][6] = 3'b000; 
        dinoPattern[7][7] = 3'b111;
    end

	reg [7:0] dinoX = 25; 
	reg [6:0] dinoY = 90;
	
	reg [7:0] x; 
	reg [6:0] y; 
	reg [2:0] colour;
	 
	reg [2:0] cactusOne [0:7][0:7];
		initial begin
			cactusOne[0][0] = 3'b111; cactusOne[0][1] = 3'b111; cactusOne[0][2] = 3'b111; cactusOne[0][3] = 3'b000;
			cactusOne[0][4] = 3'b010; cactusOne[0][5] = 3'b111; cactusOne[0][6] = 3'b111; cactusOne[0][7] = 3'b111;

			cactusOne[1][0] = 3'b111; cactusOne[1][1] = 3'b010; cactusOne[1][2] = 3'b111; cactusOne[1][3] = 3'b010;
			cactusOne[1][4] = 3'b010; cactusOne[1][5] = 3'b111; cactusOne[1][6] = 3'b000; cactusOne[1][7] = 3'b111;

			cactusOne[2][0] = 3'b111; cactusOne[2][1] = 3'b010; cactusOne[2][2] = 3'b111; cactusOne[2][3] = 3'b010;
			cactusOne[2][4] = 3'b010; cactusOne[2][5] = 3'b111; cactusOne[2][6] = 3'b010; cactusOne[2][7] = 3'b111;

			cactusOne[3][0] = 3'b111; cactusOne[3][1] = 3'b000; cactusOne[3][2] = 3'b010; cactusOne[3][3] = 3'b010;
			cactusOne[3][4] = 3'b010; cactusOne[3][5] = 3'b111; cactusOne[3][6] = 3'b010; cactusOne[3][7] = 3'b111;

			cactusOne[4][0] = 3'b111; cactusOne[4][1] = 3'b111; cactusOne[4][2] = 3'b010; cactusOne[4][3] = 3'b010;
			cactusOne[4][4] = 3'b000; cactusOne[4][5] = 3'b010; cactusOne[4][6] = 3'b111; cactusOne[4][7] = 3'b111;

			cactusOne[5][0] = 3'b111; cactusOne[5][1] = 3'b111; cactusOne[5][2] = 3'b111; cactusOne[5][3] = 3'b010;
			cactusOne[5][4] = 3'b010; cactusOne[5][5] = 3'b111; cactusOne[5][6] = 3'b111; cactusOne[5][7] = 3'b111;

			cactusOne[6][0] = 3'b111; cactusOne[6][1] = 3'b111; cactusOne[6][2] = 3'b111; cactusOne[6][3] = 3'b010;
			cactusOne[6][4] = 3'b010; cactusOne[6][5] = 3'b111; cactusOne[6][6] = 3'b111; cactusOne[6][7] = 3'b111;

			cactusOne[7][0] = 3'b111; cactusOne[7][1] = 3'b111; cactusOne[7][2] = 3'b111; cactusOne[7][3] = 3'b000;
			cactusOne[7][4] = 3'b010; cactusOne[7][5] = 3'b111; cactusOne[7][6] = 3'b111; cactusOne[7][7] = 3'b111;
		end

	reg [7:0] cactusOneX = 160;
	reg [6:0] cactusOneY = 90;
	reg cactusActive = 0;
	
	
	//jumping mechanism
	/*wire jump;
	assign jump = !KEY[1];
	reg [3:0] current, next;
	parameter IDLE = 2'b00, JUMP = 2'b01, FALL = 2'b10;
	
	always @(*)
		begin
			case(current)
				IDLE: begin
					if(jump && HSecEn) next = JUMP;
					else begin
						dinoY <= 90;
						next = IDLE;
					end
				end
					
				JUMP: begin
					if(HSecEn) next = FALL;
					else begin
						if(dinoY > 60) begin
							dinoY <= dinoY - 1;
						end
						next = JUMP;
					end
				end
				
				FALL: begin
					if(HSecEn) next = IDLE;
					else begin
						if(dinoY < 90) begin
							dinoY <= dinoY + 1;
						end
						next = FALL;
					end
				end
				
			endcase
		end

			
	always @(posedge CLOCK_50)
		begin
			if(!KEY[0]) begin
				current <= IDLE;
			end
			else
				current <= next;
		end

	assign LEDR[9] = (current == JUMP);
	assign LEDR[8] = (current == FALL);*/

	

	wire [1:0] random_value;
	randomGen u1 (CLOCK_50, random_value);


	
	reg [19:0] counter; 

	reg prevKeyState;  
	reg isMoving;
	

	
always @(posedge CLOCK_50 or negedge KEY[0]) begin
    if (!KEY[0]) begin
        
        dinoX <= 25;       
        dinoY <= 90;      
        isJumping <= 0;    
        cactusOneX <= 160; 
        cactusActive <= 0; 
        counter <= 0;      
        prevKeyState <= 0; 
    end else begin
        counter <= counter + 1;

      
        if (state_rn == GAME_RUNNING)
		  begin
            
            if ((!KEY[1] || up_pressed) && !prevKeyState && dinoY == 90) begin
                isJumping <= 1; 
            end

            prevKeyState <= (!KEY[1] || up_pressed);

            if (counter == 0) begin
                if (isJumping) begin
                    // Jump
                    if (dinoY > 73) begin
                        dinoY <= dinoY - 1; 
                    end else begin
                        isJumping <= 0; 
                    end
                end else begin
                    // Fall
                    if (dinoY < 90) begin
                        dinoY <= dinoY + 1; 
                    end
                end

                
                if (cactusActive) begin
                    if (cactusOneX > 0) begin
                        cactusOneX <= cactusOneX - 1; 
                    end else begin
                        cactusActive <= 0; 
                    end
                end else if (random_value == 2'b01) begin
                 
                    cactusOneX <= 160; 
                    cactusActive <= 1;
                end
            end
        end


    end
end
	/*always @(posedge CLOCK_50) begin

    counter <= counter + 1;
  
    if (current_state == GAME_RUNNING) begin

    if (( !KEY[1]||up_pressed) && !prevKeyState && dinoY == 90) begin
        isJumping <= 1; 
    end

    prevKeyState <= (!KEY[1] || up_pressed);

    if (counter == 0) begin
        if (isJumping) begin
            // Jump
            if (dinoY > 75) begin
                dinoY <= dinoY - 1;
            end else begin
                isJumping <= 0;
            end
        end else begin
            // Fall
            if (dinoY < 90) begin
                dinoY <= dinoY + 1;
            end
        end


        if (cactusActive) begin
            if (cactusOneX > 0) begin
                cactusOneX <= cactusOneX - 1; 
            end else begin
                cactusActive <= 0;
            end
        end else if (random_value == 2'b01) begin
            // Spawn a new cactus when random value matches
            cactusOneX <= 160; 
            cactusActive <= 1;
        end
    end
end
end*/
assign playsound = (isJumping || gameOver); // sound will play when the dino jumps and gameover state
//assign playsound = isJumping;	
reg gameOver; 

//Collision detection
always @(posedge CLOCK_50 or negedge KEY[0]) begin
    if (!KEY[0]) begin
        gameOver <= 0; 
	 
    end else if (state_rn == GAME_RUNNING) begin
        
        if (cactusActive &&
            dinoX + 7 >= cactusOneX && dinoX <= cactusOneX + 7 &&
            dinoY + 7 >= cactusOneY && dinoY <= cactusOneY + 7) begin
            gameOver <= 1; 
        end else begin
            gameOver <= 0; 
        end
    end
end


// this the gameover memory object page instantion
wire [14:0] endpage_address; // which is 19200(160x120) 
wire [2:0] endpage_color;  

assign endpage_address = y * 160 + x; 

endcolor m2(endpage_address,CLOCK_50,endpage_color);


/*initial begin
    x <= 8'd0;
    y <= 7'd0;
end*/
//this for VGA  display
always @(posedge CLOCK_50 or negedge KEY[0])
 begin
        if (!KEY[0]) 
		  begin
            x <= 8'd0;
            y <= 7'd0;
            plot <= 1'b0;  //so it show background ,mif
           
        end else 
		  begin
          //pixel by pixel
            if (x == 159) begin
                x <= 0;
                if (y == 119)
                    y <= 0;
                else
                    y <= y + 1;
            end 
            else begin
                x <= x + 1;
            end

            case (state_rn)
                START_SCREEN:
					 begin
                   
                    plot <= 1'b0;
						
                end
                
                GAME_RUNNING:
					 begin
                
                    plot <= 1'b1;
                    colour <= 3'b111; 

                   
                    if (x >= dinoX && x < dinoX + 8 && y >= dinoY && y < dinoY + 8) begin
                        colour <= dinoPattern[y - dinoY][x - dinoX];
                    end 
                    else if (cactusActive && x >= cactusOneX && x < cactusOneX + 8 && 
                             y >= cactusOneY && y < cactusOneY + 8) begin
                        colour <= cactusOne[y - cactusOneY][x - cactusOneX];
                    end
                    else if (y >= 98) begin
                        colour <= 3'b000;  
                    end
                end
					 game_over: 
					 begin
            
                plot <= 1'b1;
                colour <= endpage_color; 
                end

               default: 
					begin
              
                plot <= 1'b0;
                colour <= 3'b000;
               end
            endcase
        end
    end
	
   vga_adapter VGA (
        .resetn(KEY[0]),
        .clock(CLOCK_50),
        .colour(colour),
        .x(x),
        .y(y),
        .plot(plot),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_BLANK_N(VGA_BLANK_N),
        .VGA_SYNC_N(VGA_SYNC_N),
        .VGA_CLK(VGA_CLK)
    );
    defparam VGA.RESOLUTION = "160x120";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    defparam VGA.BACKGROUND_IMAGE = "image.colour.mif"; 
	
endmodule

module half_second_counter(CLOCK_50, reset, halfsecond);
    input CLOCK_50;
    input reset;
    output reg halfsecond;
    reg [25:0] clock_counter;

    always @(posedge CLOCK_50) begin
        if (reset) begin
            clock_counter <= 26'b0;
            halfsecond <= 0;
        end else begin
            if (clock_counter == 2_000_000 - 1) begin 
                clock_counter <= 0;
                halfsecond <= ~halfsecond;
            end else begin
                clock_counter <= clock_counter + 1;
            end
        end
    end
endmodule

module randomGen(clock, randomNum);
    input clock;            
    output reg [1:0] randomNum; 
 
    
    reg [24:0] counter = 0;   
    reg slowClock = 0;      
    
    reg [2:0] Q = 3'b101;   
    reg [1:0] rng;           
    
    always @(posedge clock) begin
 
        if (counter == 25_000_000 - 1) begin
            counter <= 0;         
            slowClock <= ~slowClock; // Toggle slow clock
        end else begin
            counter <= counter + 1; 
        end
    end

    always @(posedge slowClock) begin
   
        Q[2] <= Q[1];
        Q[1] <= Q[0];
        Q[0] <= Q[2] ^ Q[1];
        
        // Random number generation
        case (Q[1:0])
            2'b00: rng <= 2'b01;
            2'b01: rng <= 2'b10;
            2'b10: rng <= 2'b11;
            default: rng <= 2'b01;
        endcase
        
        randomNum <= rng; 
    end
endmodule