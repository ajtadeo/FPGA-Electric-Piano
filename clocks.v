module clocks(clk_100M, clk_1, clk_2, clk_4, clk_256);
  input clk_100M;

  output reg clk_1;
  output reg clk_2;
  output reg clk_4;
  output reg clk_256;

  reg [31:0] clk_dv_256;
  reg [31:0] clk_dv_4;
  reg [31:0] clk_dv_2;
  reg [31:0] clk_dv_1;

  always @ (posedge clk_100M) begin
    if (clk_dv_256 >= 32'd390625) begin
      clk_dv_256 = 1;
    end else begin
      clk_dv_256 = clk_dv_256 + 1;
    end
    clk_256 = ~|clk_dv_256;
  end

  always @ (posedge clk_100M) begin
    if (clk_dv_4 >= 32'd25000000) begin
      clk_dv_4 = 1;
    end else begin
      clk_dv_4 = clk_dv_4 + 1;
    end
    clk_4 = ~|clk_dv_4;
  end

  always @ (posedge clk_100M) begin
    if (clk_dv_2 >= 32'd50000000) begin
      clk_dv_2 = 1;
    end else begin
      clk_dv_2 = clk_dv_2 + 1;
    end
    clk_2 = ~|clk_dv_2;
  end

  always @ (posedge clk_100M) begin
    if (clk_dv_1 >= 32'd100000000) begin
      clk_dv_1 = 1;
    end else begin
      clk_dv_1 = clk_dv_1 + 1;
    end
    clk_1 = ~|clk_dv_1;
  end
endmodule
