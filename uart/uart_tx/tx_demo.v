`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:17:55 08/03/2018 
// Design Name: 
// Module Name:    tx_demo 
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
module tx_demo(
    input CLK,
    input RST_n,
    output Tx_Pin_Out
    );
    
    wire Tx_En_Sig;
    wire [7:0] tData;
    wire Tx_Done_Sig;
    
    control_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Tx_Done_Sig(Tx_Done_Sig),
        .Tx_En_Sig(Tx_En_Sig),
        .Tx_Data(tData)
    );
    
    tx_module U2(
        .CLK(CLK),
        .RST_n(RST_n),
        .Tx_En_Sig(Tx_En_Sig),
        .Tx_Data(tData),
        .Tx_Done_Sig(Tx_Done_Sig),
        .Tx_Pin_Out(Tx_Pin_Out)
    );


endmodule
