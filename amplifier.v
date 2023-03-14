module amplifier(clk, octave, note, AIN, GAIN, NC, ACTIVE);
  input clk;
  input [2:0] octave;
  input [2:0] note;

  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;
  
  reg [63:0] counter_note;
  reg [63:0] clkdivider;
  reg [63:0] clkcoef;
  parameter clkspeed = 100000000;

  always @ (posedge clk) begin
    case (note)
      0: clkdivider = 0; // invalid
      1: clkdivider = clkspeed / 33; // C1
      2: clkdivider = clkspeed / 37; // D1
      3: clkdivider = clkspeed / 41; // E1
      4: clkdivider = clkspeed / 44; // F1
      5: clkdivider = clkspeed / 49; // G1
      6: clkdivider = clkspeed / 55; // A1
      7: clkdivider = clkspeed / 62; // B1
    endcase
    case(octave)
      0: clkcoef <= 1;
      1: clkcoef <= 1;
      2: clkcoef <= 2;
      3: clkcoef <= 4;
      4: clkcoef <= 8;
      5: clkcoef <= 16;
      6: clkcoef <= 32;
      7: clkcoef <= 64;
    endcase
    clkdivider = clkdivider / clkcoef;
  end    
  
  always @ (posedge clk) 
    if (counter_note >= clkdivider) counter_note <= 1; 
    else counter_note <= counter_note + 1;

  reg speaker;
  always @ (posedge clk)
    if (counter_note == 1) begin
      speaker <= ~speaker;
    end

  assign AIN = speaker; // play at a quieter volume
  assign GAIN = 1; // high GAIN plays sound at a lower db
  assign NC = 0;
  assign ACTIVE = 1;
endmodule
/*
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
  divide_by12 divby12(.numer(fullnote[5:0]), .quotient(octave), .remain(note));

  reg [8:0] clkdivider;
  always @ (note)
    case (note)
      0: clkdivider = 512-1; // A
      1: clkdivider = 483-1; // A#/Bb
      2: clkdivider = 456-1; // B
      3: clkdivider = 431-1; // C
      4: clkdivider = 406-1; // C#/Db
      5: clkdivider = 384-1; // D
      6: clkdivider = 362-1; // D#/Eb
      7: clkdivider = 342-1; // E
      8: clkdivider = 323-1; // F
      9: clkdivider = 304-1; // F#/Gb
      10: clkdivider = 287-1; // G
      11: clkdivider = 271-1; // G#/Ab
      12: clkdivider = 0; // should never happen
      13: clkdivider = 0; // should never happen
      14: clkdivider = 0; // should never happen
      15: clkdivider = 0; // should never happen
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
*/