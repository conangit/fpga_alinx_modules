module led_gui_interface
(
    input clk,
    input rst_n,
    
    input [3:0] config_sig,
    output [3:0] led_out
);

    wire [11:0] menu_sig;

    led_gui_menu u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .config_sig(config_sig),
        .menu_sig(menu_sig)
    );

    led_gui_control u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .menu_sig(menu_sig),
        .led_out(led_out)
    );


endmodule

