`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:21:36 08/02/2018 
// Design Name: 
// Module Name:    rx_module 
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
module rx_module(
    input CLK,
    input RST_n,
    input Rx_Pin_In,
    input Rx_En_Sig,
    output Rx_Done_Sig,
    output [7:0]Rx_Data
    );
    
    parameter BPS_9600   = 13'd5208;
    parameter BPS_115200 = 13'd434;
    
    wire H2L_Sig;
    wire Count_Sig;
    wire BPS_CLK;
    
    detect_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Rx_Pin_In(Rx_Pin_In),
        .H2L_Sig(H2L_Sig)
    );
    
    rx_bps_module #(.BPS(BPS_115200)) U2(
        .CLK(CLK),
        .RST_n(RST_n),
        .Count_Sig(Count_Sig),
        .BPS_CLK(BPS_CLK)
    );
    
    rx_control_module U3(
        .CLK(CLK),
        .RST_n(RST_n),
        .H2L_Sig(H2L_Sig),
        .Rx_Pin_In(Rx_Pin_In),
        .BPS_CLK(BPS_CLK),
        .Rx_En_Sig(Rx_En_Sig),
        .Count_Sig(Count_Sig),
        .Rx_Done_Sig(Rx_Done_Sig),
        .Rx_Data(Rx_Data)
    );


endmodule
