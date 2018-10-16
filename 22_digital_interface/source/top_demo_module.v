`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:24:17 08/09/2018 
// Design Name: 
// Module Name:    top_demo_module 
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
module top_demo_module(
    input clk,
    input rst_n,
    output [7:0]smg_data,
    output [5:0]scan_sig
    );
    
    
    reg [23:0]number;
    
    
    smg_interface U2(
        .clk(clk),
        .rst_n(rst_n),
        .number_sig(number),
        .smg_data(smg_data),
        .scan_sig(scan_sig)
    );
    
    
    localparam T1S = 26'd49_999_999;
    
    reg [25:0]count_s;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_s <= 26'd0;
        else if(count_s == T1S)
            count_s <= 26'd0;
        else
            count_s <= count_s + 1'b1;
    end
    
    
    reg [1:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
        begin
            number <= 24'd0;
            i <= 2'd0;
        end
        else
        begin
        
            case(i)
            
                0:
                begin
                    i <= 2'd1;
                    number <= 24'd0;
                end
                
                1:
                begin
                    if(count_s == T1S)
                    begin
                        if (number == 24'hfff_fff)
                            i <= 2'd0;
                        else
                        begin
                            i <= 2'd2;
                            number <= number + {{3{4'd0}}, {3{4'd1}}};
                        end
                    end
                end
                
                2:
                begin
                    if(count_s == T1S)
                    begin
                        if (number == 24'hfff_fff)
                            i <= 2'd0;
                        else
                        begin
                            i <= 2'd1;
                            number <= number + {{3{4'd1}}, {3{4'd0}}};
                        end
                    end
                end
                
            endcase
        end
    end
    
    
    
endmodule

