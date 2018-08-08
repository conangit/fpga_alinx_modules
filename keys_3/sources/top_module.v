`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:50 08/08/2018 
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
    input RSTn,
    input [3:0]key_in,
    output led_out
    );
    
    wire [3:0]key_out;
    
    keys_interface U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(key_in),
        .key_out(key_out)
    );
    
    optional_pwm_module3 U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .option_keys(key_out),
        .led_out(led_out)
    );

endmodule
