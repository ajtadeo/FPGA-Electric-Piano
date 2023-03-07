module debounced
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    BTN_R, BTN_L, BTN_U, BTN_D,
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

  input BTN_R;
  input BTN_L;
  input BTN_U;
  input BTN_D;

  output reg [6:0] note_switches;

  output reg rst;
  output reg toggle_pb;
  output reg inc_octave;
  output reg dec_octave;

  always @ (posedge clk) begin
    note_switches <= {
      SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B
    };
    
    rst <= BTN_R;
    toggle_pb <= BTN_L;
    inc_octave <= BTN_U;
    dec_octave <= BTN_D;
  end
endmodule
