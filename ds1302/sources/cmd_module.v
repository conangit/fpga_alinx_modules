

module cmd_module(
    CLK,
    RSTn,
    cmd_start_sig,
    cmd_done_sig,
    func_done_sig,
    func_start_sig,
    read_data,
    words_addr,
    write_data,
    time_write_data,
    time_read_data
);


    input   CLK;
    input   RSTn;
    
    input [7:0]cmd_start_sig;
    output cmd_done_sig;
    
    input func_done_sig;
    output [1:0]func_start_sig;
    
    input [7:0]read_data;
    output [7:0]words_addr;
    output [7:0]write_data;
    
    input [7:0]time_write_data;
    output [7:0]time_read_data;
    
    
    
    reg [7:0]rAddr;
    reg [7:0]rData;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            rAddr <= 8'h00;
            rData <= 8'h00;
        end
        else begin
            case(cmd_start_sig)
            
                8'b1000_0000: // write unprotect
                    begin
                        rAddr <= {2'b10, 5'd7, 1'b0};
                        rData <= 8'h00;
                    end
                    
                8'b0100_0000: // write hour
                    begin
                        rAddr <= {2'b10, 5'd2, 1'b0};
                        rData <= time_write_data;
                    end
                
                8'b0010_0000: // write minit
                    begin
                        rAddr <= {2'b10, 5'd1, 1'b0};
                        rData <= time_write_data;
                    end
                
                8'b0001_0000: // write second
                    begin
                        rAddr <= {2'b10, 5'd0, 1'b0};
                        rData <= time_write_data;
                    end
                    
                8'b0000_1000: // write protect
                    begin
                        rAddr <= {2'b10, 5'd7, 1'b0};
                        rData <= 8'b1000_0000; //8'h80
                    end
                
                8'b0000_0100: // read hour
                        rAddr <= {2'b10, 5'd2, 1'b1};
                
                8'b0000_0010: // read minit
                        rAddr <= {2'b10, 5'd1, 1'b1};
                
                8'b0000_0001: // read second
                        rAddr <= {2'b10, 5'd0, 1'b1};
                
            endcase
        end
    end
    
    
    reg [1:0]i;
    reg isDone;
    reg [1:0]isStart;
    reg [7:0]rRead;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 2'd0;
            isDone <= 1'b0;
            isStart <= 2'b00;
            rRead <= 8'h00;
        end
        else if (cmd_start_sig[7:3]) begin /* 写命令操作 */
            case(i)
                
                0:
                    if (func_done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b10;
                        
                1:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                2:
                    begin
                        isDone <= 1'b0;
                        i <= 2'd0;
                    end
                
            endcase
        end
        else if (cmd_start_sig[2:0]) begin /* 读命令操作 */
            case(i)
                
                0:
                    if (func_done_sig) begin
                        rRead <= read_data;
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else
                        isStart <= 2'b01;
                
                1:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                2:
                    begin
                        isDone <= 1'b0;
                        i <= 2'd0;
                    end
                    
            endcase
        end
    end
    
    
    assign words_addr = rAddr;
    assign write_data = rData;
    
    assign cmd_done_sig = isDone;
    assign func_start_sig = isStart;
    assign time_read_data = rRead;
    
endmodule

