module debounced
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    RST, PLAYBACK, UP, DOWN,
    note_switches, rst, toggle_pb, inc_octave, dec_octave
  );

  input clk;

  input SW_C;
  input SW_D;
  input SW_E;
  input SW_F;
  input SW_G;
  input SW_A;
  input SW_B;

  input RST;
  input PLAYBACK;
  input UP;
  input DOWN;

  output reg [6:0] note_switches;

  output reg rst;
  output reg toggle_pb;
  output reg inc_octave;
  output reg dec_octave;

  always @ (posedge clk) begin
    note_switches <= {
      SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B
    };
    
    rst <= RST;
    toggle_pb <= PLAYBACK;
    inc_octave <= UP;
    dec_octave <= DOWN;
  end
endmodule
