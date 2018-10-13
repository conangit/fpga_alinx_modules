

module sos_module
(
    clk,
    rst_n,
    start_sig,
    done_sig,
    pin_out
);

    input clk;
    input rst_n;
    
    input start_sig;
    output done_sig;
    
    output pin_out;
    
    /****************/
    
    wire s_start_sig;
    wire s_done_sig;
    wire s_pin_out;
    
    wire o_start_sig;
    wire o_done_sig;
    wire o_pin_out;
    
    s_module S
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(s_start_sig),
        .done_sig(s_done_sig),
        .pin_out(s_pin_out)
    );
    
    o_module O
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(o_start_sig),
        .done_sig(o_done_sig),
        .pin_out(o_pin_out)
    );
    
    sos_control_module c1(
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .s_done_sig(s_done_sig),
        .o_done_sig(o_done_sig),
        .s_start_sig(s_start_sig),
        .o_start_sig(o_start_sig)
    );
    
    
    // S和O模块共用pin_out引脚
    assign pin_out = s_start_sig ? s_pin_out : (o_start_sig ? o_pin_out : 1'b1);

endmodule

