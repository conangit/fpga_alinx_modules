module sos_module_demo
(
    input clk,
    input rst_n,
    output pin_out
);

    reg start_sig;
    wire done_sig;
    
    sos_module
    (
        .clk(clk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .pin_out(pin_out)
    );
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            start_sig <= 1'b0;
        else if (done_sig)
            start_sig <= 1'b0;
        else
            start_sig <= 1'b1;
    end
    
endmodule

