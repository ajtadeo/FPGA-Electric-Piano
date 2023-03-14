module amplifier(clk, octave, note, AIN, GAIN, NC, ACTIVE);
  input clk;
  input [2:0] octave;
  input [2:0] note;

  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;

  // reg [27:0] tone;
  
  // // used for simulation purposes
  // initial begin
	//   tone = 0;
  // end
  
  // always @ (posedge clk)
  //   tone <= tone + 1;

  reg [8:0] clkdivider;
  parameter clkspeed = 100000000;

  // maybe remove always block
  always @ (note)
    case (note)
      // 0: clkdivider = clkspeed / 512 / 28 - 1; // A0
      // 1: clkdivider = clkspeed / 512 / 31 - 1; // B0
      // 2: clkdivider = clkspeed / 512 / 33 - 1; // C1
      // 3: clkdivider = clkspeed / 512 / 37 - 1; // D1
      // 4: clkdivider = clkspeed / 512 / 41 - 1; // E1
      // 5: clkdivider = clkspeed / 512 / 44 - 1; // F1
      // 6: clkdivider = clkspeed / 512 / 49 - 1; // G1
      // 7: clkdivider = 0;
      0: clkdivider = 0; // invalid
      1: clkdivider = clkspeed / 512 / 33 - 1; // C1
      2: clkdivider = clkspeed / 512 / 37 - 1; // D1
      3: clkdivider = clkspeed / 512 / 41 - 1; // E1
      4: clkdivider = clkspeed / 512 / 44 - 1; // F1
      5: clkdivider = clkspeed / 512 / 49 - 1; // G1
      6: clkdivider = clkspeed / 512 / 28 - 1; // A0
      7: clkdivider = clkspeed / 512 / 31 - 1; // B0
    endcase

  reg [8:0] counter_note;
  
  always @ (posedge clk) 
    if (counter_note == 0) counter_note <= clkdivider; 
    else counter_note <= counter_note - 1;

  reg [7:0] counter_octave;

  always @ (posedge clk)
    if (counter_note == 0)
      begin 
        if (counter_octave == 0) begin
          case(octave)
            0: counter_octave <= 255;
            1: counter_octave <= 127;
            2: counter_octave <= 63;
            3: counter_octave <= 31;
            4: counter_octave <= 15;
            5: counter_octave <= 7;
            6: counter_octave <= 3;
            7: counter_octave <= 1;
          endcase
        end else
          counter_octave <= counter_octave-1;
      end

  reg speaker;
  always @ (posedge clk) 
    if (counter_note == 0 && counter_octave == 0) 
      speaker <= ~speaker;

  assign AIN = speaker & (tone[5:0] == 0); // play at a quieter volume
  assign GAIN = 1; // high GAIN plays sound at a lower db
  assign NC = 0;
  assign ACTIVE = 1;
endmodule