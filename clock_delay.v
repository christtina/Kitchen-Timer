`timescale 1ns / 1ps
module clock_delay(
    input clk,fast, //take in the machine clock and the speed of the counter clock that the user wants
    output reg clock //clock used to count time
);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Converts the 100MHz clock into a 1Hz clock. This clock is used for our FSM to determine the how fast the counter counts
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//27 bit counter that is initialized to 0 and a clock that starts at 0
reg [26:0] count; 
initial count = 0;
initial clock = 0;

//Time conversion
always @(posedge clk) begin

	//If the user wants the clock to increment every 1/5 of a second the counter counts up to .2 of 100e6 then makes the clock tick
	if(fast) begin
		count <= count +1;
		if(count == 20000000)begin
			clock <= ~clock;
			count <= 1;
		end
	end
	
	//If the user wants the clock to increment every second the counter counts up to 100e6 then makes the clock tick
	else begin
    count <= count + 1;
    if (count == 100000000) begin
        clock <= ~clock;
        count <= 1;
    end 
	end
	
end

endmodule

