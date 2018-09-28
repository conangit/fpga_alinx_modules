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
    ten_in,
    one_in,
    ten_encode,
    one_encode
    );

    input  CLK;
    input  RST_n;
    input  [3:0] ten_in;
    input  [3:0] one_in;
    output reg [7:0] ten_encode;
    output reg [7:0] one_encode;
    
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
    
    parameter _nodisplay = 8'b1111_1111;

    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            ten_encode <= _nodisplay;
        end
        else begin
            case (ten_in)
                4'd0 : ten_encode <= _0;
                4'd1 : ten_encode <= _1;
                4'd2 : ten_encode <= _2;
                4'd3 : ten_encode <= _3;
                4'd4 : ten_encode <= _4;
                4'd5 : ten_encode <= _5;
                4'd6 : ten_encode <= _6;
                4'd7 : ten_encode <= _7;
                4'd8 : ten_encode <= _8;
                4'd9 : ten_encode <= _9;
                default: ten_encode <= _nodisplay;
            endcase
        end
    end

    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            one_encode <= _nodisplay;
        end
        else begin
            case (one_in)
                4'd0 : one_encode <= _0;
                4'd1 : one_encode <= _1;
                4'd2 : one_encode <= _2;
                4'd3 : one_encode <= _3;
                4'd4 : one_encode <= _4;
                4'd5 : one_encode <= _5;
                4'd6 : one_encode <= _6;
                4'd7 : one_encode <= _7;
                4'd8 : one_encode <= _8;
                4'd9 : one_encode <= _9;
                default: one_encode <= _nodisplay;
            endcase
        end
    end

endmodule
