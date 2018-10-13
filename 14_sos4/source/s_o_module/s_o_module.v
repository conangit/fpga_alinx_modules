module s_o_module
(
    input clk,
    input rst_n,
    
    input [3:0] cmd_start,
    output cmd_done,
    
    output pin_out
);

    wire [1:0] func_start;
    wire func_done;
    
    s_o_command u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .cmd_start(cmd_start),
        .cmd_done(cmd_done),
        .func_start(func_start),
        .func_done(func_done)
    );
    
    
    s_o_function u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .func_start(func_start),
        .func_done(func_done),
        .pin_out(pin_out)
    );
    
endmodule
