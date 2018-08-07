

module cmd_control_module (
    CLK,
    RSTn,
    cmd_start_sig,
    func_done_sig,
    func_start_sig,
    cmd_done_sig
);

    input CLK;
    input RSTn;
    
    // cmd_start_sig[3]=4'b1000 SSS
    // cmd_start_sig[2]=4'b0100 SOS
    // cmd_start_sig[1]=4'b0010 OSO
    // cmd_start_sig[0]=4'b0001 OOO
    input [3:0]cmd_start_sig;
    input func_done_sig;
    
    output [1:0]func_start_sig;
    output cmd_done_sig;
    
    /*
     * SSS    012 isStart = 2'b10
     * SOS    02  isStart = 2'b10    1   isStart = 2'b01
     * OSO    1   isStart = 2'b10    02  isStart = 2'b01
     * OOO                           012 isStart = 2'b01
     */
    reg [2:0]i;
    reg [1:0]isStart;
    reg isDone;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 3'd0;
            isStart <= 2'b00;
            isDone <= 1'b0;
        end
        else if (cmd_start_sig[3]) begin //SSS
            case(i)
                3'd0, 3'd1, 3'd2:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b10;
                        
                3'd3:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd4:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            endcase
        end
        else if (cmd_start_sig[2]) begin //SOS
            case(i)
                3'd0, 3'd2:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b10;
                        
                3'd1:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b01;
                        
                3'd3:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd4:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            endcase
        end
        else if (cmd_start_sig[1]) begin //OSO
            case(i)
                3'd0, 3'd2:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b01;
                        
                3'd1:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b10;
                        
                3'd3:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd4:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            endcase
        end
        else if (cmd_start_sig[0]) begin //OOO
            case(i)
                3'd0, 3'd1, 3'd2:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b01;
                        
                3'd3:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd4:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            endcase
        end
    end
    
    
    assign func_start_sig = isStart;
    assign cmd_done_sig = isDone;

endmodule

