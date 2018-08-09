`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:24:17 08/09/2018 
// Design Name: 
// Module Name:    top_demo_module 
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
module top_demo_module(
    input CLK,
    input RSTn,
    output [7:0]smg_data,
    output [5:0]scan_sig
    );
    
    wire [23:0]number_sig;

    demo_control_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .number_sig(number_sig)
    );
    
    smg_interface U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .number_sig(number_sig),
        .smg_data(smg_data),
        .scan_sig(scan_sig)
    );

endmodule
