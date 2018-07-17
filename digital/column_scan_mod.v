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
    output reg [5:0] Column_Scan_Sig;

    //每隔10ms使能不同的数码管 -- 低电平有效
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
            Column_Scan_Sig <= 6'b11_1111;
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
                        Column_Scan_Sig <= 6'b11_1110;
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
                        Column_Scan_Sig <= 6'b11_1101;
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
            Column_Scan_Sig <= 6'b11_1111;
        end
        else begin
            case (t)
            2'd0: Column_Scan_Sig <= 6'b11_1110;
            2'd1: Column_Scan_Sig <= 6'b11_1101;
            default: Column_Scan_Sig <= 6'b11_1111;
            endcase
        end
    end

endmodule
