

module rtc_system
(
    input clk,
    input rst_n,
    //keys
    input [3:0] key_in,
    //rtc
    output rtc_sclk,
    inout rtc_sio,
    output rtc_rst,

    //digital
    output [7:0] smg_data,
    output [5:0] scan_sig,
    
    //index configuration
    output config_sig
);

    wire [3:0] key_out;
    wire [23:0] rtc_time;
    
    
    keys_interface u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .key_out(key_out)
    );
    
    
    rtc_interface u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .rtc_config(key_out),
        .rtc_time(rtc_time),
        .rtc_sclk(rtc_sclk),
        .rtc_rst(rtc_rst),
        .rtc_sio(rtc_sio),
        .config_sig(config_sig)
    );
    
    
    smg_interface u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .number_sig(rtc_time),
        .smg_data(smg_data),
        .scan_sig(scan_sig)
    );


endmodule

