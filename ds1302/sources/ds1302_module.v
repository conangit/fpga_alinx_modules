

module ds1302_module(
    CLK,
    RSTn,
    rtc_rst,
    rtc_sclk,
    rtc_sio,
    time_write_data,
    time_read_data,
    cmd_start_sig,
    cmd_done_sig
);

    input CLK;
    input RSTn;
    output rtc_rst;
    output rtc_sclk;
    inout rtc_sio;
    input [7:0]time_write_data;
    output [7:0]time_read_data;
    input [7:0]cmd_start_sig;
    output cmd_done_sig;


    wire func_done_sig;
    wire [1:0]func_start_sig;
    wire [7:0]words_addr;
    wire [7:0]write_data;
    wire [7:0]read_data;

    cmd_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .cmd_start_sig(cmd_start_sig),
        .cmd_done_sig(cmd_done_sig),
        .func_done_sig(func_done_sig),
        .func_start_sig(func_start_sig),
        .read_data(read_data), // input from U2
        .words_addr(words_addr),
        .write_data(write_data),
        .time_write_data(time_write_data),
        .time_read_data(time_read_data) // out to top
    );
    
    function_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .func_start_sig(func_start_sig),
        .words_addr(words_addr),
        .write_data(write_data),
        .read_data(read_data), // out to U1
        .func_done_sig(func_done_sig),
        .rtc_rst(rtc_rst),
        .rtc_sclk(rtc_sclk),
        .rtc_sio(rtc_sio)
    );
    
    
endmodule

