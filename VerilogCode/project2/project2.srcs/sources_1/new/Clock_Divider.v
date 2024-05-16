`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 12:26:17 PM
// Design Name: 
// Module Name: Clock_Divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Clock_Divider #(parameter n = 50000000)(input clk, rst, output reg clk_out);

parameter WIDTH = $clog2(n);
reg [WIDTH-1:0] count;

always @ (posedge clk, posedge rst) begin
if(rst == 1'b1) 
count  <= 0;
else if (count == n-1)
count <= 0;
else
count <= count +1;
end

always @ (posedge clk, posedge rst) begin

if(rst)
clk_out  <= 0;
else if (count == n-1)
clk_out <= ~clk_out;
end
endmodule
