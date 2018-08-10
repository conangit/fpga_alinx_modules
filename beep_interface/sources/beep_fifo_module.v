`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:11 08/10/2018 
// Design Name: 
// Module Name:    beep_fifo_module 
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
module beep_fifo_module(
    CLK,
    RSTn,
    write_req_sig,
    FIFO_write_data,
    full_sig,
    read_req_sig,
    FIFO_read_data,
    empty_sig
    );
    
    input CLK;
    input RSTn;
    
    input write_req_sig;
    input [7:0]FIFO_write_data;
    output full_sig;
    
    input read_req_sig;
    output [7:0]FIFO_read_data;
    output empty_sig;

    /*****************************************/


endmodule
