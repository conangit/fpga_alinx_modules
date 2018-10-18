`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:52:41 08/07/2018 
// Design Name: 
// Module Name:    detect_module 
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
module key_detect
(
    clk,
    rst_n,
    key_in,
    H2L_Sig,
    L2H_Sig
);
    
    input clk;
    input rst_n;
    input key_in;
    output H2L_Sig;
    output L2H_Sig;
    
    
    /* 电平检测是敏感模块 在复位瞬间 电平易处于不稳定状态 故延时100us */
    parameter T100US = 13'd4_999;
    
    reg [12:0]count;
    reg isEn;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 13'd0;
            isEn <= 1'b0;
        end
        else if (count == T100US)
            isEn <= 1'b1;
        else
            count <= count + 1'b1;
    end
        
    reg H2L_F1;
    reg H2L_F2;
    reg L2H_F1;
    reg L2H_F2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            H2L_F1 <= 1'b1;
            H2L_F2 <= 1'b1;
            L2H_F1 <= 1'b0;
            L2H_F2 <= 1'b0;
        end
        else begin
            H2L_F1 <= key_in;
            H2L_F2 <= H2L_F1;
            L2H_F1 <= key_in;
            L2H_F2 <= L2H_F1;
        end
    end
    
    assign H2L_Sig = isEn ? (!H2L_F1 & H2L_F2) : 1'b0;
    assign L2H_Sig = isEn ? (L2H_F1 & !L2H_F2) : 1'b0;

endmodule

