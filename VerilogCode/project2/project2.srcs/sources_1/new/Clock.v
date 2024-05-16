`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2024 12:22:55 PM
// Design Name: 
// Module Name: Clock
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

module Clock(input clk, reset, enable, output reg [6:0]segments, reg [3:0] anodes, reg [15:0] counts);

wire clk_out;
wire clk_out2;
wire clk_segments;
wire [3:0] countseconds1;
wire [3:0] countseconds2;
wire [3:0] countminutes1;
wire [3:0] countminutes2;
wire [3:0] counthours1;
wire [3:0] counthours2;
wire [6:0] segments1;
wire [6:0] segments2;
wire [6:0] segments3;
wire [6:0] segments4;
reg enableS2;
reg enableM1;
reg enableM2;
reg enableH1;
reg enableH2;
reg anodeshifter;


Clock_Divider#(50000000) Frequency_Regulator(.clk(clk),.rst(reset),.clk_out(clk_out));
Clock_Divider#(100000) Segment_frequency(.clk(clk),.rst(reset),.clk_out(clk_segments));
Counter#(4,10) Sec1(.clk(clk_out),.reset(reset),.count(countseconds1),.enable(enable),.load(1'b0),.data(4'b0000));
Counter#(4,6) Sec2(.clk(clk_out),.reset(reset),.count(countseconds2),.enable(enableS2),.load(1'b0),.data(4'b0000));
Counter#(4,10) Min1(.clk(clk_out),.reset(reset),.count(countminutes1),.enable(enableM1),.load(1'b0),.data(4'b0000));
Counter#(4,6) Min2(.clk(clk_out),.reset(reset),.count(countminutes2),.enable(enableM2),.load(1'b0),.data(4'b0000));
Counter#(4,10) hr1(.clk(clk_out),.reset(reset),.count(counthours1),.enable(enableH1),.load(enableH1&counthours2[1]&counthours1[0]&counthours1[1]),.data(4'b0000));
Counter#(4,3) hr2(.clk(clk_out),.reset(reset),.count(counthours2),.enable(enableH2),.load(enableH1&counthours2[1]&counthours1[0]&counthours1[1]),.data(4'b0000));
BCD7SEG Seg1(.number(countminutes1),.segments(segments1),.clk(clk_out));
BCD7SEG Seg2(.number(countminutes2),.segments(segments2),.clk(clk_out));
BCD7SEG Seg3(.number(counthours1),.segments(segments3),.clk(clk_out));
BCD7SEG Seg4(.number(counthours2),.segments(segments4),.clk(clk_out));

always@(posedge clk_segments) begin
enableS2 = countseconds1[0] & countseconds1[3];
enableM1 = enableS2 & countseconds2[2] & countseconds2[0];
enableM2 = enableM1&countminutes1[0] & countminutes1[3];
enableH1 = enableM2& countminutes2[2]& countminutes2[0];
enableH2 = (enableH1 & counthours1[3] & counthours1[0]);
end

always@(posedge clk_segments) begin
if(anodes == 4'b0000)
anodes <= 4'b1111;
else if (anodes == 4'b1111)
anodes <= 4'b1110;
else if (anodes == 4'b1110)
anodes <= 4'b1101;
else if(anodes == 4'b1101)
anodes <= 4'b1011;
else if (anodes == 4'b1011)
anodes <= 4'b0111;
else if (anodes == 4'b0111)
anodes <= 4'b1110;
end


always@(posedge clk_segments) begin
if(anodes == 14) 
segments <= segments1;
else if (anodes ==13)
segments <= segments2;
else if (anodes == 11)
segments <= segments3;
else if(anodes == 7)
segments <= segments4;
counts <= {counthours2,counthours1,countminutes2,countminutes1};
end

endmodule

