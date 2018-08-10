`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:28 08/10/2018 
// Design Name: 
// Module Name:    beep_function_module 
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
module beep_function_module(
    CLK,
    RSTn,
    func_start_sig,
    func_done_sig,
    beep_pin
    );
    
    input CLK;
    input RSTn;
    input [1:0]func_start_sig;
    output func_done_sig;
    output beep_pin;
    
    /***************************************/
    localparam T1MS = 16'd49_999;
    
    reg [15:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    /***************************************/
    // max:count_ms=511ms
    reg [8:0]count_ms;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_ms <= 9'd0;
        else if (count_ms == rTime)
            count_ms <= 9'd0;
        else if (count == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    /***************************************/
    
    reg [2:0]i;
    reg isCount;
    reg [8:0]rTime;
    reg isDone;
    reg rPin_out;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            begin
                i <= 3'd0;
                isCount <= 1'b0;
                rTime <= 9'h1_ff;
                isDone <= 1'b0;
                rPin_out <= 1'b0;
            end
        else if (func_start_sig[1]) // S code
            case(i)
            
                0,2,4:
                    if (count_ms == rTime)
                        begin
                            i <= i + 1'b1;
                            isCount <= 1'b0;
                            rPin_out <= 1'b0;
                        end
                    else
                        begin
                            isCount <= 1'b1;
                            rTime <= 9'd100;
                            rPin_out <= 1'b1;
                        end
                        
                1,3,5:
                    if (count_ms == rTime)
                        begin
                            i <= i + 1'b1;
                            isCount <= 1'b0;
                        end
                    else
                        begin
                            isCount <= 1'b1;
                            rTime <= 9'd50;
                        end
                        
                6:
                    begin
                        i <= i + 1'b1;
                        isDone <= 1'b1;
                    end
                    
                7:
                    begin
                        i <= 3'd0;
                        isDone <= 1'b0;
                    end
                    
            endcase
        else if (func_start_sig[0]) // O code
            case(i)
            
                0,2,4:
                    if (count_ms == rTime)
                        begin
                            i <= i + 1'b1;
                            isCount <= 1'b0;
                            rPin_out <= 1'b0;
                        end
                    else
                        begin
                            isCount <= 1'b1;
                            rTime <= 9'd400;
                            rPin_out <= 1'b1;
                        end
                        
                1,3,5:
                    if (count_ms == rTime)
                        begin
                            i <= i + 1'b1;
                            isCount <= 1'b0;
                        end
                    else
                        begin
                            isCount <= 1'b1;
                            rTime <= 9'd50;
                        end
                        
                6:
                    begin
                        i <= i + 1'b1;
                        isDone <= 1'b1;
                    end
                    
                7:
                    begin
                        i <= 3'd0;
                        isDone <= 1'b0;
                    end
                    
            endcase
    end
    
    
    /***************************************/
    assign func_done_sig = isDone;
    assign beep_pin = !rPin_out; // buzzer低电平有效
    
    
endmodule


