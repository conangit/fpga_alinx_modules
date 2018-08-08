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
module optional_pwm_module(
    CLK,
    RSTn,
    option_keys,
    led_out
    );
    
    input CLK;
    input RSTn;
    input [3:0]option_keys;
    output led_out;

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
        else if (option_keys[0]) begin // PWM+10
            if(option_seg < 8'd245)
                option_seg <= option_seg + 8'd10;
            else
                option_seg <= 8'd255;
        end
        else if (option_keys[1]) begin // PWM-10
            if (option_seg > 8'd10)
                option_seg <= option_seg - 8'd10;
            else
                option_seg <= 8'd0;
        end
        else if (option_keys[2]) begin // PWM+1
            if(option_seg < 8'd255)
                option_seg <= option_seg + 8'd1;
            else
                option_seg <= 8'd255;
        end
        else if (option_keys[3]) begin // half PWM
                option_seg <= 8'd127;
        end
    end
    
    // led
    assign led_out = (system_seg < option_seg) ? 1'b1 :1'b0;
    // buzzer
    // assign led_out = (system_seg < option_seg) ? 1'b0 :1'b1;

endmodule

/*
 * 当PWM波周期为1ms，实验失败的原因:
 * 由于按键防抖设计 按键按下产生的高电平，需要在按键弹起后释放
 * 而按键弹起仍有防抖设计 即需要20ms后 才会释放这个高电平
 * 而在key按下维持20ms高电平输出期间 option_seg早已到峰值0/255 (理论上option_seg变化一次只需1/50us=20ns)
 */

