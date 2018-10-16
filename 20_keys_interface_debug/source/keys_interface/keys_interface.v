`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:42:03 08/08/2018 
// Design Name: 
// Module Name:    keys_interface 
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
module keys_interface(
    input CLK,
    input RSTn,
    input [3:0]pin_in,
    output [3:0]key_out
    );
    
    debounce_module K1(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(pin_in[0]),
        .key_out(key_out[0])
    );

    debounce_module K2(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(pin_in[1]),
        .key_out(key_out[1])
    );
    
    debounce_module K3(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(pin_in[2]),
        .key_out(key_out[2])
    );
    
    debounce_module K4(
        .CLK(CLK),
        .RSTn(RSTn),
        .pin_in(pin_in[3]),
        .key_out(key_out[3])
    );
    
endmodule
