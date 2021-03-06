`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:06:12 06/19/2018 
// Design Name: 
// Module Name:    run_module 
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
module run_module(
    CLK,
    RST_n,
    LED_Out
    );

    input CLK;
    input RST_n;
    output [2:0] LED_Out;
    
    //周期为1.5s
    parameter T500mS = 26'd24_999_999;
    
    reg [24:0] counter;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 25'd0;
        end
        else if (counter == T500mS) begin
            counter <= 25'd0;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end
    
    reg [2:0] rLED_Out;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            rLED_Out <= 3'b001;
        else if (counter == T500mS)
            if (rLED_Out == 3'b000)
                rLED_Out <= 3'b001;
            else
                rLED_Out <= {rLED_Out[1:0], 1'b0}; //左右一位 低位补0
    end
    
    assign LED_Out = rLED_Out;

endmodule
