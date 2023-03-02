// note: doubling a frequency = increasing octave, dividing by 2 = decreasing octave
/*
  select
    00 = do nothing
    01 = increase octave
    10 = decrase octave
  current/out octave
    000 = x
    001 = 1
    010 = 2
    011 = 3
    100 = 4
    101 = 5
    110 = 6
    111 = 7
*/
module octave(select, current, clk, out);
  input clk; 
  input [1:0] select; // 00 = do nothing, 01 = increase, 10 = decrease
  input [2:0] current; // current octave
  output reg [2:0] out; // 7 octaves = 3 bits

  always @ (posedge clk) begin
    if (select == 2'b00) begin
      out <= current;
    end 
    else if (select == 2'b01) begin 
      if (current < 7)
        out <= current + 1;
      else
        out <= current;
    end 
    else if (select == 2'b10) begin 
      if (current > 1)
        out <= current - 1;
      else
        out <= current;
    end 
  end
endmodule