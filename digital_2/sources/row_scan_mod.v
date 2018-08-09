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
    ten_encode,
    one_encode,
    Row_Scan_Sig
    );
    
    input  CLK;
    input  RST_n;
    input  [7:0]ten_encode;
    input  [7:0]one_encode;
    output [7:0]Row_Scan_Sig;
    
    //每隔10ms输出不同位的encode_smg码
    parameter T10MS = 19'd499_999;
    
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
    
    reg i;
    reg [7:0]rData;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 1'b0;
            rData <= 8'd0;
        end
        else
            case(i)
            
                1'b0:
                    if (count == T10MS)
                        i <= 1'b1;
                    else
                        rData <= one_encode;
                    
                1'b1:
                    if (count == T10MS)
                        i <= 1'b0;
                    else
                        rData <= ten_encode;
                
            endcase
    end
    
    assign Row_Scan_Sig = rData;
    
endmodule
