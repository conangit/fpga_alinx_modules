`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:34:45 06/24/2018 
// Design Name: 
// Module Name:    sos_module 
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
module sos_module_buzzer(
    CLK,
    RST_n,
    SOS_En,
    Pin_Out
    );
    
    input CLK;
    input RST_n;
    input SOS_En;
    output reg Pin_Out;
    
    parameter T1MS = 16'd49_999;
    
    reg [15:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count <= 16'd0;
        end
        else if (isCount && count == T1MS) begin
            count <= 16'd0;
        end
        else if (isCount) begin
            count <= count + 1'b1;
        end
    end
    
    reg [9:0] count_MS;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            count_MS <= 10'd0;
        end
        else if (isCount && count == T1MS) begin
            count_MS <= count_MS + 1'b1;
        end
        else if (!isCount) begin
            count_MS <= 1'd0;
        end
    end
    
    // SOS . . . _ _ _ . . . (stop)
    // 各个信号的停留时间为:100ms 50ms 300ms
    reg isCount;
    reg [4:0] i;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            isCount  <= 1'b0;
            Pin_Out <= 1'b1;    //shutdown buzzer
            i <= 5'd0;
        end
        else begin
            case (i)
                5'd0:
                begin
                    if (SOS_En) i <= 5'd1;
                end
                
                5'd1, 5'd3, 5'd5, 5'd13, 5'd15, 5'd17:    //short
                begin
                    if (count_MS == 10'd100) begin
                        isCount <= 1'b0;
                        Pin_Out <= 1'b1;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        Pin_Out <= 1'b0;
                    end
                end
                
                5'd2, 5'd4, 5'd6, 5'd8, 5'd10, 5'd12, 5'd14, 5'd16, 5'd18:    //interval
                begin
                    if (count_MS == 10'd50) begin
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                    end
                end
                
                5'd7, 5'd9, 5'd11:    //long
                begin
                    if (count_MS == 10'd300) begin
                        isCount <= 1'b0;
                        Pin_Out <= 1'b1;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        Pin_Out <= 1'b0;
                    end
                end
                
                5'd19:
                begin
                    Pin_Out <= 1'b1;
                    i <= 5'd0;
                end
            endcase
        end
    end

endmodule
