`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:00:18 06/14/2018 
// Design Name: 
// Module Name:    led0_module 
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
module led0_module(
    input CLK,
    input RST_n,
    output LED_Out
    );
    
    parameter T100MS  = 23'd5_000_000;
    parameter T1_25MS = 23'd1_250_000;
    parameter T2_25MS = 23'd2_500_000;
    parameter T3_25MS = 23'd3_750_000;
    
    reg [22:0]counter;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 23'd0;
        end
        else if (counter == T100MS) begin
            counter <= 23'd0;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    
    reg rLED_Out;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            rLED_Out <= 1'b0;
        end
        else if (counter >= 23'd0 && counter <= T1_25MS) begin
            rLED_Out <= 1'b1;
        end
        else begin
            rLED_Out <= 1'b0;
        end
    end
    
    assign LED_Out = rLED_Out;

endmodule
