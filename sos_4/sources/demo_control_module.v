

module demo_control_module(
    CLK,
    RSTn,
    cmd_done_sig,
    func_en_sig,
    cmd_start_sig
);
    input CLK;
    input RSTn;
    input cmd_done_sig;
    
    output func_en_sig;
    output [3:0]cmd_start_sig;

    reg isEn;
    reg [3:0]cmd;

    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            isEn <= 1'b1;
            cmd <= 4'b1000; //SSS
            // cmd <= 4'b0100; //SOS
            // cmd <= 4'b0010; //OSO
            // cmd <= 4'b0001; //OOO
        end
        else if (cmd_done_sig)
            isEn <= 1'b0;
    end
    
    assign func_en_sig = isEn;
    assign cmd_start_sig = cmd;

endmodule

