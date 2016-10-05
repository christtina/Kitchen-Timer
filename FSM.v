`timescale 1ns / 1ps
module FSM(
    input [5:0] num, // Number that either min or sec can get
    input start, pause, reset, up, clock, get_min, get_sec,
    output reg led,
	 output reg [2:0] state, // State and Next State Counter
    output reg [3:0] min_1, min_0, sec_1, sec_0 // Values of each unit place
);

initial begin
    state = IDLE;
    min_1 = 0;
    min_0 = 0;
    sec_1 = 0;
    sec_0 = 0;
    led = 0; 
end

//reg [2:0] state; // State and Next State Counter
parameter IDLE = 0, RESET = 1, GETMIN = 2, GETSEC = 3, COUNT = 4, PAUSE = 5; // PARAMETERS for our 6 STATES

always @ (posedge clock or posedge get_min or posedge get_sec) begin // Do this for button presses or clock cycle
    case (state)
        GETMIN: begin // DO when get min button is pushed
            if (reset) begin
               min_1 <= 0;
					min_0 <= 0;
					sec_1 <= 0;
					sec_0 <= 0;
					led <= 0;
					state <= IDLE; // Set next state tp IDLE
            end
            else if (num <= 59) begin
                min_0 <= num%10; //Set min_0 to the 1s place of the given number
                min_1 <= num/10; // Set min_1 to the 10s place of the given number
                state <= IDLE; // Set next state to IDLE
            end
            else begin
                min_0 <= 9;
                min_1 <= 5;
                state <= IDLE;
            end
        end
        GETSEC: begin // DO when get sec button is pushed
            if (reset) begin
               min_1 <= 0;
					min_0 <= 0;
					sec_1 <= 0;
					sec_0 <= 0;
					led <= 0;
					state <= IDLE; // Set next state tp IDLE
            end
            else if (num <= 59) begin
                sec_0 <= num%10; //Set sec_0 to the 1s place of the given number
                sec_1 <= num/10; // Set sec_1 to the 10s place of the given number
                state <= IDLE; // Set next state to IDLE
            end
            else begin
                sec_0 <= 9;
                sec_0 <= 5;
                state <= IDLE;
            end
        end
        COUNT: begin
            if (reset) begin
               min_1 <= 0;
					min_0 <= 0;
					sec_1 <= 0;
					sec_0 <= 0;
					led <= 0;
					state <= IDLE; // Set next state tp IDLE
            end
            else if (pause) begin
                state <= PAUSE; //NEXT STATE PAUSE
            end
            else if (up) begin // If the counter is going UP
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
            end //NEXT STATE WILL BE COUNT
            
            else if (!up) begin // If the Counter is going DOWN
                if (!sec_0 && !sec_1 && !min_0 && !min_1) begin // Check for the case where the counter should STOP COUNTING
                    led <= 1; // LIGHT the led
                    state <= IDLE; // Next state is IDLE
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
            end //NEXT STATE COUNT
        
        end
        PAUSE: begin //DO when pause is pushed
            if (reset) begin
               min_1 <= 0;
					min_0 <= 0;
					sec_1 <= 0;
					sec_0 <= 0;
					led <= 0;
					state <= IDLE; // Set next state tp IDLE
            end
            else if (pause) begin // Unless pause is pushed again
                state <= COUNT; //NEXT STATE COUNT
            end
        end
        IDLE: begin
            if (reset) begin
					min_1 <= 0;
					min_0 <= 0;
					sec_1 <= 0;
					sec_0 <= 0;
					led <= 0;
					state <= IDLE; // Set next state tp IDLE
            end
            else if(get_min) begin
                state <= GETMIN;
            end
            else if (get_sec) begin
                state <= GETSEC;
            end
            else if (start) begin
                led <= 0; // Set LED to 0
                state <= COUNT; // Go to COUNTING State
            end
				else begin
					state <= IDLE;
				end
        end
        default: begin // Default state will always be IDLE
            state <= IDLE;
        end
    endcase
end

endmodule