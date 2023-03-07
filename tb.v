module tb;
  reg clk;
  wire AIN;
  wire GAIN;
  wire NC;
  wire ACTIVE;

  amplifier amp(.clk(clk), .AIN(AIN), .GAIN(GAIN), .NC(NC), .ACTIVE(ACTIVE));

  initial begin
    clk = 0;
//    GAIN = 0;
//    NC = 0;
//    ACTIVE = 0;
    
    #500
    clk = 1;
//    ACTIVE = 1;
  end

  always #10 clk = ~clk;
endmodule