module piano
  (
    clk,
    SW_C, SW_D, SW_E, SW_F, SW_G, SW_A, SW_B,
    RST, PLAYBACK, UP, DOWN,
    AIN, GAIN, NC, ACTIVE,
    ANODE, CATHODE
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

  wire clk_250;
  wire clk_1M;

  clocks clks(.clk_100M(clk),
    .clk_250(clk_250), .clk_1M(clk_1M)
  );

  wire rst;
  wire [6:0] note_switches;
  wire toggle_pb;
  wire inc_octave;
  wire dec_octave;

  debounced inputs(.clk(clk_250),
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
  reg [31:0] clk_dv_rec;

  reg [5:0] buffer [255:0];
  reg [7:0] idx_wr;  // Write index
  reg [7:0] idx_pb;  // Playback index
  reg [31:0] clk_dv_pb;

  reg [6:0] note_switches_prev;
  reg toggle_pb_prev;
  reg inc_octave_prev;
  reg dec_octave_prev;

  reg pb_mode;

  reg [2:0] octave_prev;
  reg [2:0] note_prev;

  integer i;
  always @ (posedge clk_1M) begin
    if (rst) begin
      // Clear recording
      for (i = 0; i < 256; i = i + 1) begin
        buffer[i] <= 6'b0;
      end
      idx_wr <= 8'b0;
      idx_pb <= 8'b0;
      clk_dv_rec <= 32'd1000000;
      clk_dv_pb <= 32'd1;

      // Reset currently selected octave, last octave and note
      octave_sel = 3'd4;
      octave_played = 3'd0;
      note_played = 3'd0;
      octave_prev = 3'd0;
      note_prev = 3'd0;

      // Reset to recording mode
      pb_mode = 1'b0;
    end else begin
      // Update currently selected octave
      if (octave_sel < 3'd7 && inc_octave && !inc_octave_prev) begin
        octave_sel = octave_sel + 3'd1;
      end
      if (octave_sel > 3'd1 && dec_octave && !dec_octave_prev) begin
        octave_sel = octave_sel - 3'd1;
      end

      // Toggle mode
      if (toggle_pb && !toggle_pb_prev) begin
        idx_pb <= 8'b0;
        clk_dv_pb <= 32'd1;
        pb_mode = !pb_mode;
      end

      if (pb_mode) begin
        if (clk_dv_pb >= 32'd250000) begin
          if (idx_pb + 1 >= idx_wr) begin
            // End of recording reached
            pb_mode = 1'b0;
          end

          octave_played = buffer[idx_pb][5:3];
          note_played = buffer[idx_pb][2:0];

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

          octave_prev = octave_played;
          note_prev = note_played;

          clk_dv_rec <= 32'd1;
        end
      end else begin
        if (clk_dv_rec >= 32'd1000000) begin
          octave_played = 3'd0;
          note_played = 3'd0;
        end else begin
          clk_dv_rec <= clk_dv_rec + 1;
        end
      end
    end

    note_switches_prev <= note_switches;
    toggle_pb_prev <= toggle_pb;
    inc_octave_prev <= inc_octave;
    dec_octave_prev <= dec_octave;
  end
  
  // Amplifier module
  amplifier amp(.clk_100M(clk), .octave(octave_played), .note(note_played),
    .AIN(AIN), .GAIN(GAIN), .NC(NC), .ACTIVE(ACTIVE)
  );

  // Display modules

  wire [7:0] display_note_prev;
  wire [7:0] display_octave_prev;
  wire [7:0] display_octave_curr;

  note_display d_note_p(.clk(clk), .note(note_prev),
    .display(display_note_prev)
  );
  octave_display d_octave_p(.clk(clk), .octave(octave_prev),
    .display(display_octave_prev)
  );
  octave_display d_octave_c(.clk(clk), .octave(octave_sel),
    .display(display_octave_curr)
  );

  reg [1:0] display_select;
  always @ (posedge clk_250) begin
    if (select == 0) begin
      ANODE <= 4'b0111;
      CATHODE <= display_note_prev;
    end else if (select == 1) begin
      ANODE <= 4'b1011;
      CATHODE <= display_octave_prev;
    end else if (select == 2) begin
      ANODE <= 4'b1101;
      CATHODE <= 8'b11111111;
    end else if (select == 3) begin
      ANODE <= 4'b1110;
      CATHODE <= display_octave_curr;
    end
    select <= select + 1;
  end
endmodule
