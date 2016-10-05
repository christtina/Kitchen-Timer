`timescale 1ns / 1ps
module debugger(
	input clk, clock, up, reset, pause, start, get_min, get_sec, //user inputs
	input [5:0] num, //number the user want to start counting
	output reg led, //led that displays when count if finished
	output reg [3:0] min_1, min_0, sec_1, sec_0 //output of timer
);

///////////////////////////////////////////////////////////////////////////
//
// FSM for timer in which it does all the restart, start, pause, get_min,
// get_sec, and count operations.
//
//////////////////////////////////////////////////////////////////////////

//initializing output variables and wires 
initial begin
	min_1 = 0;
	min_0 = 0;
	sec_1 = 0;
	sec_0 = 0;
	move = 1;
	led = 0;
	tick = 1;
end

//declaring FSM registers 
reg move, strt, tick;
reg [5:0] min, sec;

always @(posedge clk) begin

	if (reset) begin // RESET
		min <= 0;
		sec <= 0;
		move <= 1;
		strt <= 0;
		led <= 0;
	end
	
	
	else if (start) begin // GO TO COUNT STATE
		strt <= 1;
	end
	
	
	else if (pause) begin // PAUSE STATE
		move <= ~move;
	end
	
	
	else if (clock && up && tick && move && strt) begin // COUNT UP STATE
		tick <= 0;
		led <= 0;
		if (sec < 59) begin
			sec <= sec + 1;
		end
		else if (sec == 59 && min < 59) begin
			sec <= 0;
			min <= min + 1;
		end
		else if (sec == 59 && min == 59) begin
			sec <= 0;
			min <= 0;
		end
	end
	
	
	else if (clock && !up && tick && move && strt) begin // COUNT DOWN STATE
		tick <= 0;
		led <= 0;
		if (sec > 0) begin
			sec <= sec - 1;
		end
		else if (sec == 0 && min > 0) begin
			sec <= 59;
			min <= min - 1;
		end
		else if (min == 0 && sec == 0) begin
			led <= 1;
		end
	end
	
	
	else if (get_min && !strt) begin // GETMIN STATE
		if (num <= 59) begin
			min <= num;
		end
		else begin
			min <= 59;
		end
	end
	
	
	else if (get_sec && !strt) begin // GETSEC STATE
		if (num <= 59) begin
			sec <= num;
		end
		else begin
			sec <= 59;
		end
	end
	
	//outputing values to the specific 4 bit bins for output
	sec_0 <= sec%10;
	sec_1 <= sec/10;
	min_0 <= min%10;
	min_1 <= min/10;
	
	//waiting for the end of the 1 second clock cycle to repeat actions
	if (!clock) begin
		tick <= 1;
	end

end



endmodule
