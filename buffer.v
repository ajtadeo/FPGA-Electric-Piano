module note_buffer
  {
    clk, rst, add, next_note, pb_note
  };

  input clk;
  input rst;
  input add;
  input [5:0] next_note;

  output [5:0] pb_note;

  reg [5:0] buffer [255:0];

  reg [7:0] idx;
  reg [7:0] idx_pb;

  integer i;

  always @ (posedge add) begin
    buffer[idx] = next_note;
    idx <= idx + 1;
  end

  always @ (posedge clk) begin
    if (rst) begin
      for (i = 0; i < 256; i = i + 1) begin
        buffer[i] <= 6'b0;
      end

      pb_note <= 6'b0;
      idx <= 8'b0;
      idx_pb <= 8'b0;
    end else if (pb_mode) begin
      pb_note = buffer[idx_pb];
      idx_pb = idx_pb + 8'b1;

      if (idx_pb == idx) begin
        idx_pb = 8'b0;
      end
    end
  end
endmodule
