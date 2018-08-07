

module demo_module (
    input CLK,
    input RSTn,
    output pin_out
);

    wire func_en_sig;
    wire [3:0]cmd_start_sig;
    wire cmd_done_sig;

    demo_control_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .cmd_done_sig(cmd_done_sig),
        .func_en_sig(func_en_sig),
        .cmd_start_sig(cmd_start_sig)
    );
    
    sos_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .func_en_sig(func_en_sig),
        .cmd_start_sig(cmd_start_sig),
        .cmd_done_sig(cmd_done_sig),
        .pin_out(pin_out)
    );


endmodule

