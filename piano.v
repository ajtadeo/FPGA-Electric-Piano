module piano
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    BTN_R, BTN_L, BTN_U, BTN_D
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

  wire clk_1;
  wire clk_2;
  wire clk_4;
  wire clk_256;

  clocks clks(.clk_100M(clk),
    .clk_1(clk_1), .clk_2(clk_2), .clk_4(clk_4), .clk_256(clk_256)
  );

  wire rst;
  wire [6:0] note_switches;
  wire toggle_pb;
  wire inc_octave;
  wire dec_octave;

  debounced inputs(.clk(clk_256),
    .SW_C(SW_C),
    .SW_D(SW_D),
    .SW_E(SW_E),
    .SW_F(SW_F),
    .SW_G(SW_G),
    .SW_A(SW_A),
    .SW_B(SW_B),
    .BTN_R(BTN_R), .BTN_L(BTN_L),
    .BTN_U(BTN_U), .BTN_D(BTN_D),
    .note_switches(note_switches),
    .rst(rst), .toggle_pb(toggle_pb),
    .inc_octave(inc_octave), .dec_octave(dec_octave)
  );

  wire add;
  reg [5:0] next_note;
  wire pb_note;

  note_buffer recording(.clk(clk), .rst(rst),
    .add(add), .next_note(next_note), .pb_note(pb_note)
  );

  reg pb_mode;
  reg pb_next_mode;

  always @ (posedge toggle_pb) begin
    pb_next_mode <= !pb_mode;
  end

  always @ (posedge ^note_switches or posedge ~^note_switches) begin
    if (!pb_mode) begin
      // PLAY NOTE & SAVE NOTE
    end
  end

  reg [7:0] pb_state;
  always @ (posedge clk) begin
    if (rst) begin
      pb_mode <= 1'b0;
      // RESET OCTAVE
    end else begin
      pb_mode <= pb_next_mode;
      if (pb_mode) begin
        // DO STUFF
      end else begin
        // DO STUFF
      end
    end
  end
endmodule
