module s_o_function
(
    clk,
    rst_n,
    func_start,
    func_done,
    pin_out
);

    input clk;
    input rst_n;
    
    input [1:0] func_start;
    output reg func_done;
    
    output pin_out;
    
    /*********************************/
    
    parameter T1MS = 16'd49_999;
    
    /* 在isCount信号使能的作用下 计时1ms */
    reg [15:0] count1;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            count1 <= 16'd0;
        else if (count1 == T1MS)
            count1 <= 16'd0;
        else if (isCount)
            count1 <= count1 + 1'b1;
        else
            count1 <= 16'd0;
    end
    
    /* 计时rTime毫秒时间 */
    reg [9:0] count_MS;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            count_MS <= 10'd0;
        else if(count_MS == rTime)
            count_MS <= 10'd0;
        else if (count1 == T1MS)
            count_MS <= count_MS + 1'b1;
    end
    
    /*********************************/

    reg [3:0] i;
    reg isCount;
    reg [9:0] rTime;
    reg rPin;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 4'd0;
            isCount <= 1'b0;
            rTime <= 10'd0;
            func_done <= 1'b0;
            rPin <= 1'b0;
        end
        else if(func_start[1]) //S
        begin
            case(i)
                0,2,4:
                    if(isCount && count_MS == rTime)
                    begin
                        i <= i + 1;
                        isCount <= 1'b0;
                        rPin <= 1'b0;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 100;
                        rPin <= 1'b1;
                    end
                    
                1,3,5:
                    if(isCount && count_MS == rTime)
                    begin
                        i <= i + 1;
                        isCount <= 1'b0;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 50;
                    end
                    
                6:
                    begin
                        i <= 7;
                        func_done <= 1'b1;
                    end
                    
                7:
                    begin
                        i <= 0;
                        func_done <= 1'b0;
                    end
            endcase
        end
        else if(func_start[0]) //O
        begin
            case(i)
                0,2,4:
                    if(isCount && count_MS == rTime)
                    begin
                        i <= i + 1;
                        isCount <= 1'b0;
                        rPin <= 1'b0;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 400;
                        rPin <= 1'b1;
                    end
                    
                1,3,5:
                    if(isCount && count_MS == rTime)
                    begin
                        i <= i + 1;
                        isCount <= 1'b0;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 50;
                    end
                    
                6:
                    begin
                        i <= 7;
                        func_done <= 1'b1;
                    end
                    
                7:
                    begin
                        i <= 0;
                        func_done <= 1'b0;
                    end
            endcase
        end
    end
    
    assign pin_out = !rPin;

endmodule


