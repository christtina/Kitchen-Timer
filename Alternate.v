`timescale 1ns / 1ps
module alternate(
    input k_clk, // 1KHz clock to display to the FPGA
    input [15:0] big_bin, //16 bit BCD of the time
    output reg[3:0] small_bin, AN //output of number and section of display to show it in
);
	///////////////////////////////////////////////////////////////////////////
	//
	// Alternates the output to the FPGA
	//
	////////////////////////////////////////////////////////////////////////////
	
	
	//initializing a count variable that we will use as different states in our output switch statement
    reg [1:0] count;
	
	//Changes output every positive edge of the 1KHz clock
    always @(posedge k_clk) begin
				
				//incrementing count by on each positive clock tick
            count <= count + 1;
				
				//Case statement that determines what number gets outputed to the FPGA
            case(count)
					
					//displays min_1 to the far left bin
                2'b00: begin
                    AN <= 4'b1110;
                    small_bin <= big_bin[3:0];
                end
					 
					 //displays min_0 to the second to left bin
                2'b01: begin
                    AN <= 4'b1101;
                    small_bin <= big_bin[7:4];
                end
					 
					 //displays sec_1 to the second to right bin
                2'b10: begin
                    AN <= 4'b1011;
                    small_bin <= big_bin[11:8];
                end
					 
					//displays sec_0 to the far right bin
                2'b11: begin
                    AN <= 4'b0111;
                    small_bin <= big_bin[15:12];
                    count <= 0;
                end
            endcase

    end
endmodule
