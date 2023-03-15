module clocks(clk_100M, clk_250, clk_1M);
  input clk_100M;

  output reg clk_250;
  output reg clk_1M;

  reg [31:0] clk_dv_250;
  reg [31:0] clk_dv_1M;

  always @ (posedge clk_100M) begin
    if (clk_dv_250 >= 32'd400000) begin
      clk_dv_250 = 1;
    end else begin
      clk_dv_250 = clk_dv_250 + 1;
    end
    clk_250 = (clk_dv_250 == 32'd1);
  end

  always @ (posedge clk_100M) begin
    if (clk_dv_1M >= 32'd100) begin
      clk_dv_1M = 1;
    end else begin
      clk_dv_1M = clk_dv_1M + 1;
    end
    clk_1M = (clk_dv_1M == 32'd1);
  end
endmodule
