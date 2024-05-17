`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 06:50:48 PM
// Design Name: 
// Module Name: PushDownButton
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


module PushDownButton(input button, clk, rst, output out);

wire med;
wire med2;
Debouncer Deb(.clk(clk),.rst(rst),.in(button),.out(med));
Synchronizer Sync(.SIG(med),.clk(clk),.SIG1(med2));
RisingEdge Edge(.clk(clk),.in(med2),.rst(rst),.out(out));
endmodule
