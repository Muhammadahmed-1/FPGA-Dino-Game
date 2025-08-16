module  scoreincrements(KEY, CLOCK_50, HEX2,HEX3);
    input [0:0] KEY;
    input CLOCK_50;
    output [6:0] HEX2;
	 output [6:0] HEX3;
	 //output [6:0] HEX2;
	 
	 
    reg flag;
    reg [7:0] count; 
    reg [25:0] clock_counter;
	 reg stopping;
    
    always @(posedge CLOCK_50)
 begin
        if (KEY[0] == 0) 
        begin
            count <= 8'b0;
            clock_counter <= 26'b0;
				flag<=0;
				stopping <=0;
        end else if (!stopping)
           begin
            if (clock_counter == 50000000 - 1)
		begin
                clock_counter <= 26'b0;
                if (count == 8'b01100011)
		  begin
                    count <= 8'b0;  // Reset count when it reaches 100
			 flag <=1;
			 stopping <= 1;
                end else 
					 begin
					     flag<=0;
                    count <= count + 1'b1;  // Increment count
                end
            end else 
				begin
                clock_counter <= clock_counter + 1'b1; // Increment clock counter
            end
        end
    end
	 /*always @ (posedge CLOCK_50)
	 begin
	 if (count == 8'b01100011)
	 begin
	  stopping<=1;
	 end
   end	*/ 
	 wire [3:0] tenth;
	 wire [3:0] digit;
	 assign tenth = count /10;
	 assign digit = count %10;

    HEX H0 (digit, HEX2);
	 HEX H1 (tenth, HEX3);
	 //win H3(flag,HEX0,HEX1,HEX2);
endmodule

module HEX (x, HEX);
    input [3:0] x;
    output [6:0] HEX;

    assign HEX[0] = (~x[3] & ~x[2] & ~x[1] & x[0]) | (x[2] & ~x[1] & ~x[0]);
    assign HEX[1] = (x[2] & ~x[1] & x[0]) | (x[2] & x[1] & ~x[0]);
    assign HEX[2] = (~x[2] & x[1] & ~x[0]);
    assign HEX[3] = (x[2] & ~x[1] & ~x[0]) | (~x[2] & ~x[1] & x[0]) | (x[1] & x[0] & x[2]);
    assign HEX[4] = (x[2] & ~x[1] & ~x[0]) | x[0];
    assign HEX[5] = (~x[2] & x[1] & ~x[0]) | (x[2] & x[1] & x[0]) | (~x[3] & ~x[2] & x[0]);
    assign HEX[6] = (~x[3] & ~x[2] & ~x[1]) | (x[2] & x[1] & x[0]);
endmodule

/*module win(flag,HEX0,HEX1,HEX2);
    input flag;
    output reg [6:0] HEX0;
	 output reg[6:0] HEX1;
	 output reg[6:0] HEX2;
	 always@(*)
	 begin
	    if (flag==1)
		 begin
		     HEX2= 7'b1000001;
			  HEX1= 7'b0000001;
			  HEX0= 7'b1101010;
		end	  
		 else	 
		    begin
			  HEX2= 7'b1111111;
			  HEX1= 7'b1111111;
			  HEX0= 7'b1111111;
			end
	 end
endmodule	 */