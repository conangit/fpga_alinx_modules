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
module key_debounce
(
    clk,
    rst_n,
    key_in,
    key_out
);

    input clk;
    input rst_n;
    input key_in;
    output key_out;
    
    
    wire H2L_Sig;
    wire L2H_Sig;
    
    key_detect D1
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .H2L_Sig(H2L_Sig),
        .L2H_Sig(L2H_Sig)
    );
    
    key_delay D2
    (
        .clk(clk),
        .rst_n(rst_n),
        .H2L_Sig(H2L_Sig),
        .L2H_Sig(L2H_Sig),
        .key_out(key_out)
    );

endmodule

