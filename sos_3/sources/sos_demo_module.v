

module sos_demo_module (
    input CLK,
    input RSTn,
    output pin_out
);

    wire start_sig;
    wire done_sig;
    
    sos_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .start_sig(start_sig),
        .done_sig(done_sig),
        .pin_out(pin_out)
    );
    
    reg isStart;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            isStart <= 1'b1;
        else if (done_sig)
            isStart <= 1'b0;
    end
    
    assign start_sig = isStart;

endmodule

