`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ZAGOATSSSS
// Engineer: Seif El Ansary
// Engineer: Ismaiel Sabet
// Engineer: Noor Emam
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

module Clock(input clk, reset, enable, Mode, Right, Left, Up, Down, output reg [6:0]segments, reg [3:0] anodes, reg dp, reg LD0, reg LD12, reg LD13, reg LD14, reg LD15, reg VDC);

wire clk_out;
wire clk_onehertz;
wire clk_segments;
wire clk_buttons;
wire [9:0] countmilliseconds;
wire [3:0] countseconds1;
wire [3:0] countseconds2;
wire [3:0] countminutes1;
wire [3:0] countminutes2;
wire [3:0] counthours1;
wire [3:0] counthours2;
wire [6:0] segments1; //minutes1 segment
wire [6:0] segments2; //minutes2 segment
wire [6:0] segments3; //hours1 segment
wire [6:0] segments4; //hours2 segment
wire [6:0] segments5; //hours1Adjust segment
wire [6:0] segments6; //hours2Adjust segment
wire [6:0] segments7; //minutes1Adjust segment
wire [6:0] segments8; //minutes2Adjust segment
wire [6:0] segments9; //hours1Alarm segment
wire [6:0] segments10; //hours2Alarm segment
wire [6:0] segments11; //minutes1Alarm segment
wire [6:0] segments12; //minutes2Alarm segment
wire ModeButton;
wire RightButton;
wire LeftButton;
wire UpButton;
wire DownButton;
reg [2:0] state;
reg [2:0] nextstate;
reg enableS1;
reg enableS2;
reg enableM1;
reg enableM2;
reg enableH1;
reg enableH2;
reg anodeshifter;
reg [3:0] counthours1Adjust;
reg [3:0] counthours2Adjust;
reg [3:0] countminutes1Adjust;
reg [3:0] countminutes2Adjust;
reg [3:0] counthours1Alarm;
reg [3:0] counthours2Alarm;
reg [3:0] countminutes1Alarm;
reg [3:0] countminutes2Alarm;

parameter [2:0] Clock = 3'b000,  Adjust = 3'b001, time_hour = 3'b010, time_minute = 3'b011, alarm_hour = 3'b100, alarm_minute = 3'b101, VDC0 = 3'b110, VDC1 = 3'b111;

Clock_Divider#(50000000) One_Hertz(.clk(clk),.rst(reset),.clk_out(clk_onehertz)); //1Hz Clock
Clock_Divider#(50000) Frequency_Regulator(.clk(clk),.rst(reset),.clk_out(clk_out)); //1000Hz Clock
Clock_Divider#(150000) Segment_frequency(.clk(clk),.rst(reset),.clk_out(clk_segments)); //Segment Clock
Clock_Divider#(75000) Button_frequency(.clk(clk),.rst(reset),.clk_out(clk_buttons)); //Up and Down Clock
Counter#(10,1000) Milli(.clk(clk_out),.reset(reset),.count(countmilliseconds),.enable(enable),.load(1'b0),.data(10'b0000000000)); //Milliseconds Counter
Counter#(4,10) Sec1(.clk(clk_out),.reset(reset),.count(countseconds1),.enable(enableS1),.load(1'b0),.data(4'b0000)); //Seconds1 Counter
Counter#(4,6) Sec2(.clk(clk_out),.reset(reset),.count(countseconds2),.enable(enableS2),.load(1'b0),.data(4'b0000)); //Seconds2 Counter
Counter#(4,10) Min1(.clk(clk_out),.reset(reset),.count(countminutes1),.enable(enableM1),.load((state == time_minute)),.data((state== time_minute)? countminutes1Adjust : 4'b0000)); //Minutes1 Counter
Counter#(4,6) Min2(.clk(clk_out),.reset(reset),.count(countminutes2),.enable(enableM2),.load((state == time_minute)),.data((state== time_minute)? countminutes2Adjust : 4'b0000)); //Minutes2 Counter
Counter#(4,10) hr1(.clk(clk_out),.reset(reset),.count(counthours1),.enable(enableH1),.load((enableH1&counthours2[1]&counthours1[0]&counthours1[1]) ||(state== time_hour)),.data((state== time_hour)? counthours1Adjust : 4'b0000 )); //Hours1 Counter
Counter#(4,3) hr2(.clk(clk_out),.reset(reset),.count(counthours2),.enable(enableH2),.load((enableH1&counthours2[1]&counthours1[0]&counthours1[1]) ||(state == time_hour)),.data((state== time_hour)? counthours2Adjust : 4'b0000 )); //Hours2 Counter
BCD7SEG Seg1(.number(countminutes1),.segments(segments1),.clk(clk_segments)); //BCD7SEG for Minutes1
BCD7SEG Seg2(.number(countminutes2),.segments(segments2),.clk(clk_segments)); //BCD7SEG for Minutes2
BCD7SEG Seg3(.number(counthours1),.segments(segments3),.clk(clk_segments)); //BCD7SEG for Hours1
BCD7SEG Seg4(.number(counthours2),.segments(segments4),.clk(clk_segments)); //BCD7SEG for Hours2
BCD7SEG Seg5(.number(counthours1Adjust),.segments(segments5),.clk(clk_segments)); //BCD7SEG for Hours1Adjust
BCD7SEG Seg6(.number(counthours2Adjust),.segments(segments6),.clk(clk_segments)); //BCD7SEG for Hours2Adjust
BCD7SEG Seg7(.number(countminutes1Adjust),.segments(segments7),.clk(clk_segments)); //BCD7SEG for Minutes1Adjust
BCD7SEG Seg8(.number(countminutes2Adjust),.segments(segments8),.clk(clk_segments)); //BCD7SEG for Minutes2Adjust
BCD7SEG Seg9(.number(counthours1Alarm),.segments(segments9),.clk(clk_segments)); //BCD7SEG for Hours1Alarm
BCD7SEG Seg10(.number(counthours2Alarm),.segments(segments10),.clk(clk_segments)); //BCD7SEG for Hours2Alarm
BCD7SEG Seg11(.number(countminutes1Alarm),.segments(segments11),.clk(clk_segments)); //BCD7SEG for Minutes1Alarm
BCD7SEG Seg12(.number(countminutes2Alarm),.segments(segments12),.clk(clk_segments)); //BCD7SEG for Minutes2Alarm
PushDownButton ModeButton1(.button(Mode),.clk(clk_segments),.rst(reset),.out(ModeButton)); //PushDownButton for Mode
PushDownButton RightButton1(.button(Right),.clk(clk_segments),.rst(reset),.out(RightButton)); //PushDownButton for Right
PushDownButton LeftButton1(.button(Left),.clk(clk_segments),.rst(reset),.out(LeftButton)); //PushDownButton for Left
PushDownButton UpButton1(.button(Up),.clk(clk_buttons),.rst(reset),.out(UpButton)); //PushDownButton for Up
PushDownButton DownButton1(.button(Down),.clk(clk_buttons),.rst(reset),.out(DownButton)); //PushDownButton for Down

always@(posedge clk_out) begin
enableS1 = countmilliseconds[0] & countmilliseconds[1] & countmilliseconds[2] & countmilliseconds[5] & countmilliseconds[6] & countmilliseconds[7] & countmilliseconds[8] & countmilliseconds[9]; //Enable for Seconds1
enableS2 = enableS1 & countseconds1[0] & countseconds1[3]; //Enable for Seconds2
enableM1 = enableS2 & countseconds2[2] & countseconds2[0]; //Enable for Minutes1
enableM2 = enableM1&countminutes1[0] & countminutes1[3];  //Enable for Minutes2
enableH1 = enableM2& countminutes2[2]& countminutes2[0]; //Enable for Hours1
enableH2 = (enableH1 & counthours1[3] & counthours1[0]); //Enable for Hours2
end

always@(posedge clk_segments) begin //Anode Shifter
if(anodes == 4'b0000) begin
anodes <= 4'b1111;
end
else if (anodes == 4'b1111) begin
anodes <= 4'b1110;
end
else if (anodes == 4'b1110) begin
anodes <= 4'b1101;
end
else if(anodes == 4'b1101) begin
anodes <= 4'b1011;
end
else if (anodes == 4'b1011) begin
anodes <= 4'b0111;
end
else if (anodes == 4'b0111) begin
anodes <= 4'b1110;
end
end

always@(posedge clk_segments) begin //State Machine
    case(state)
    Clock: if(ModeButton==1) nextstate = Adjust;
            else if ((counthours1Alarm == counthours1) && (counthours2Alarm == counthours2) && (countminutes1Alarm == countminutes1) && (countminutes2Alarm == countminutes2)) nextstate = VDC0;
            else nextstate = Clock;
    Adjust: if(ModeButton==1) nextstate = Clock;
            else if(RightButton==1) nextstate = time_hour;
            else if(LeftButton==1) nextstate = alarm_minute;
            else nextstate = Adjust;
    time_hour: if(ModeButton==1) nextstate = Clock;
            else if(RightButton==1) nextstate = time_minute;
            else if(LeftButton==1) nextstate = Adjust;
            else nextstate = time_hour;
    time_minute: if(ModeButton==1) nextstate = Clock;
            else if(RightButton==1) nextstate = alarm_hour;
            else if(LeftButton==1) nextstate = time_hour;
            else nextstate = time_minute;
    alarm_hour: if(ModeButton==1) nextstate = Clock;
            else if(RightButton==1) nextstate = alarm_minute;
            else if(LeftButton==1) nextstate = time_minute;
            else nextstate = alarm_hour;
    alarm_minute: if(ModeButton==1) nextstate = Clock;
            else if(RightButton==1) nextstate = Adjust;
            else if(LeftButton==1) nextstate = alarm_hour;
            else nextstate = alarm_minute;
    VDC0: if((ModeButton==1)||(RightButton==1)||(LeftButton==1)||(UpButton==1)||(DownButton==1)) nextstate = VDC1;
            else nextstate = VDC0;
    VDC1: if(countminutes1Alarm != countminutes1) nextstate = Clock;
            else if(ModeButton==1) nextstate = Adjust;
            else nextstate = VDC1;
    default: nextstate = Clock ;
    endcase
end

always@(posedge clk_segments) begin //State Machine Reset
    if(reset == 1) state <= Clock;
    else state <= nextstate; 
end

always@(posedge clk_segments) begin //Heirarchy of States
if(state == Clock) begin //Clock State
    LD0 <=0;
    LD12 <=0;
    LD13 <=0;
    LD14 <=0;
    LD15 <=0;
    if(anodes == 14) begin
    segments <= segments1;
    dp <= 1;
    end
    else if (anodes ==13) begin
    segments <= segments2;
    dp <=1;
    end
    else if (anodes == 11) begin
    segments <= segments3;
    dp <= clk_onehertz;
    end
    else if(anodes == 7) begin
    segments <= segments4;
    dp <= 1;
    end
end
else if(state == Adjust) begin //Adjust State
    LD0 <= 1;
    LD12 <= 0;
    LD13 <= 0;
    LD14 <= 0;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= 7'b0001000;
    else if (anodes ==13)
    segments <= 7'b0001000;
    else if (anodes == 11)
    segments <= 7'b0001000;
    else if(anodes == 7)
    segments <= 7'b0001000;
end
else if(state == time_hour) begin //Time Hour State
    LD0 <= 1;
    LD12 <= 1;
    LD13 <= 0;
    LD14 <= 0;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= 7'b1111110;
    else if (anodes ==13)
    segments <= 7'b1111110;
    else if (anodes == 11)
    segments <= segments5;
    else if(anodes == 7)
    segments <= segments6;

    //Adjusting Hours and all edge cases

    if(UpButton == 1) begin 
        if(counthours1 == 9 || (counthours1 == 3 && counthours2 == 2)) begin
            counthours1Adjust <= 0;
            if(counthours2 == 2) begin
                counthours2Adjust <= 0;
            end
            else begin
                counthours2Adjust <= counthours2 + 1;
            end
        end
        else begin
            counthours1Adjust <= counthours1 + 1;
            counthours2Adjust <= counthours2;
        end
    end
    else if(DownButton == 1) begin
        if(counthours1 == 0 && counthours2 ==0) begin
            counthours1Adjust <= 3;
            counthours2Adjust <= 2;
        end
       else if(counthours1 == 0) begin
            counthours1Adjust <= 9;
            counthours2Adjust <= counthours2 - 1;
        end
        else begin
            counthours1Adjust <= counthours1 - 1;
            counthours2Adjust <= counthours2;
        end
    end
    
end
   
else if(state == time_minute) begin //Time Minute State
    LD0 <= 1;
    LD12 <= 0;
    LD13 <= 1;
    LD14 <= 0;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= segments7;
    else if (anodes ==13)
    segments <= segments8;
    else if (anodes == 11)
    segments <= 7'b1111110;
    else if(anodes == 7)
    segments <= 7'b1111110;

    //Adjusting Minutes and all edge cases

    if(UpButton == 1) begin
        if(countminutes1 == 9) begin
            countminutes1Adjust <= 0;
            if(countminutes2 == 5) begin
                countminutes2Adjust <= 0;
            end
            else begin
                countminutes2Adjust <= countminutes2 + 1;
            end
        end
        else begin
            countminutes1Adjust <= countminutes1 + 1;
            countminutes2Adjust <= countminutes2;
        end
    end
    else if(DownButton == 1) begin
        if(countminutes1 == 0 && countminutes2 ==0) begin
            countminutes1Adjust <= 9;
            countminutes2Adjust <= 5;
        end
       else if(countminutes1 == 0) begin
            countminutes1Adjust <= 9;
            countminutes2Adjust <= countminutes2 - 1;
        end
        else begin
            countminutes1Adjust <= countminutes1 - 1;
            countminutes2Adjust <= countminutes2;
        end
    end
end
else if(state == alarm_hour) begin //Alarm Hour State
    LD0 <= 1;
    LD12 <= 0;
    LD13 <= 0;
    LD14 <= 1;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= 7'b1111110;
    else if (anodes ==13)
    segments <= 7'b1111110;
    else if (anodes == 11)
    segments <= segments9;
    else if(anodes == 7)
    segments <= segments10;

    //Adjusting Alarm Hours and all edge cases

    if(UpButton == 1) begin
        if(counthours1Alarm == 9 || (counthours1Alarm == 3 && counthours2Alarm == 2)) begin
            counthours1Alarm <= 0;
            if(counthours2Alarm == 2) begin
                counthours2Alarm <= 0;
            end
            else begin
                counthours2Alarm <= counthours2Alarm + 1;
            end
        end
        else begin
            counthours1Alarm <= counthours1Alarm + 1;
            counthours2Alarm <= counthours2Alarm;
        end
    end
    else if(DownButton == 1) begin
        if(counthours1Alarm == 0 && counthours2Alarm ==0) begin
            counthours1Alarm <= 3;
            counthours2Alarm <= 2;
        end
       else if(counthours1Alarm == 0) begin
            counthours1Alarm <= 9;
            counthours2Alarm <= counthours2Alarm - 1;
        end
        else begin
            counthours1Alarm <= counthours1Alarm - 1;
            counthours2Alarm <= counthours2Alarm;
        end
    end
end
else if(state == alarm_minute) begin //Alarm Minute State
    LD0 <= 1;
    LD12 <= 0;
    LD13 <= 0;
    LD14 <= 0;
    LD15 <= 1;
    if(anodes == 14) 
    segments <= segments11;
    else if (anodes ==13)
    segments <= segments12;
    else if (anodes == 11)
    segments <= 7'b1111110;
    else if(anodes == 7)
    segments <= 7'b1111110;

    //Adjusting Alarm Minutes and all edge cases

    if(UpButton == 1) begin
        if(countminutes1Alarm == 9) begin
            countminutes1Alarm <= 0;
            if(countminutes2Alarm == 5) begin
                countminutes2Alarm <= 0;
            end
            else begin
                countminutes2Alarm <= countminutes2Alarm + 1;
            end
        end
        else begin
            countminutes1Alarm <= countminutes1Alarm + 1;
            countminutes2Alarm <= countminutes2Alarm;
        end
    end
    else if(DownButton == 1) begin
        if(countminutes1Alarm == 0 && countminutes2Alarm ==0) begin
            countminutes1Alarm <= 9;
            countminutes2Alarm <= 5;
        end
       else if(countminutes1Alarm == 0) begin
            countminutes1Alarm <= 9;
            countminutes2Alarm <= countminutes2Alarm - 1;
        end
        else begin
            countminutes1Alarm <= countminutes1Alarm - 1;
            countminutes2Alarm <= countminutes2Alarm;
        end
    end
end

else if(state == VDC0) begin //Alarm State
    LD0 <= clk_out;
    LD12 <= 0;
    LD13 <= 0;
    LD14 <= 0;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= segments1;
    else if (anodes ==13)
    segments <= segments2;
    else if (anodes == 11)
    segments <= segments3;
    else if(anodes == 7)
    segments <= segments4;
    VDC <= clk_onehertz;

end
else if(state == VDC1) begin //Pseudo Clock State for Alarm
    LD0 <= 0;
    LD12 <= 0;
    LD13 <= 0;
    LD14 <= 0;
    LD15 <= 0;
    if(anodes == 14) 
    segments <= segments1;
    else if (anodes ==13)
    segments <= segments2;
    else if (anodes == 11)
    segments <= segments3;
    else if(anodes == 7)
    segments <= segments4;
    VDC <= 0;
end
end

endmodule

