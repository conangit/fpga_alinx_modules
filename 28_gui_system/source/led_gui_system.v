module led_gui_system
(
    input clk,
    input rst_n,
    input [3:0] key_in,
    output [3:0] led_out
);

    wire [3:0] config_sig;

    keys_interface u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .key_in(key_in),
        .key_out(config_sig)
    );
    
    
    led_gui_interface u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .config_sig(config_sig),
        .led_out(led_out)
    );

    
endmodule

