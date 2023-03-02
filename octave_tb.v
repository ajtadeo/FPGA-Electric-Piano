// Code your testbench here
// or browse Examples
module tb;
  reg clk;
  reg [1:0]select;
  reg [2:0] current;
  wire [2:0] out;
  octave otb(.select(select), .current(current), .clk(clk), .out(out));
  
  initial begin
    clk = 0;
    select = 0;
    current = 4;
  end
  
  always #10 clk = ~clk;
  
  initial begin
    select = 1;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 1;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 1;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 1;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    
    select = 2;
    #100
    current = out;
    $display("select: %d\tout: %d", select, out);
    $finish;
  end
endmodule