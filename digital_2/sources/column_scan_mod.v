`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:05:54 06/24/2018 
// Design Name: 
// Module Name:    column_scan_mod 
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
module column_scan_mod(
    CLK,
    RST_n,
    Column_Scan_Sig
    );
    
    input  CLK;
    input  RST_n;
    output [5:0]Column_Scan_Sig;

    //每隔10ms使能不同的数码管 -- 低电平有效
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
    reg [5:0]rCol;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 1'b0;
            rCol <= 6'b11_1111;
        end
        else
            case(i)
            
                1'b0:
                    if (count == T10MS)
                        i <= 1'b1;
                    else
                        rCol <= 6'b11_1110;
                    
                1'b1:
                    if (count == T10MS)
                        i <= 1'b0;
                    else
                        rCol <= 6'b11_1101;
                
            endcase
    end
    

    assign Column_Scan_Sig = rCol;

endmodule
