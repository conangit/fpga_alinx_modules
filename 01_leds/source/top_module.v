`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:09 06/14/2018 
// Design Name: 
// Module Name:    top_module 
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
module top_module(
    input CLK,
    input RST_n,
    output [3:0] LED_Out
    );
    
    wire LED0_Out;
    wire LED1_Out;
    wire LED2_Out;
    wire LED3_Out;
    
    led0_module L0(.CLK(CLK), .RST_n(RST_n), .LED_Out(LED0_Out));
    led1_module L1(.CLK(CLK), .RST_n(RST_n), .LED_Out(LED1_Out));
    led2_module L2(.CLK(CLK), .RST_n(RST_n), .LED_Out(LED2_Out));
    led3_module L3(.CLK(CLK), .RST_n(RST_n), .LED_Out(LED3_Out));
    
    assign LED_Out = {LED0_Out, LED1_Out, LED2_Out, LED3_Out};

endmodule
