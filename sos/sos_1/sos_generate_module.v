`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:32:20 06/24/2018 
// Design Name: 
// Module Name:    sos_generate_module 
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
module sos_generate_module(
    CLK,
    RST_n,
    Pin_Out
    );
    
    input CLK;
    input RST_n;
    output [1:0] Pin_Out;
    
    wire isEn;
    
    control_module C0(.CLK(CLK), .RST_n(RST_n), .SOS_En(isEn));
    sos_module_buzzer S0(.CLK(CLK), .RST_n(RST_n), .SOS_En(isEn), .Pin_Out(Pin_Out[0]));
    sos_modul_led S1(.CLK(CLK), .RST_n(RST_n), .SOS_En(isEn), .Pin_Out(Pin_Out[1]));


endmodule
