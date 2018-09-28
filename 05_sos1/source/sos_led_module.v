`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:34:45 06/24/2018 
// Design Name: 
// Module Name:    sos_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sos_modul_led(
    CLK,
    RST_n,
    SOS_En,
    Pin_Out
    );
    
    input CLK;
    input RST_n;
    input SOS_En;
    output reg Pin_Out;
    
    parameter T500MS = 25'd24_999_999;
    
    reg [24:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count <= 25'd0;
        end
        else if (isCount && count == T500MS) begin
            count <= 25'd0;
        end
        else if (isCount) begin
            count <= count + 1'b1;
        end
    end
    
    reg [2:0] count_S;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count_S <= 3'd0;
        end
        else if (isCount && count == T500MS) begin
            count_S <= count_S + 1'b1;
        end
        else if (!isCount) begin
            count_S <= 1'd0;
        end
    end
    
    // SOS . . . _ _ _ . . . (stop)
    // 用LED模拟蜂鸣器 1点亮LED
    // 各个信号的停留时间为:1s 0.5s 3s
    reg isCount;
    reg [4:0] i;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            isCount  <= 1'b0;
            Pin_Out <= 1'b0;    //shutdown led
            i <= 5'd0;
        end
        else begin
            case (i)
                5'd0:
                begin
                    if (SOS_En) i <= 5'd1;
                end
                
                5'd1, 5'd3, 5'd5, 5'd13, 5'd15, 5'd17:    //short 1s
                begin
                    if (count_S == 3'd2) begin
                        isCount <= 1'b0;
                        Pin_Out <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        Pin_Out <= 1'b1;
                    end
                end
                
                5'd2, 5'd4, 5'd6, 5'd8, 5'd10, 5'd12, 5'd14, 5'd16, 5'd18:    //interval 0.5s
                begin
                    if (count_S == 3'd1) begin
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                    end
                end
                
                5'd7, 5'd9, 5'd11:    //long 3s
                begin
                    if (count_S == 3'd6) begin
                        isCount <= 1'b0;
                        Pin_Out <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        Pin_Out <= 1'b1;
                    end
                end
                
                5'd19:
                begin
                    Pin_Out <= 1'b0;
                    i <= 5'd0;
                end
            endcase
        end
    end

endmodule
