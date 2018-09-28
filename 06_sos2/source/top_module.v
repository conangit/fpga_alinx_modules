`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:38:15 06/24/2018 
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
    input Pin_In,
    output [1:0] Pin_Out
    );
    
    wire Trig_Sig;
    wire Sos_En;
    
    debounce_module D0(.CLK(CLK), .RST_n(RST_n), .Pin_In(Pin_In), .Pin_Out(Trig_Sig));
    inter_control_module C0(.CLK(CLK), .RST_n(RST_n), .Trig_Sig(Trig_Sig), .SOS_En_Sig(Sos_En));
    sos_module_buzzer S0(.CLK(CLK), .RST_n(RST_n), .SOS_En(Sos_En), .Pin_Out(Pin_Out[0]));
    sos_modul_led S1(.CLK(CLK), .RST_n(RST_n), .SOS_En(Sos_En), .Pin_Out(Pin_Out[1]));
    
endmodule
