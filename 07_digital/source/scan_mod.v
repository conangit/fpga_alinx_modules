`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:42 06/24/2018 
// Design Name: 
// Module Name:    scan_mod 
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
module scan_mod(
    CLK,
    RST_n,
    ten_encode_in,
    one_encode_in,
    Row_Scan_Sig,
    Column_Scan_Sig
    );
    
    input CLK;
    input RST_n;
    input  [7:0] ten_encode_in;
    input  [7:0] one_encode_in;
    output [7:0] Row_Scan_Sig;
    output [5:0] Column_Scan_Sig;
    
    row_scan_mod Row(
        .CLK(CLK),
        .RST_n(RST_n),
        .ten_encode_in(ten_encode_in),
        .one_encode_in(one_encode_in),
        .Row_Scan_Sig(Row_Scan_Sig)
    );
    
    column_scan_mod Col(
        .CLK(CLK),
        .RST_n(RST_n),
        .Column_Scan_Sig(Column_Scan_Sig)
    );

endmodule
