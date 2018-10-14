module ds_command
(
    input clk,
    input rst_n,
    
    input [7:0] cmd,
    output reg cmd_done,
    
    input func_done,
    output reg [1:0] func_start,
    output reg [7:0] register_addr,
    output reg [7:0] write_data
);


    parameter write_unprotect       = 8'b1000_0000;
    parameter write_hour            = 8'b0100_0000;
    parameter write_minit           = 8'b0010_0000;
    parameter write_second          = 8'b0001_0000;
    parameter write_protect         = 8'b0000_1000;
    parameter read_hour             = 8'b0000_0100;
    parameter read_minit            = 8'b0000_0010;
    parameter read_second           = 8'b0000_0001;
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            register_addr <= 8'd0;
            write_data <= 8'd0;
        end
        else
        begin
            case(cmd)
                write_unprotect:
                    begin
                        register_addr <= {2'b10, 5'd7, 1'b0};
                        write_data <= 8'h00;
                    end
                
                write_hour: //24小时制 早上八点
                    begin
                        register_addr <= {2'b10, 5'd2, 1'b0};
                        write_data <= 8'h00;
                    end
                
                write_minit: //15分
                    begin
                        register_addr <= {2'b10, 5'd1, 1'b0};
                        write_data <= 8'h21;
                    end
                
                write_second: //启动计时
                    begin
                        register_addr <= {2'b10, 5'd0, 1'b0};
                        write_data <= 8'h00;
                    end
                
                write_protect:
                    begin
                        register_addr <= {2'b10, 5'd7, 1'b0};
                        write_data <= 8'h80;
                    end
                
                read_hour:
                    begin
                        register_addr <= {2'b10, 5'd2, 1'b1};
                    end
                
                read_minit:
                    begin
                        register_addr <= {2'b10, 5'd1, 1'b1};
                    end
                
                read_second:
                    begin
                        register_addr <= {2'b10, 5'd0, 1'b1};
                    end
            endcase
        end
    end
    
    
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 4'd0;
            func_start <= 2'b00;
            cmd_done <= 1'b0;
        end
        else if(cmd[7:3]) //write operation
        begin
            case(i)
                0:
                    if(func_done)
                    begin
                        i <= 1;
                        func_start <= 2'b00;
                    end
                    else
                        func_start <= 2'b10;
                        
                1:
                    begin
                        i <= 2;
                        cmd_done <= 1'b1;
                    end
                
                2:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
        else if(cmd[2:0]) //read operation
        begin
            case(i)
                0:
                    if(func_done)
                    begin
                        i <= 1;
                        func_start <= 2'b00;
                    end
                    else
                        func_start <= 2'b01;
                        
                1:
                    begin
                        i <= 2;
                        cmd_done <= 1'b1;
                    end
                
                2:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
    end
    
endmodule

