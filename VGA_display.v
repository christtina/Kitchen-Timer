`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Zafar M. Takhirov
// 
// Create Date:    12:59:40 04/12/2011 
// Design Name: EC311 Support Files
// Module Name:    vga_display 
// Project Name: Lab5 / Lab6 / Project
// Target Devices: xc6slx16-3csg324
// Tool versions: XILINX ISE 13.3
// Description: 
//
// Dependencies: vga_controller_640_60
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_display(rst, clk, R, G, B, HS, VS, big_bin);
	input rst;	// global reset
	input clk;	// 100MHz clk
	
	input [15:0] big_bin;
	
	// color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	
	// Synchronization signals
	output HS;
	output VS;
	
	// controls:
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	wire [13:0] min_1, min_0, sec_1, sec_0;	// the segments you want to display
	wire [1:0] dot; 
	
	wire [6:0] num_0, num_1, num_2, num_3;
	bin_to_seg bts0 (big_bin[3:0], num_0);
	bin_to_seg bts1 (big_bin[7:4], num_1);
	bin_to_seg bts2 (big_bin[11:8], num_2);
	bin_to_seg bts3 (big_bin[15:12], num_3);
	
	/////////////////////////////////////////////////////
	// Begin clock division
	parameter N = 2;	// parameter for clock division
	reg clk_25Mhz;
	reg [N-1:0] count;
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	// End clock division
	/////////////////////////////////////////////////////
	
	// Call driver
	vga_controller vc(
		.rst(rst), 
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank));
	
	// create a box:
	assign min_1[0] = ~blank & (hcount >= 200 & hcount <= 250 & vcount >= 100 & vcount <= 110);
	assign min_1[1] = ~blank & (hcount >= 240 & hcount <= 250 & vcount >= 115 & vcount <= 155);
	assign min_1[2] = ~blank & (hcount >= 240 & hcount <= 250 & vcount >= 160 & vcount <= 200);
	assign min_1[3] = ~blank & (hcount >= 200 & hcount <= 250 & vcount >= 205 & vcount <= 215);
	assign min_1[4] = ~blank & (hcount >= 200 & hcount <= 210 & vcount >= 160 & vcount <= 200);
	assign min_1[5] = ~blank & (hcount >= 200 & hcount <= 210 & vcount >= 115 & vcount <= 155);
	assign min_1[6] = ~blank & (hcount >= 215 & hcount <= 235 & vcount >= 153 & vcount <= 163);
	
	assign min_0[0] = ~blank & (hcount >= 260 & hcount <= 310 & vcount >= 100 & vcount <= 110);
	assign min_0[1] = ~blank & (hcount >= 300 & hcount <= 310 & vcount >= 115 & vcount <= 155);
	assign min_0[2] = ~blank & (hcount >= 300 & hcount <= 310 & vcount >= 160 & vcount <= 200);
	assign min_0[3] = ~blank & (hcount >= 260 & hcount <= 310 & vcount >= 205 & vcount <= 215);
	assign min_0[4] = ~blank & (hcount >= 260 & hcount <= 270 & vcount >= 160 & vcount <= 200);
	assign min_0[5] = ~blank & (hcount >= 260 & hcount <= 270 & vcount >= 115 & vcount <= 155);
	assign min_0[6] = ~blank & (hcount >= 275 & hcount <= 295 & vcount >= 153 & vcount <= 163);
	
	assign sec_1[0] = ~blank & (hcount >= 340 & hcount <= 390 & vcount >= 100 & vcount <= 110);
	assign sec_1[1] = ~blank & (hcount >= 380 & hcount <= 390 & vcount >= 115 & vcount <= 155);
	assign sec_1[2] = ~blank & (hcount >= 380 & hcount <= 390 & vcount >= 160 & vcount <= 200);
	assign sec_1[3] = ~blank & (hcount >= 340 & hcount <= 390 & vcount >= 205 & vcount <= 215);
	assign sec_1[4] = ~blank & (hcount >= 340 & hcount <= 350 & vcount >= 160 & vcount <= 200);
	assign sec_1[5] = ~blank & (hcount >= 340 & hcount <= 350 & vcount >= 115 & vcount <= 155);
	assign sec_1[6] = ~blank & (hcount >= 355 & hcount <= 375 & vcount >= 153 & vcount <= 163);
	
	assign sec_0[0] = ~blank & (hcount >= 400 & hcount <= 450 & vcount >= 100 & vcount <= 110);
	assign sec_0[1] = ~blank & (hcount >= 440 & hcount <= 450 & vcount >= 115 & vcount <= 155);
	assign sec_0[2] = ~blank & (hcount >= 440 & hcount <= 450 & vcount >= 160 & vcount <= 200);
	assign sec_0[3] = ~blank & (hcount >= 400 & hcount <= 450 & vcount >= 205 & vcount <= 215);
	assign sec_0[4] = ~blank & (hcount >= 400 & hcount <= 410 & vcount >= 160 & vcount <= 200);
	assign sec_0[5] = ~blank & (hcount >= 400 & hcount <= 410 & vcount >= 115 & vcount <= 155);
	assign sec_0[6] = ~blank & (hcount >= 415 & hcount <= 435 & vcount >= 153 & vcount <= 163);
	
	
	assign dot[0] = ~blank & (hcount >= 320 & hcount <= 330 & vcount >= 125 & vcount <= 145);
	assign dot[1] = ~blank & (hcount >= 320 & hcount <= 330 & vcount >= 170 & vcount <= 190);
	
	// send colors:
	always @ (posedge clk) begin
		if ( (min_1[0] && !num_3[0]) || (min_1[1] && !num_3[1]) || (min_1[2] && !num_3[2]) || (min_1[3] && !num_3[3]) || (min_1[4] && !num_3[4]) || (min_1[5] && !num_3[5]) || (min_1[6] && !num_3[6]) ||
			  (min_0[0] && !num_2[0]) || (min_0[1] && !num_2[1]) || (min_0[2] && !num_2[2]) || (min_0[3] && !num_2[3]) || (min_0[4] && !num_2[4]) || (min_0[5] && !num_2[5]) || (min_0[6] && !num_2[6]) ||
			  (sec_1[0] && !num_1[0]) || (sec_1[1] && !num_1[1]) || (sec_1[2] && !num_1[2]) || (sec_1[3] && !num_1[3]) || (sec_1[4] && !num_1[4]) || (sec_1[5] && !num_1[5]) || (sec_1[6] && !num_1[6]) ||
			  (sec_0[0] && !num_0[0]) || (sec_0[1] && !num_0[1]) || (sec_0[2] && !num_0[2]) || (sec_0[3] && !num_0[3]) || (sec_0[4] && !num_0[4]) || (sec_0[5] && !num_0[5]) || (sec_0[6] && !num_0[6]) ||
			  dot
			 ) begin	// if you are within the valid region
			R = 1;
			G = 0;
			B = 0;
		end
		else begin
			R = 0;
			G = 0;
			B = 0;
		end
		/*if ((min_0[0] && !num_2[0]) || (min_0[1] && !num_2[1]) || (min_0[2] && !num_2[2]) || (min_0[3] && !num_2[3]) || (min_0[4] && !num_2[4]) || (min_0[5] && !num_2[5]) || (min_0[6] && !num_2[6])) begin
			R = 0;
			G = 0;
			B = 1;
		end
		
		if ((sec_1[0] && !num_1[0]) || (sec_1[1] && !num_1[1]) || (sec_1[2] && !num_1[2]) || (sec_1[3] && !num_1[3]) || (sec_1[4] && !num_1[4]) || (sec_1[5] && !num_1[5]) || (sec_1[6] && !num_1[6])) begin
			R = 0;
			G = 0;
			B = 1;
		end
		
		if ((sec_0[0] && !num_0[0]) || (sec_0[1] && !num_0[1]) || (sec_0[2] && !num_0[2]) || (sec_0[3] && !num_0[3]) || (sec_0[4] && !num_0[4]) || (sec_0[5] && !num_0[5]) || (sec_0[6] && !num_0[6])) begin
			R = 1;
			G = 0;
			B = 0;
		end
		
		if (dot) begin
			R = 1;
			G = 1;
			B = 1;
		end*/
	end

endmodule