

module sos_module (
    CLK,
    RSTn,
    start_sig,
    done_sig,
    pin_out
);

    input CLK;
    input RSTn;
    input start_sig;
    output done_sig;
    output pin_out;
    
    wire s_start_sig;
    wire s_done_sig;
    wire s_pin_out;
    
    s_module U1(
        .CLK(CLK),
        .RSTn(RSTn),
        .start_sig(s_start_sig),
        .done_sig(s_done_sig),
        .pin_out(s_pin_out)
    );
    
    wire o_start_sig;
    wire o_done_sig;
    wire o_pin_out;
    
    o_module U2(
        .CLK(CLK),
        .RSTn(RSTn),
        .start_sig(o_start_sig),
        .done_sig(o_done_sig),
        .pin_out(o_pin_out)
    );
    
    sos_control_module U3(
        .CLK(CLK),
        .RSTn(RSTn),
        .start_sig(start_sig),
        .s_done_sig(s_done_sig),
        .o_done_sig(o_done_sig),
        .s_start_sig(s_start_sig),
        .o_start_sig(o_start_sig),
        .done_sig(done_sig)
);

    // S和O模块共用pin_out引脚
    reg rPin_out;
    
    always @(*) begin
        if(s_start_sig)
            rPin_out <= s_pin_out;
        else if (o_start_sig)
            rPin_out <= o_pin_out;
        else
            // rPin_out <= 1'b1;
            rPin_out <= 1'bx;
    end

    assign pin_out = rPin_out;

endmodule

