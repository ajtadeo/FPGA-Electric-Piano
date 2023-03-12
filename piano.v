module piano
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    RST, PLAYBACK, UP, DOWN
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
    .RST(RST), .PLAYBACK(PLAYBACK),
    .UP(UP), .DOWN(DOWN),
    .note_switches(note_switches),
    .rst(rst), .toggle_pb(toggle_pb),
    .inc_octave(inc_octave), .dec_octave(dec_octave)
  );

  reg [2:0] octave;
  reg [2:0] octave_prev;
  reg [2:0] note_prev;

  reg [5:0] buffer [255:0];
  reg [7:0] idx;

  reg [6:0] note_switches_prev;
  reg toggle_pb_prev;
  reg inc_octave_prev;
  reg dec_octave_prev;

  integer i;
  always @ (posedge clk) begin
    if (rst) begin
      // Clear recording
      for (i = 0; i < 256; i = i + 1) begin
        buffer[i] <= 6'b0;
      end
      idx <= 8'b0;

      // Reset currently selected octave, last note and octave
      octave <= 3'd4;
      octave_prev <= 3'd0;
      note_prev <= 3'd0;

      // Reset to recording mode
      pb_mode <= 1'b0;
    end else begin
      // Update currently selected octave
      if (octave < 3'd7 && inc_octave && !inc_octave_prev) begin
        octave = octave + 1;
      end
      if (octave > 3'd1 && dec_octave && !dec_octave_prev) begin
        octave = octave - 1;
      end

      // Toggle mode
      if (toggle_pb && !toggle_pb_prev) begin
        pb_mode = !pb_mode;
        // TODO: DO CLEANUP IF NECESSARY
      end

      if (pb_mode) begin
        // IF IN PLAYBACK MODE
        // TODO: DO STUFF
        // TODO: RESET pb_mode to 0 WHEN DONE PLAYING
      end else if (note_switches != note_switches_prev) begin
        // Switches have changed
        // TODO: Play note
        // TODO: Save note
      end else begin
        // Switches have not changed, not in pb_mode
        // TODO: Maybe do stuff here
      end
    end

    note_switches_prev <= note_switches;
    toggle_pb_prev <= toggle_pb;
    inc_octave_prev <= inc_octave;
    dec_octave_prev <= dec_octave;
  end
endmodule
