module clocks(clk_100M, clk_256);
  input clk_100M;

  output reg clk_256;

  reg [31:0] clk_dv_256;

  always @ (posedge clk_100M) begin
    if (clk_dv_256 >= 32'd390625) begin
      clk_dv_256 = 1;
    end else begin
      clk_dv_256 = clk_dv_256 + 1;
    end
    clk_256 = ~|clk_dv_256;
  end
endmodule
