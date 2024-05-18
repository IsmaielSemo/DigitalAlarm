`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2024 03:00:50 PM
// Design Name: 
// Module Name: Song
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


module Song(
input wire clk,
    output reg VDC
);

    reg [31:0] counter;
    reg [31:0] frequency1 = 440;  // Frequency for note A4
    reg [31:0] frequency2 = 494;  // Frequency for note B4
    reg state = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == frequency1 && state == 0) begin
            VDC <= ~VDC;
            counter <= 0;
            state <= 1;
        end else if (counter == frequency2 && state == 1) begin
            VDC <= ~VDC;
            counter <= 0;
            state <= 0;
        end
    end
endmodule
