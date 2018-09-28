`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:05:48 06/19/2018 
// Design Name: 
// Module Name:    flash_module 
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
module flash_module(
    CLK,
    RST_n,
    LED_Out
    );
    
    input CLK;
    input RST_n;
    output LED_Out;
    
    //周期为2s
    parameter T1S = 26'd49_999_999;
    
    reg [25:0] counter;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            counter <= 26'd0;
        end
        else if (counter == T1S) begin
            counter <= 26'd0;
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
        else if (counter == T1S) begin
            rLED_Out <= ~rLED_Out;      //%50占空比输出
        end
    end
    
    assign LED_Out = rLED_Out;

endmodule
