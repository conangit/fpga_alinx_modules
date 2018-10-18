module ds1302_module
(
    input clk,
    input rst_n,

    input [7:0] cmd_sig,
    output cmd_done,
    
    input [7:0]time_write_data,
    output [7:0] time_read_data,
    
    output rtc_sclk,
    output rtc_rst,
    inout rtc_sio
);


    wire [1:0] func_start;
    wire func_done;
    wire [7:0] register_addr;
    wire [7:0] write_data;
    wire [7:0] read_data;
    

    ds1302_function u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .func_start(func_start),
        .func_done(func_done),
        .register_addr(register_addr),
        .write_data(write_data),
        .read_data(read_data),
        .rtc_sclk(rtc_sclk),
        .rtc_rst(rtc_rst),
        .rtc_sio(rtc_sio)
    );
    
    
    ds1302_command u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .cmd_sig(cmd_sig),
        .cmd_done(cmd_done),
        .time_write_data(time_write_data),
        .time_read_data(time_read_data),
        .func_done(func_done),
        .func_start(func_start),
        .read_data(read_data),
        .register_addr(register_addr),
        .write_data(write_data)
    );

endmodule

