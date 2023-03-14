module amplifier(clk_100M, octave, note, AIN, GAIN, NC, ACTIVE);
  input clk_100M;
  input [2:0] octave;
  input [2:0] note;

  output AIN;
  output GAIN;
  output NC;
  output ACTIVE;
  
  reg [31:0] counter;
  reg [31:0] clk_dv_max;
  reg [31:0] clk_dv_max_base;

  always @ (posedge clk_100M) begin
    case (note)
      0: clk_dv_max_base = 32'd4294967295; // invalid
      1: clk_dv_max_base = 32'd1528902; // C1
      2: clk_dv_max_base = 32'd1362097; // D1
      3: clk_dv_max_base = 32'd1213491; // E1
      4: clk_dv_max_base = 32'd1145383; // F1
      5: clk_dv_max_base = 32'd1020420; // G1
      6: clk_dv_max_base = 32'd909091; // A1
      7: clk_dv_max_base = 32'd809908; // B1
    endcase
    clk_dv_max <= clk_dv_max_base >> octave;
  end    
  
  reg speaker;
  always @ (posedge clk_100M) 
    if (counter >= clk_dv_max) begin
      speaker <= ~speaker;
      counter <= 1;
    end else begin
      counter <= counter + 1;
    end

  assign AIN = speaker;
  assign GAIN = 1; // high GAIN plays sound at a lower db
  assign NC = 0;
  assign ACTIVE = 1;
endmodule
