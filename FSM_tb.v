module FSM_tb;

    // Inputs
    reg [5:0] num;
    reg start;
    reg fast;
    reg pause;
    reg reset;
    reg up;
    reg clock;
    reg get_min;
    reg get_sec;

    // Outputs
    wire led;
    wire [3:0] min_1;
    wire [3:0] min_0;
    wire [3:0] sec_1;
    wire [3:0] sec_0;

    // Instantiate the Unit Under Test (UUT)
    FSM uut (
        .num(num),
        .start(start), 
        //.fast(fast),
        .pause(pause),
        .reset(reset), 
        .up(up),
        .clock(clock), 
        .get_min(get_min), 
        .get_sec(get_sec), 
        .led(led), 
        .min_1(min_1),
        .min_0(min_0), 
        .sec_1(sec_1), 
        .sec_0(sec_0)
    );

    initial begin
        num = 1; //sets the number to 1
        start = 0;
        //sets counting to fast
        pause = 0;
        reset = 1; //initializes minutes and seconds to 0 as well as sets led off
        up = 0;   //sets to counting down
        clock = 0;
        get_min = 0;  //not accepting minutes input
        get_sec = 0;  //not accepting seconds input
        #10 reset = 0; //reset off
        #10 get_min = 1; //takes the value of num and sets it equal to minutes, so the input time in this example is 1 minute
        #10 get_min = 0;  //turns off the minute input state
        #10 start = 1;  //starts the timer
        #10 start = 0;  //leaving start state
        //#250 fast = 0; //changes to counting regular speed
        #1 up = 1;     //counts up
        #2 start = 1; //starts again from 0 to 1
        #15 start = 0; //going to the counting state
        #47 pause = 1;  //pausing
        #5 pause = 0;
        #53 pause = 1;  //resuming
        #9 pause = 0;
        
        #10000;
    end
    always begin
        #5 clock = ~clock;
    end
      
endmodule















































































