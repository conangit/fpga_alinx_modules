`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:02:06 08/03/2018 
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
module control_module(
    CLK,
    RST_n,
    Tx_Done_Sig,
    Tx_En_Sig,
    Tx_Data
    );

    input CLK;
    input RST_n;
    input Tx_Done_Sig;
    output Tx_En_Sig;
    output [7:0]Tx_Data;
    
    parameter T1S = 26'd49_999_999;
    
    reg [25:0]Count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            Count <= 26'd0;
        else if (Count == T1S)
            Count <= 26'd0;
        else
            Count <= Count + 1'b1;
    end
    
    reg isEn;
    reg [7:0]tData;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            isEn <= 1'b0;
            tData <= 8'ha5;
        end
        else if (Tx_Done_Sig) begin
            isEn <= 1'b0;
            tData <= 8'ha5;
        end
        else if (Count == T1S) begin
            isEn <= 1'b1;
        end
        else begin
            // isEn <= 1'b0;   
            /* 模块开始工作1秒后发送数据
             * 错误：模块将无法工作 因为在Count == T1S使能Tx模块后，又立马失能Tx
             */
             
            // isEn <= 1'b1;   // 模块工作就发送数据
            /*
             * 错误：模块会在使能后的1秒内 按9600bps不停发送数据，并不是每隔1s发送一帧数据
             */
        end
    end
    
    assign Tx_En_Sig = isEn;
    assign Tx_Data = tData;

endmodule
