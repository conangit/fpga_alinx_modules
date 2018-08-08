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
    
    /* PWM波的整个周期计时器 */
    reg [7:0]system_seg;
    
    always @(posedge CLK or negedge RSTn) begin
        if(!RSTn)
            system_seg <= 8'd0;
        else if (system_seg == 8'd255)
            system_seg <= 8'd0;
        else if (count == SEGMENT)
            system_seg <= system_seg + 1'b1;
    end
    
    /* 用于消除按键防抖设计带来对PWM波调节的影响 */
    parameter T1MS = 16'd49_999;
    
    reg [15:0]count2;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count2 <= 16'd0;
        else if (count2 == T1MS)
            count2 <= 16'd0;
        else if (isCount)
            count2 <= count2 + 1'b1;
        else
            count2 <= 16'd0;
    end
    
    /* max 2047ms延时 */
    reg [10:0]count_ms;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_ms <= 11'd0;
        else if (count_ms == rTime)
            count_ms <= 11'd0;
        else if(count2 == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    
    /* 按键作用下 改变PWM波的占用比 */
    reg [7:0]option_seg;
    reg [10:0]rTime;
    reg isCount;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            option_seg <= 8'd0;
            rTime <= 11'd2047;
            isCount <= 1'b0;
        end
        else if (option_keys[0]) begin // half PWM
                option_seg <= 8'd127;
        end
        else if (option_keys[1]) begin // PWM+10
            if (count_ms == rTime) begin // 延时后才作用于option_seg
                isCount <= 1'b0;
                if(option_seg < 8'd245)
                    option_seg <= option_seg + 8'd10;
                else
                    option_seg <= 8'd255;
                end
            else begin
                rTime <= 11'd900;
                isCount <= 1'b1;
            end
        end
        else if (option_keys[2]) begin // PWM-10
            if (count_ms == rTime) begin
                isCount <= 1'b0;
                if(option_seg > 8'd10)
                    option_seg <= option_seg - 8'd10;
                else
                    option_seg <= 8'd0;
                end
            else begin
                rTime <= 11'd900;
                isCount <= 1'b1;
            end
        end
        else if (option_keys[3]) begin // PWM+1
            if (count_ms == rTime) begin
                isCount <= 1'b0;
                if(option_seg < 8'd255)
                    option_seg <= option_seg + 8'd1;
                else
                    option_seg <= 8'd255;
                end
            else begin
                rTime <= 11'd900;
                isCount <= 1'b1;
            end
        end
        else begin
            // 若没有此语句 则在option_keys[1]有效区间(50ms) 45ms时刻option_seg改变 剩下5ms依然会使能isCount 则count2(count_ms)的值将变得不确定
            // 故应该在按键释放 将延时设计也复位(失能)
            isCount <= 1'b0;
        end
    end
    
    // led
    // assign led_out = (system_seg < option_seg) ? 1'b1 :1'b0;
    // buzzer
    assign led_out = (system_seg < option_seg) ? 1'b0 :1'b1;

endmodule

/* <1>
 * 当PWM波周期为1ms，实验失败的原因:
 * 由于按键防抖设计 按键按下产生的高电平，需要在按键弹起后释放
 * 而按键弹起仍有防抖设计 即需要20ms后 才会释放这个高电平
 * 而在key按下维持20ms高电平输出期间 option_seg早已到峰值0/255 (理论上option_seg变化一次只需1/50us=20ns)
 * 
 * <2>
 * 修改设计 按键按下 并不会立即作用到option_seg
 * 在一定延时后(去除防抖20ms的持续高电平带来的影响) 才作用到option_seg
 *
 * 上述写法 在实验室中产生错觉 认为真的是按键按下 PWM+10; 其实是手速太慢的原因
 * 比如在复位后 PWD=0 理论上按下按键PWM=10 但快速按下 却发现铃不响(灯不亮)
 * 本质上是因为延时30ms期间，前20ms option_keys[1]==1'b1 而后10ms option_keys[1]已经为1'b0
 * 故而option_seg <= option_seg + 8'd10;并不会得带执行
 * PS:没有麒麟臂,手速无法这么快,可增加延时 一样可观察到实验效果
 *
 * 但此实验中 按住按键不松手 的确会不停增加PWM，原因在于option_keys[1]==1'b1一直有效
 * 则option_seg <= option_seg + 8'd10;会每隔30ms得带一次执行
 * 
 * <3>
 * 正确的做法应该是，使得延时小于按键防抖设计
 * 但是！！！！
 * 注意:也不能低于防抖延时设计的1/2，不然在option_keys[1]==1'b1有效期内，option_seg <= option_seg + 8'd10;会作用多次
 * 也即在按键按下高电平期间(20ms)，option_seg必须得到改变，并且仅且改变一次
 * 即延时为:1/2按键防抖~~按键之间
 *
 * <4>
 * 实验发现 按键<0>键option_seg此时为127,但是按大概4次<2>键(-10)，似乎option_seg就已经为0
 * 更多调试 需要借助其他手段了
 *
 * <5>
 * "无限拉长"按键延时设计 也许可能得要想要结果
 * 结果在下个实验
 *
 * <6>
 * 注意！！！！
 * 不能将按下防抖也拉长，否则按下延时阶段按键就已经释放，将无法检测但按键弹起动作 则按键输出高电平会一直保持有效
 * 同理，本实验中，间隔很短时间内 多次按键将不响应按键 因为此时电路还处于按键弹起过程中
 * 这不正式按键防抖的原理所在么！！！！哈哈哈哈
 *
 * 将设计改为：
 * 按键按下防抖20ms
 * 按键弹起防抖1000ms
 * 响应延时900ms
 * 实验正确！
 */

