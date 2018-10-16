`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:07:13 08/08/2018 
// Design Name: 
// Module Name:    delay_module 
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
module delay_module(
    CLK,
    RSTn,
    H2L_Sig,
    L2H_Sig,
    key_out
    );
    
    input CLK;
    input RSTn;
    input H2L_Sig;
    input L2H_Sig;
    output key_out;
    
    
    /* 1ms计时 */
    parameter T1MS = 16'd49_999;
    
    reg [15:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else if (isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    /* max 100ms延时 */
    reg [6:0]count_ms;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_ms <= 7'd0;
        else if (count_ms == rTime)
            count_ms <= 7'd0;
        else if(count == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    /* 仿顺序操作 */
    reg isCount;
    reg [7:0]rTime;
    reg rKey;
    reg [1:0]i;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 2'd0;
            isCount <= 1'b0;
            // rTime <= 5'd0;  //易错点：默认为0 则if (count_ms == rTime)条件立马满足
            rTime <= 7'd127;
            rKey <= 1'b0;
        end
        else begin
            case(i)
                
                0:
                    if (H2L_Sig)
                        i <= 2'd1;      // 按键按下
                    else if (L2H_Sig)
                        i <= 2'd3;      // 按键弹起
                        
                1:
                    if (count_ms == rTime) begin
                        isCount <= 1'b0;
                        rKey <= 1'b1;   // 按键按下 输出一个高脉冲信号
                        i <= 2'd2;
                    end
                    else begin
                        isCount <= 1'b1;
                        rTime <= 7'd20; // 延时20ms,期间不再对pin_in引脚的变化作出响应
                    end
                    
                2:
                    begin
                        rKey <= 1'b0;   // 这样才是真正的一个FPGA时钟 输出一个高脉冲信号
                        i <= 2'd0;
                    end
                  
                3:
                    if (count_ms == rTime) begin
                        isCount <= 1'b0; // 弹起仅作防抖 不对输出产生影响
                        i <= 2'd0;
                    end
                    else begin
                        isCount <= 1'b1;
                        rTime <= 7'd20; // 延时20ms,期间不再对pin_in引脚的变化作出响应
                    end
            
            endcase
        end
    end
    
    assign key_out = rKey;


endmodule

/*
 * 之前实验一直在调试pwm信号的产生,而没有把握真正的关键--"按键按下,产生一个且仅为一个的高脉冲信号"
 */


