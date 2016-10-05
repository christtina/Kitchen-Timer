`timescale 1ns / 1ps

module fsm(
	input [5:0] num, // Number that either min or sec can get
	input start, fast, pause, reset, up, clock, get_min, get_sec,
	output reg led,
	output [15:0] big_bin
    );

always @ (posedge clock or posedge reset) begin
    
	 ticker2 <= ticker;
	 
    if (reset) begin // RESET
        min_1 <= 0;  // Set ALL variables to 0
        min_0 <= 0;
        sec_1 <= 0;
        sec_0 <= 0;
        led <= 0;
        ticker <= 0;
    end
    
    else if (ticker2) begin // IF WE SHOULD BE COUNTING
    
        if (up) begin // If the counter is going UP
            if (sec_0 == 9) begin // Check each min and sec box and decide if it should be increased or go to its next value
                sec_0 <= 0;
                if (sec_1 == 5) begin
                    sec_1 <= 0;
                    if (min_0 == 9) begin
                        min_0 <= 0;
                        if (min_1 == 5) begin
                            min_1 <= 0;
                        end
                        else begin
                            min_1 <= min_1 + 1;
                        end
                    end
                    else begin
                        min_0 <= min_0 + 1;
                    end
                end
                else begin
                    sec_1 <= sec_1 + 1;
                end
            end
            else begin
                sec_0 <= sec_0 + 1;
            end
        end
        
        else if (!up) begin // If the Counter is going DOWN
            if (!sec_0 && !sec_1 && !min_0 && !min_1) begin // Check for the case where the counter should STOP COUNTING
                led <= 1; // LIGHT the led
					 ticker2 <= 0; // STOP COUNTING
					 state = IDLE; // Next state is IDLE
            end
            else if (sec_0 == 0) begin // Check each min and sec box and decide if it should be decreased or go to its next value
                sec_0 <= 9;
                if (sec_1 == 0) begin
                    sec_1 <= 5;
                    if (min_0 == 0) begin
                        min_0 <= 9;
                        if (min_1 == 0) begin
                            min_1 <= 5;
                        end
                        else begin
                            min_1 <= min_1 - 1;
                        end 
                    end
                    else begin
                        min_0 <= min_0 - 1;
                    end
                end
                else begin
                    sec_1 <= sec_1 - 1;
                end
            end
            else begin
                sec_0 <= sec_0 - 1;
            end
        end
    end
    
end


endmodule
