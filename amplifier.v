module amplifier(clk, AIN, GAIN, NC, ACTIVE);
  input clk;
  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;

  reg [15:0] counter;
  
  // used for simulation purposes
  initial begin
	  counter = 0;
  end
  
  always @ (posedge clk)
    counter <= counter + 1;

  assign AIN = counter[15] & (counter[5:0] == 0); // play at a quieter volume
  assign GAIN = 1; // high GAIN plays sound at a lower db
  assign NC = 0;
  assign ACTIVE = 1;
endmodule