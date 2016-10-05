`timescale 1ns / 1ps
module Kitchen_Timer(
	input [5:0] num, // Number that is either min or sec
	input un_start, un_pause, un_reset, un_get_min, un_get_sec, //external buttons that the user presses 
	input fast, up, clk, //determines if the counter counts up/down, fast or slow
	output led, //final led that shows if the counter counts down to 0
	output [3:0] AN, //determines what segment of the fpga display is shown 
	output [6:0] disp, //actual number output for the different index in AN
	output HS, VS,
	output [2:0] R, G,
	output [1:0] B
);
/////////////////////////////////////////////
//
// Main module of Timer
//
///////////////////////////////////////////

//declaring wires
wire clock, k_clk;//clock -> clock for the counter; k_clk -> clock for the fpga display
wire reset, start, pause, get_min, get_sec; // making wires for the differnt buttons that are pressed by the user
wire [3:0] small_bin, min_1, min_0, sec_1, sec_0; //small_bin -> BCD value for min or sec; min_1 -> value for the tens place in the minutes...etc
wire [15:0] big_bin; //BCD value for min_1, min_0, sec_1, sec_0

//creating clocks
clock_delay cd0 (clk, fast, clock); //clock divider for the 1Hz clock
k_clock_delay cd1 (clk, k_clk); //clock divider for the 1KHz clock

//debouncing buttons
debouncer s (clk, un_start, start);//debouncing the start button
debouncer p (clk, un_pause, pause);//debouncing the pause button
debouncer r (clk, un_reset, reset);//debouncing the reset button
debouncer gm (clk, un_get_min, get_min);//debouncing the get_min button
debouncer gs (clk, un_get_sec, get_sec);//debouncing the get_sec button

//FSM
debugger d (clk, clock, up, reset, pause, start, get_min, get_sec, num, led, min_1, min_0, sec_1, sec_0);//FSM that determines what state the timer is in and performs necessary actions

//Concatenating output of the FSM
fakecounter fc (clock, min_1, min_0, sec_1, sec_0, big_bin);//concatenates min_1, min_0, sec_1, sec_0 into its BCD value

//Outputing  to FPGA
alternate alt (k_clk, big_bin, small_bin, AN);//alternates display of time every 1KHz so it looks like all 4 numbers are being displayed at once
bin_to_seg bts (small_bin, disp);//converts the BCD value into a 7 bit display value

VGA_display vdisplay (reset, clk, R, G, B, HS, VS, big_bin);

endmodule
