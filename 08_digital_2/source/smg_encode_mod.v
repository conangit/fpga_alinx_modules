`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:53 06/24/2018 
// Design Name: 
// Module Name:    smg_encode_mod 
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
module smg_encode_mod(
    CLK,
    RST_n,
    ten_data,
    one_data,
    ten_encode,
    one_encode
    );

    input CLK;
    input RST_n;
    input [3:0]ten_data;
    input [3:0]one_data;
    output [7:0]ten_encode;
    output [7:0]one_encode;
    
    //共阳数码管 -- 阴显示
    parameter _0 = 8'b1100_0000;
    parameter _1 = 8'b1111_1001;
    parameter _2 = 8'b1010_0100;
    parameter _3 = 8'b1011_0000;
    parameter _4 = 8'b1001_1001;
    parameter _5 = 8'b1001_0010;
    parameter _6 = 8'b1000_0010;
    parameter _7 = 8'b1111_1000;
    parameter _8 = 8'b1000_0000;
    parameter _9 = 8'b1001_0000;
    
    parameter _z = 8'b1111_1111;
    
    reg [7:0]rTen;
    reg [7:0]rOne;

    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            rTen <= _z;
        end
        else begin
            case(ten_data)
                4'd0 : rTen <= _0;
                4'd1 : rTen <= _1;
                4'd2 : rTen <= _2;
                4'd3 : rTen <= _3;
                4'd4 : rTen <= _4;
                4'd5 : rTen <= _5;
                4'd6 : rTen <= _6;
                4'd7 : rTen <= _7;
                4'd8 : rTen <= _8;
                4'd9 : rTen <= _9;
                default: rTen <= _z;
            endcase
        end
    end

    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            rOne <= _z;
        end
        else begin
            case (one_data)
                4'd0 : rOne <= _0;
                4'd1 : rOne <= _1;
                4'd2 : rOne <= _2;
                4'd3 : rOne <= _3;
                4'd4 : rOne <= _4;
                4'd5 : rOne <= _5;
                4'd6 : rOne <= _6;
                4'd7 : rOne <= _7;
                4'd8 : rOne <= _8;
                4'd9 : rOne <= _9;
                default: rOne <= _z;
            endcase
        end
    end
    
    assign ten_encode = rTen;
    assign one_encode = rOne;

endmodule

