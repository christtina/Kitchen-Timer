module k_clock_delay(
    input clk,
    output reg k_clk
);
///////////////////////////////////////////////////////////////////////////////
//
// Converts the 100MHz clock into a 1kHz clock
//
///////////////////////////////////////////////////////////////////////////////

//17 bit counter that is initialized to 0 and a clock that starts at 0
reg [16:0] count;
initial count = 0;
initial k_clk = 0;

//Time conversion
always @(posedge clk) begin
	//counter counts up to every millisecond and then make the clock tick
    count <= count + 1;
    if (count == 100000) begin
        k_clk <= ~k_clk;
        count <= 1;
    end 
end

endmodule
