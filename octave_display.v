module octave_display(clk, octave, display);
  input clk;
  input [2:0] octave;

  output reg [7:0] display;

  always @ (posedge clk) begin
    case (octave)     // .PGFEDCBA
      3'd1: display <= 8'b11111001;
      3'd2: display <= 8'b10100100;
      3'd3: display <= 8'b10110000;
      3'd4: display <= 8'b10011001;
      3'd5: display <= 8'b10010010;
      3'd6: display <= 8'b10000010;
      3'd7: display <= 8'b11111000;
      default: display <= 8'b11111111;
    endcase
  end
endmodule
