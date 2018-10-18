/*
rtc_config[3] -- 进入/退出配置模式
rtc_config[2] -- +1操作
rtc_config[1] -- -1操作
rtc_config[0] -- 循环切换(时>>分>>秒)

rtc_time[23:16] --  rtc_time[23:10] 时十位
                    rtc_time[28:16] 时个位

rtc_time[15:8]  --  rtc_time[15:12] 分十位
                    rtc_time[11:8]  分个位

rtc_time[7:0]  --   rtc_time[7:4]  秒十位
                    rtc_time[3:0]  秒个位
*/


module rtc_interface
(
    input clk,
    input rst_n,
    
    input [3:0] rtc_config,
    output [23:0] rtc_time,
    
    output rtc_sclk,
    output rtc_rst,
    inout rtc_sio,
    
    output config_sig   //指示RTC是否处于配置模式
);


    wire cmd_done;
    wire [7:0] cmd_sig;
    wire [7:0] time_read_data;
    wire [7:0] time_write_data;
    
    
    rtc_control u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .rtc_config(rtc_config),
        .rtc_time(rtc_time),
        .cmd_done(cmd_done),
        .cmd_sig(cmd_sig),
        .time_read_data(time_read_data),
        .time_write_data(time_write_data),
        .config_sig(config_sig)
    );
    
    
    ds1302_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .cmd_sig(cmd_sig),
        .cmd_done(cmd_done),
        .time_write_data(time_write_data),
        .time_read_data(time_read_data),
        .rtc_sclk(rtc_sclk),
        .rtc_rst(rtc_rst),
        .rtc_sio(rtc_sio)
    );
    
endmodule

