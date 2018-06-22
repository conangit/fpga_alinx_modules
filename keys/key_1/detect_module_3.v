`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:39:01 06/23/2018 
// Design Name: 
// Module Name:    detect_module_3 
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
module detect_module_3(
    CLK, RST_n, Pin_In, H2L_Sig, L2H_Sig
    );

    input CLK;
    input RST_n;
    input Pin_In;
    output reg H2L_Sig;
    output reg L2H_Sig;
    
    parameter T100US = 13'd4_999;
    
    reg [12:0] counter;
    reg isEn;
    
    //电平检测是敏感模块 在复位瞬间 电平易处于不稳定状态 故延时100us
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 13'd0;
            isEn <= 1'b0;
        end
        else if (counter == T100US) begin
            isEn <= 1'b1;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    
    //输入状态延时
    reg Pin_In_delay;
    
    always @(posedge CLK) begin
        if (isEn) begin
            Pin_In_delay <= Pin_In;
        end
    end
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            H2L_Sig <= 1'b0;
            L2H_Sig <= 1'b0;
        end
        else if (isEn) begin
            H2L_Sig <= ((Pin_In_delay == 1'b1) && (Pin_In == 1'b0));
            L2H_Sig <= ((Pin_In_delay == 1'b0) && (Pin_In == 1'b1));
        end
        else begin
            H2L_Sig <= 1'b0;
            L2H_Sig <= 1'b0;
        end
    end

endmodule
