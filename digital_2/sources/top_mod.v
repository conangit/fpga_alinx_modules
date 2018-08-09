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
    input [3:0]data_in,
    output [7:0]Row_Scan_Sig,
    output [5:0]Column_Scan_Sig
    );

    wire [7:0]data;
    wire [3:0]w_ten;
    wire [3:0]w_one;
    
    
    reg [7:0]rData;
    assign data = rData;
    
    // 恒定显示数据
    /*
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            rData <= 8'd0;
        else
            rData <= 8'd55;
    end
    */
    
    // 显示按键状态
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            rData <= 8'd0;
        else
            rData <= {4'd0, data_in};
    end
    
    
    
    number_mod U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .data_in(data),
        .ten_data(w_ten),
        .one_data(w_one)
    );
    
    wire [7:0]w_ten_encode;
    wire [7:0]w_one_encode;
    
    smg_encode_mod U2(
        .CLK(CLK),
        .RST_n(RST_n),
        .ten_data(w_ten),
        .one_data(w_one),
        .ten_encode(w_ten_encode),
        .one_encode(w_one_encode)
    );
    
    scan_mod U3(
        .CLK(CLK),
        .RST_n(RST_n),
        .ten_encode(w_ten_encode),
        .one_encode(w_one_encode),
        .Row_Scan_Sig(Row_Scan_Sig),
        .Column_Scan_Sig(Column_Scan_Sig)
    );
    

    
endmodule

/*
 * 注意
 * 默认下 连接数码管这些IO全为低电平
 * 即数码管既选通又显示
 */

