`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:19:46 06/24/2018 
// Design Name: 
// Module Name:    control_module 
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
module control_led_module(
    CLK,
    RST_n,
    SOS_En
    );
    
    input CLK;
    input RST_n;
    output reg SOS_En;
    
    //led: 1s * 6 + 3s * 3 + 0.5s * 9 = 19.5s
    parameter T20S = 30'd999_999_999;
    
    reg [29:0] count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            SOS_En <= 1'b0;
            count <= 30'd0;
        end
        else if (count == T20S) begin
            SOS_En <= 1'b1;
            count <= 30'd0;
        end
        else begin
            SOS_En <= 1'b0;
            count <= count + 1'b1;
        end
    end
    
endmodule
