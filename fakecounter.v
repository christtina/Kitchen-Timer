`timescale 1ns / 1ps

module fakecounter(
	input clock, //same clock as the counter
	input [3:0] min_1, min_0, sec_1, sec_0, //input of the time that the counter is at
	output reg [15:0] big_bin // 16 bit BCD of the minutes and seconds
    );
/////////////////////////////////////////////////////////////////////////////////////
//	 
// Concatenates min_1, min_0, sec_1, sec_0 into one 16 bit BCD value of all 4 numbers
//
/////////////////////////////////////////////////////////////////////////////////////

always @(posedge clock) begin
	big_bin <= {min_1, min_0, sec_1, sec_0};
end

endmodule
