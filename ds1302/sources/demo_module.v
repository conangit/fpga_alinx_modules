

module demo_module(
    input CLK,
    input RSTn,
    
    output rtc_rst,
    output rtc_sclk,
    inout rtc_sio,
    
    output [3:0]leds
);

    wire [7:0]cmd_start_sig;
    wire cmd_done_sig;
    wire [7:0]time_write_data;
    wire [7:0]time_read_data;

    demo_control_module D1(
        .CLK(CLK),
        .RSTn(RSTn),
        .cmd_start_sig(cmd_start_sig),
        .cmd_done_sig(cmd_done_sig),
        .time_write_data(time_write_data),
        .time_read_data(time_read_data),
        .leds(leds)
    );
    
    ds1302_module D2(
        .CLK(CLK),
        .RSTn(RSTn),
        .rtc_rst(rtc_rst),
        .rtc_sclk(rtc_sclk),
        .rtc_sio(rtc_sio),
        .time_write_data(time_write_data),
        .time_read_data(time_read_data),
        .cmd_start_sig(cmd_start_sig),
        .cmd_done_sig(cmd_done_sig)
    );


endmodule

