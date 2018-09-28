`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:19:46 06/24/2018 
// Design Name: 
// Module Name:    control_module 
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
module control_buzzer_module(
    CLK,
    RST_n,
    SOS_En
    );
    
    input CLK;
    input RST_n;
    output reg SOS_En;
    
    //buzzer:100ms * 6 + 300ms * 3 + 50ms * 9 = 1.95s
    parameter T3S = 28'd149_999_999;
    
    reg [27:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            SOS_En <= 1'b0;
            count <= 28'd0;
        end
        else if (count == T3S) begin
            SOS_En <= 1'b1;
            count <= 28'd0;
        end
        else begin
            SOS_En <= 1'b0;
            count <= count + 1'b1;
        end
    end
    
endmodule

/*
 * 可以看出 控制模块需要自己去计算功能模块的完成时间
 * 从而在合适的时间点给出使能信号(虽然可有一直使能,但"没有意义")
 */


