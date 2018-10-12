`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:45:32 08/02/2018 
// Design Name: 
// Module Name:    rx_demo 
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
module rx_demo(
    input CLK,
    input RST_n,
    input Rx_Pin_In,
    output [3:0]Number_Data
    );
    
    wire Rx_En_Sig;
    wire Rx_Done_Sig;
    wire [7:0]Rx_Data;
    wire [7:0]Output_Data;
    
    rx_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Rx_Pin_In(Rx_Pin_In),
        .Rx_En_Sig(Rx_En_Sig),
        .Rx_Done_Sig(Rx_Done_Sig),
        .Rx_Data(Rx_Data)
    );
    
    demo_control_module U2(
        .CLK(CLK),
        .RST_n(RST_n),
        .Rx_Done_Sig(Rx_Done_Sig),
        .Rx_Data(Rx_Data),
        .Rx_En_Sig(Rx_En_Sig),
        .Number_Data(Output_Data)
    );

    assign Number_Data = Output_Data[3:0];

endmodule
