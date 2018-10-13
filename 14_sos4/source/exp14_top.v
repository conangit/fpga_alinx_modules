module exp14_top
(
    input clk,
    input rst_n,
    
    output pin_out
);


    reg [3:0] cmd_start;
    wire cmd_done;

    s_o_module u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .cmd_start(cmd_start),
        .cmd_done(cmd_done),
        .pin_out(pin_out)
    );
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            // cmd_start <= 4'b1000;       //SSS
            // cmd_start <= 4'b0100;       //SOS
            // cmd_start <= 4'b0010;       //OSO
            cmd_start <= 4'b0001;       //OOO
        else if(cmd_done)
            cmd_start <= 4'b0000;
    end
    
endmodule

