module note_display(clk, note, display);
  input clk;
  input [2:0] note;

  output reg [7:0] display;

  always @ (posedge clk) begin
    case (note)       // .PGFEDCBA
      3'd1: display <= 8'b11000110;  // Note C
      3'd2: display <= 8'b10100001;  // Note D
      3'd3: display <= 8'b10000110;  // Note E
      3'd4: display <= 8'b10001110;  // Note F
      3'd5: display <= 8'b11000010;  // Note G
      3'd6: display <= 8'b10001000;  // Note A
      3'd7: display <= 8'b10000011;  // Note B
      default: display <= 8'b11111111;
    endcase
  end
endmodule
