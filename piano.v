module piano
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    RST, PLAYBACK, UP, DOWN,
    AIN, GAIN, NC, ACTIVE
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
  
  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;

  wire clk_256;

  clocks clks(.clk_100M(clk),
    .clk_256(clk_256)
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

  reg [2:0] octave_sel;
  reg [2:0] octave_played;
  reg [2:0] note_played;

  reg [5:0] buffer [255:0];
  reg [7:0] idx_wr;  // Write index
  reg [7:0] idx_pb;  // Playback index
  reg [31:0] clk_dv_pb;

  reg [6:0] note_switches_prev;
  reg toggle_pb_prev;
  reg inc_octave_prev;
  reg dec_octave_prev;

  reg pb_mode;
  
  // amplifier module
  amplifier amp(.clk(clk), .octave(octave_played), .note(note_played), .AIN(AIN), .GAIN(GAIN), .NC(NC), .ACTIVE(ACTIVE));
  //amplifier amp(.clk(clk), .AIN(AIN), .GAIN(GAIN), .NC(NC), .ACTIVE(ACTIVE));

  integer i;
  always @ (posedge clk) begin
    if (rst) begin
      // Clear recording
      for (i = 0; i < 256; i = i + 1) begin
        buffer[i] <= 6'b0;
      end
      idx_wr <= 8'b0;
      idx_pb <= 8'b0;
      clk_dv_pb <= 32'b1;

      // Reset currently selected octave, last octave and note
      octave_sel = 3'd4;
      octave_played = 3'd0;
      note_played = 3'd0;

      // Reset to recording mode
      pb_mode = 1'b0;
    end else begin
      // Update currently selected octave
      if (octave_sel < 3'd7 && inc_octave && !inc_octave_prev) begin
        octave_sel = octave_sel + 3'b1;
      end
      if (octave_sel > 3'd1 && dec_octave && !dec_octave_prev) begin
        octave_sel = octave_sel - 3'b1;
      end

      // Toggle mode
      if (toggle_pb && !toggle_pb_prev) begin
        idx_pb <= 8'b0;
        clk_dv_pb <= 32'b1;
        pb_mode = !pb_mode;
      end

      if (pb_mode) begin
        // TODO: Play back recording
        if (clk_dv_pb >= 32'd25000000) begin
          //idx_pb = idx_pb + 1;
          if (idx_pb + 1 == idx_wr) begin
            // End of recording reached
            pb_mode = 1'b0;
          end
          idx_pb <= idx_pb + 8'b1;

          clk_dv_pb <= 1;
        end else begin
          clk_dv_pb <= clk_dv_pb + 1;
        end
      end else if (note_switches != note_switches_prev) begin
        // Switch state has changed
        case (note_switches)
          7'b1000000: note_played = 3'd1;
          7'b0100000: note_played = 3'd2;
          7'b0010000: note_played = 3'd3;
          7'b0001000: note_played = 3'd4;
          7'b0000100: note_played = 3'd5;
          7'b0000010: note_played = 3'd6;
          7'b0000001: note_played = 3'd7;
          default: note_played = 3'd0;
        endcase

        if (|note_played) begin
          // Write note to buffer
          octave_played = octave_sel;
          buffer[idx_wr] = {octave_played, note_played};
          idx_wr <= idx_wr + 8'b1;
          // TODO: Play note
        end
      end
    end

    note_switches_prev <= note_switches;
    toggle_pb_prev <= toggle_pb;
    inc_octave_prev <= inc_octave;
    dec_octave_prev <= dec_octave;
  end
endmodule
