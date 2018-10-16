`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:29:16 08/08/2018 
// Design Name: 
// Module Name:    debounce_module 
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
module debounce_module(
    CLK,
    RSTn,
    pin_in,
    key_out
    );

    input CLK;
    input RSTn;
    input pin_in;
    output key_out;
    
    
    wire H2L_Sig;
    wire L2H_Sig;
    
    detect_module D1(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(pin_in),
        .H2L_Sig(H2L_Sig),
        .L2H_Sig(L2H_Sig)
    );
    
    delay_module D2(
        .CLK(CLK),
        .RSTn(RSTn),
        .H2L_Sig(H2L_Sig),
        .L2H_Sig(L2H_Sig),
        .key_out(key_out)
    );

endmodule

