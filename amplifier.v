module amplifier(clk, AIN, GAIN, NC, ACTIVE);
  input clk;
  input GAIN;
  input NC;
  input ACTIVE;

  output AIN;

  reg [15:0] counter;
  
  // used for simulation purposes
  initial begin
	  counter = 0;
  end
  
  always @ (posedge clk)
    counter <= counter + 1;

  assign AIN = counter[15];
endmodule