`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:42:11 08/10/2018 
// Design Name: 
// Module Name:    beep_control_module 
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
module beep_control_module(
    CLK,
    RSTn,
    FIFO_read_data,
    empty_sig,
    read_req_sig,
    func_done_sig,
    func_start_sig
    );
    
    input CLK;
    input RSTn;
    
    input [7:0]FIFO_read_data;
    input empty_sig;
    output read_req_sig;
    
    input func_done_sig;
    output [1:0]func_start_sig;
    
    /*********************************************/
    reg [2:0]i;
    reg isRead;
    reg [1:0]rCmd;
    reg [1:0]isStart; // [1]S [0]O
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            begin
               i <= 3'd0;
                isRead <= 1'b0;
               rCmd <= 2'b00;
               isStart <= 2'b00;
            end
        else
            case(i)
                
                0:
                    if (!empty_sig)
                        i <= i + 1'b1;
                        
                1:
                    begin
                        isRead <= 1'b1;
                        i <= i + 1'b1;
                    end
                
                2:
                    begin
                        isRead <= 1'b0;
                        i <= i + 1'b1;
                    end
                    
                3:
                    begin
                        if (FIFO_read_data == 8'h1b)
                            rCmd <= 2'b10; // S
                        else if(FIFO_read_data == 8'h44)
                            rCmd <= 2'b01; // O
                        else
                            rCmd <= 2'b00;
                            
                        i <= i + 1'b1;
                    end
                    
                4:
                    if (rCmd == 2'b00)
                        i <= 3'd0;
                    else
                        i <= i + 1'b1;
                       
                5:
                    if (func_done_sig)
                        begin
                            i <= 3'd0;
                            rCmd <= 2'b00;
                            isStart <= 2'b00;
                        end
                    else
                        isStart <= rCmd;

            endcase
    end
    
    
    /*********************************************/
    assign read_req_sig = isRead;
    assign func_start_sig = isStart;


endmodule













































