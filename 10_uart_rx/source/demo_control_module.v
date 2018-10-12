`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:36:05 08/02/2018 
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
module demo_control_module(
    CLK,
    RST_n,
    Rx_Done_Sig,
    Rx_Data,
    Rx_En_Sig,
    Number_Data
    );
    
    input CLK;
    input RST_n;
    input Rx_Done_Sig;
    input [7:0]Rx_Data;
    
    output Rx_En_Sig;
    output [7:0]Number_Data;
    
    reg isEn;
    reg [7:0]number;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            isEn <= 1'b0;
            number <= 8'd0;
        end
        else if (Rx_Done_Sig) begin
            number <= Rx_Data;
            isEn <= 1'b0;
        end
        else begin
            isEn <= 1'b1;
        end
    end
    
    assign Rx_En_Sig = isEn;
    assign Number_Data = number;
    
endmodule
