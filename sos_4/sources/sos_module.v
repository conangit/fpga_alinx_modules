

module sos_module (
    CLK,
    RSTn,
    func_en_sig,
    cmd_start_sig,
    cmd_done_sig,
    pin_out
);
    
    input CLK;
    input RSTn;
    
    input func_en_sig;
    input [3:0]cmd_start_sig;
    
    output cmd_done_sig;
    output pin_out;


    wire [1:0]func_start_sig;
    wire func_done_sig;

    
    function_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .func_start_sig(func_start_sig),
        .func_en_sig(func_en_sig),
        .func_done_sig(func_done_sig),
        .func_pin_out(pin_out)
    );
    
    cmd_control_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .cmd_start_sig(cmd_start_sig),
        .func_done_sig(func_done_sig),
        .func_start_sig(func_start_sig),
        .cmd_done_sig(cmd_done_sig)
);


endmodule

