`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:10 06/24/2018 
// Design Name: 
// Module Name:    row_scan_mod 
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
module row_scan_mod(
    CLK,
    RST_n,
    ten_encode_in,
    one_encode_in,
    Row_Scan_Sig
    );
    
    input  CLK;
    input  RST_n;
    input  [7:0] ten_encode_in;
    input  [7:0] one_encode_in;
    output reg [7:0] Row_Scan_Sig;
    
    //每隔10ms输出不同的encode_smg码
    parameter T10MS = 19'd499_999;
    
    /*
    reg [18:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count <= 19'd0;
        end
        else if (isCount && count == T10MS) begin
            count <= 19'd0;
        end
        else if (isCount) begin
            count <= count + 1'b1;
        end
        else if(!isCount) begin
            count <= 19'd0;
        end
    end
    
    reg i;
    reg isCount;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 1'b0;
            isCount <= 1'b0;
            Row_Scan_Sig <= one_encode_in;
        end
        else begin
            case (i)
                1'b0:
                begin
                    if (count == T10MS) begin
                        isCount <= 1'b0;
                        i <= 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        Row_Scan_Sig <= one_encode_in;
                    end
                end
                
                1'b1:
                begin
                    if (count == T10MS) begin
                        isCount <= 1'b0;
                        i <= 1'b0;
                    end
                    else begin
                        isCount <= 1'b1;
                        Row_Scan_Sig <= ten_encode_in;
                    end
                end
            endcase
        end
    end
    */
    
    reg [18:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count <= 19'd0;
        end
        else if (count == T10MS) begin
            count <= 19'd0;
        end
        else begin
            count <= count + 1'b1;
        end
    end
    
    reg [1:0] t;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            t <= 2'd0;
        end
        else if (t == 2'd2) begin
            t <= 2'd0;
        end
        else if (count == T10MS) begin
            t <= t + 1'b1;
        end
    end
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            Row_Scan_Sig <= one_encode_in;
        end
        else begin
            case (t)
            2'd0: Row_Scan_Sig <= one_encode_in; //第一个10ms编码个位
            2'd1: Row_Scan_Sig <= ten_encode_in; //第二个10ms编码十位
            default: Row_Scan_Sig <= one_encode_in;
            endcase
        end
    end
    
endmodule
