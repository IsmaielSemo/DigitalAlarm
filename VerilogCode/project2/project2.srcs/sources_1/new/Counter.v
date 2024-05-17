`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 12:27:29 PM
// Design Name: 
// Module Name: Counter
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


module Counter#(parameter x = 3, n = 5000000)(input clk, reset, enable, load, [x-1:0]data, output reg[x-1:0]count);

always @(posedge clk, posedge reset) begin
if(reset == 1) begin 
count <= 0;
end
else if(load == 1) begin
count <= data;
end
else if(enable == 1) begin
if(count == n-1) begin
count <= 0;
end
else begin
count <= count +1;
end
end
end


endmodule
