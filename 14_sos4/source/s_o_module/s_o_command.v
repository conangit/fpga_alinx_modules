module s_o_command
(
    clk,
    rst_n,
    cmd_start,
    cmd_done,
    func_start,
    func_done
);

    input clk;
    input rst_n;
    
    //支持命令
    //1000 - SSS
    //0100 - SOS
    //0010 - OSO
    //0001 - OOO
    input [3:0] cmd_start;
    output reg cmd_done;
    
    output reg [1:0] func_start;
    input func_done;
    
    /*************************************/
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 4'd0;
            cmd_done <= 1'b0;
            func_start <= 2'b00;
        end
        else if(cmd_start[3]) //SSS
        begin
            case(i)
                0,1,2:
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b10;
                        
                3:
                    begin
                        i <= 4;
                        cmd_done <= 1'b1;
                    end
                
                4:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
        else if(cmd_start[2]) //SOS
        begin
            case(i)
                0,2: //S
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b10;
                        
                1: //O
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b01;
                        
                3:
                    begin
                        i <= 4;
                        cmd_done <= 1'b1;
                    end
                
                4:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
        else if(cmd_start[1]) //OSO
        begin
            case(i)
                0,2: //O
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b01;
                        
                1: //S
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b10;
                        
                3:
                    begin
                        i <= 4;
                        cmd_done <= 1'b1;
                    end
                
                4:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
        else if(cmd_start[0]) //OOO
        begin
            case(i)
                0,1,2: //O
                    if(func_done)
                    begin
                        func_start <= 2'b00;
                        i <= i + 1;
                    end
                    else
                        func_start <= 2'b01;
                
                3:
                    begin
                        i <= 4;
                        cmd_done <= 1'b1;
                    end
                
                4:
                    begin
                        i <= 0;
                        cmd_done <= 1'b0;
                    end
            endcase
        end
    end

endmodule

