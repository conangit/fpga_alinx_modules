`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:54 08/01/2018 
// Design Name: 
// Module Name:    rx_control_module 
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
module rx_control_module(
    CLK,
    RST_n,
    H2L_Sig,
    Rx_Pin_In,
    BPS_CLK,
    Rx_En_Sig,
    Count_Sig,
    Rx_Done_Sig,
    Rx_Data
    );
    
    input CLK;
    input RST_n;
    
    input H2L_Sig;
    input Rx_Pin_In;
    input BPS_CLK;
    input Rx_En_Sig;
    
    output Count_Sig;
    output Rx_Done_Sig;
    output [7:0]Rx_Data;
    
    reg [3:0]i;
    reg [7:0]rData;
    reg isCount;
    reg isDone;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 4'd0;
            rData <= 8'd0;
            isCount <= 1'b0;
            isDone <= 1'b0;
        end
        else if (Rx_En_Sig) begin
            case (i)
                4'd0:   // 检测到开始传输信号
                begin
                    if (H2L_Sig) begin
                        i <= i + 1'b1;
                        isCount <= 1'b1;    // rx_bps模块开始产生波特率定时
                    end
                end
                
                4'd1:   // 开始位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                    end
                end
                
                4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9:     // 数据位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        rData[i-2] <= Rx_Pin_In;
                    end
                end
                
                4'd10:   // 校验位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                    end
                end

                4'd11:   // 停止位
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                    end
                end

                /*
                 * 本质上i <= 1'b0;永远不会执行13态处 电路从0态开始将永远停留在13态 12态之后BPS_CLK将不会再产生
                 * 但由于"多写了else语句,在control_module.v中Rx_En_Sig无效时 让i回到0态"
                 * 可以预测，当把else语句块去除后 rx模块将只能接收一帧数据
                 *
                 * 注意：本质上也不该写else语句块
                 * ①case仿顺序操作应该自行执行13态，然后回到0态
                 * ②接收数据总线Rx_Data，除非复位回到0x00，否则应该保留电路最后一帧数据状态
                 */

                /*
                4'd12:   // 一帧数据采集完成
                begin
                    if (BPS_CLK) begin
                        i <= i + 1'b1;
                        isCount <= 1'b0;
                        isDone <= 1'b1;
                    end
                end
                
                4'd13:   // 回到初态
                begin
                    if (BPS_CLK) begin
                        i <= 1'b0;
                        isDone <= 1'b0;
                    end
                end
                */
                
                4'd12:   // 一帧数据采集完成
                begin
                    i <= i + 1'b1;
                    isCount <= 1'b0;
                    isDone <= 1'b1;
                end
                
                4'd13:   // 回到初态
                begin
                    i <= 1'b0;
                    isDone <= 1'b0;
                end
            endcase
        end
        /*
        else begin    // Rx_En_Sig无效时
            i <= 4'd0;
            rData <= 8'd0;
            isCount <= 1'b0;
            isDone <= 1'b0;
        end
        */
    end
    
    assign Count_Sig = isCount;
    assign Rx_Done_Sig = isDone;
    assign Rx_Data = rData;

endmodule
