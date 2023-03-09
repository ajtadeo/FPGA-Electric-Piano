module divide_by12(numer, quotient, remain);
  input [5:0] numer;
  output [2:0] quotient;
  output [3:0] remain;

  reg [2:0] quotient;
  reg [3:0] remain_bit3_bit2;

  assign remain = {remain_bit3_bit2, numer[1:0]}; // the first 2 bits are copied through

  always @ (numer[5:2]) // and just do a divide by "3" on the remaining bits
    case (numer[5:2])
      0: begin quotient = 0; remain_bit3_bit2 = 0; end
      1: begin quotient = 0; remain_bit3_bit2 = 1; end
      2: begin quotient = 0; remain_bit3_bit2 = 2; end
      3: begin quotient = 1; remain_bit3_bit2 = 0; end
      4: begin quotient = 1; remain_bit3_bit2 = 1; end
      5: begin quotient = 1; remain_bit3_bit2 = 2; end
      6: begin quotient = 2; remain_bit3_bit2 = 0; end
      7: begin quotient = 2; remain_bit3_bit2 = 1; end
      8: begin quotient = 2; remain_bit3_bit2 = 2; end
      9: begin quotient = 3; remain_bit3_bit2 = 0; end
      10: begin quotient = 3; remain_bit3_bit2 = 1; end
      11: begin quotient = 3; remain_bit3_bit2 = 2; end
      12: begin quotient = 4; remain_bit3_bit2 = 0; end
      13: begin quotient = 4; remain_bit3_bit2 = 1; end
      14: begin quotient = 4; remain_bit3_bit2 = 2; end
      15: begin quotient = 5; remain_bit3_bit2 = 0; end
    endcase
endmodule

module amplifier(clk, AIN, GAIN, NC, ACTIVE);
  input clk;
  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;

  reg [27:0] tone;
  
  // used for simulation purposes
  initial begin
	  tone = 0;
  end
  
  always @ (posedge clk)
    tone <= tone + 1;

  wire [5:0] fullnote = tone[27:22];

  wire[2:0] octave;
  wire [3:0] note;
  divide_by12 divby12(.numer(fullnote[5:0], .quotient(octave), .remain(note)));

  reg [8:0] clkdivider;

  // C, D, E, F, G, A, B
  always @ (note)
    case (note)
    0: clkdivider = 32; // C1
    1: clkdivider = 36; // D1
    2: clkdivider = 41; // E1
    3: clkdivider = 43; // F1
    4: clkdivider = 48; // G1
    5: clkdivider = 55; // A1
    6: clkdivider = 61; // B1
    7: clkdivider = 0;
    8: clkdivider = 0;
    9: clkdivider = 0;
    10: clkdivider = 0;
    11: clkdivider = 0;
    12: clkdivider = 0;
    13: clkdivider = 0;
    14: clkdivider = 0;
    15: clkdivider = 0;
    endcase

  reg [8:0] counter_note;

  
  always @ (posedge clk) 
    if (counter_note == 0) counter_note <= clkdivider; 
    else counter_note <= counter_note - 1;

  reg [7:0] counter_octave;

  always @ (posedge clk)
    if (counter_note == 0)
      begin 
        if (counter_octave == 0)
          counter_octave <= (octave == 0 ? 255 : (octave == 1 ? 127 : (octave == 2 ? 63 : (octave == 3 ? 31 : (octave == 4 ? 15 : 7)))));
        else
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