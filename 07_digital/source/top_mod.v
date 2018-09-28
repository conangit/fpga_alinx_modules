`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:03 06/24/2018 
// Design Name: 
// Module Name:    top_mod 
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
module top_mod(
    input  CLK,
    input  RST_n,
    input  [7:0] data_in,
    output [7:0] Row_Scan_Sig,
    output [5:0] Column_Scan_Sig
    );

    //assign data_in = 8'd75;
    
    wire [3:0] w_ten;
    wire [3:0] w_one;
    
    number_mod Num(
        .CLK(CLK),
        .RST_n(RST_n),
        // .data_in(data_in),
        .data_in(8'd75),
        .ten_data(w_ten),
        .one_data(w_one)
    );
    
    wire [7:0] w_ten_encode;
    wire [7:0] w_one_encode;
    
    smg_encode_mod Smg(
        .CLK(CLK),
        .RST_n(RST_n),
        .ten_in(w_ten),
        .one_in(w_one),
        .ten_encode(w_ten_encode),
        .one_encode(w_one_encode)
    );
    
    scan_mod Scan(
        .CLK(CLK),
        .RST_n(RST_n),
        .ten_encode_in(w_ten_encode),
        .one_encode_in(w_one_encode),
        .Row_Scan_Sig(Row_Scan_Sig),
        .Column_Scan_Sig(Column_Scan_Sig)
    );

endmodule
