`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 05:43:34 PM
// Design Name: 
// Module Name: RisingEdge
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


module RisingEdge (input clk, in, rst, output out);

reg [1:0] state;
reg [1:0] nextstate;
parameter [1:0] A=2'b00, B=2'b01, C=2'b10;

always @(posedge clk) begin
case(state)
A: if(in == 1) nextstate = B;
    else nextstate = A;
B:  if(in == 1) nextstate = C;
    else nextstate = A;
C:  if(in == 1) nextstate = C;
    else nextstate = A;
default: nextstate = A;
endcase
end

always @(posedge clk or posedge rst) begin
if(rst == 1) 
state <= A;
else
state <= nextstate;
end

assign out = (state == B);

endmodule
