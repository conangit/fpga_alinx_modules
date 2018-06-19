`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:47 06/19/2018 
// Design Name: 
// Module Name:    mix_module 
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
module mix_module(
    CLK, RST_n, flash_led, run_led
    );
    
    input CLK;
    input RST_n;
    output flash_led;
    output [2:0] run_led;
    
    wire w_flash_led;
    wire [2:0] w_run_led;
    
    flash_module F0(.CLK(CLK), .RST_n(RST_n), .LED_Out(w_flash_led));
    run_module R0(.CLK(CLK), .RST_n(RST_n), .LED_Out(w_run_led));

    assign flash_led = w_flash_led;
    assign run_led = w_run_led;


endmodule
