

module sos_control_module
(
    clk,
    rst_n,
    start_sig,
    done_sig,
    s_done_sig,
    o_done_sig,
    s_start_sig,
    o_start_sig
);

    input clk; 
    input rst_n;
    
    input start_sig;
    output done_sig;
    
    input s_done_sig;
    input o_done_sig;
    
    output s_start_sig;
    output o_start_sig;
    
    /***************************/
    
    reg [2:0]i;
    reg isS;
    reg isO;
    reg isDone;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
        begin
            i <= 3'd0;
            isS <= 1'b0;
            isO <= 1'b0;
            isDone <= 1'b0;
        end
        else if (start_sig)
        begin
            case(i)
                // S
                3'd0, 3'd2:
                    if (s_done_sig)
                    begin
                        i <= i + 1'b1;
                        isS <= 1'b0;
                        isO <= 1'b0;
                    end
                    else
                    begin
                        isS <= 1'b1;
                        isO <= 1'b0;
                    end
                    
                // O
                3'd1:
                    if (o_done_sig)
                    begin
                        i <= i + 1'b1;
                        isS <= 1'b0;
                        isO <= 1'b0;
                    end
                    else
                    begin
                        isS <= 1'b0;
                        isO <= 1'b1;
                    end
                    
                3'd3:
                    begin
                        i <= i + 1'b1;
                        isDone <= 1'b1;
                    end
                
                3'd4:
                    begin
                        i <= 3'd0;
                        isDone <= 1'b0;
                    end
            endcase
        end
    end
    
    
    assign s_start_sig = isS;
    assign o_start_sig = isO;
    assign done_sig = isDone;


endmodule

