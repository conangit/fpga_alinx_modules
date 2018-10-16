`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:13 08/08/2018 
// Design Name: 
// Module Name:    optional_pwm_module 
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
module optional_pwm_module2(
    CLK,
    RSTn,
    option_keys,
    pwm_out
    );
    
    input CLK;
    input RSTn;
    input [3:0]option_keys;
    output pwm_out;

    /*
     * 1KHz的方波分成256份
     * t = 1ms/256=3.9us
     * 50MHz时钟 n=50 * 3.9 = 195
     */
    // 3.9us
    parameter SEGMENT = 8'd195;
    
    reg [7:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            count <= 8'd0;
        else if(count == SEGMENT)
            count <= 8'd0;
        else
            count <= count + 1'b1;
    end
    
    
    reg [7:0]system_seg;
    
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            system_seg <= 8'd0;
        else if (system_seg == 8'd255)
            system_seg <= 8'd0;
        else if (count == SEGMENT)
            system_seg <= system_seg + 1'b1;
    end
    
    reg [7:0]option_seg;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            option_seg <= 8'd0;
        else if (option_keys[0]) // max
                option_seg <= 8'd255;
        else if (option_keys[1]) // half
                option_seg <= 8'd127;
        else if (option_keys[2]) // 20%
                option_seg <= 8'd51;
        else if (option_keys[3]) // close
                option_seg <= 8'd0;
    end
    
    assign pwm_out = (system_seg < option_seg) ? 1'b1 :1'b0;

endmodule

