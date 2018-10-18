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
module keys_interface
(
    input clk,
    input rst_n,
    
    input [3:0] key_in,
    output [3:0] key_out
);
    
    key_debounce K1
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in[0]),
        .key_out(key_out[0])
    );

    key_debounce K2
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in[1]),
        .key_out(key_out[1])
    );
    
    key_debounce K3
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in[2]),
        .key_out(key_out[2])
    );
    
    key_debounce K4
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in[3]),
        .key_out(key_out[3])
    );
    
endmodule
