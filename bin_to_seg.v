`timescale 1ns / 1ps
module bin_to_seg(
    input [3:0] bin, //number to display
    output reg [6:0] disp // lights to output so they represent the correct number
);
	/////////////////////////////////////////////////////////////////////////////////////
	//
	// Uses a switch statement that hard codes the correct FPGA display for each number 0 to 9 with an error case that displays E
	//
	/////////////////////////////////////////////////////////////////////////////////////
    always @(bin) begin
        case(bin)
            4'b0000: begin disp <= 7'b1000000; end //display is 0
            4'b0001: begin disp <= 7'b1111001; end //display is 1
            4'b0010: begin disp <= 7'b0100100; end //display is 2
            4'b0011: begin disp <= 7'b0110000; end //display is 3
            4'b0100: begin disp <= 7'b0011001; end //display is 4
				4'b0101: begin disp <= 7'b0010010; end //display is 5
				4'b0110: begin disp <= 7'b0000010; end //display is 6
				4'b0111: begin disp <= 7'b1111000; end //display is 7
				4'b1000: begin disp <= 7'b0000000; end //display is 8
				4'b1001: begin disp <= 7'b0011000; end //display is 9
            default: begin disp <= 7'b0000110; end // display E
        endcase
    end
endmodule
