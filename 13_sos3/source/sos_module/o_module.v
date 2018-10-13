

/*
 * pin_out=0, buzzer
 */

module o_module
(
    clk,
    rst_n,
    start_sig,
    done_sig,
    pin_out
);
    
    input clk;
    input rst_n;
    
    input start_sig;
    
    output done_sig;
    output pin_out;
    
    parameter T1MS = 16'd49_999;
    
    /* 在isCount信号使能的作用下 计时1ms */
    reg [15:0]count1;
    
    always @(posedge clk or negedge rst_n) begin
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
    reg [9:0]count_MS;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_MS <= 10'd0;
        else if(count_MS == rTime)
            count_MS <= 10'd0;
        else if (count1 == T1MS)
            count_MS <= count_MS + 1'b1;
    end
    
    /* 产生SOS信号的O信号 */
    reg [2:0]i;
    reg isCount;
    reg isDone;
    reg rPin_out;
    reg [9:0]rTime;
    
    // O信号 -------- . -------- . -------- .
    //           0    1     2    3     4    5
    // 0 2 4三声长 400ms
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
        begin
            i <= 3'd0;
            isCount <= 1'b0;
            isDone <= 1'b0;
            rPin_out <= 1'b1;
            rTime <= 10'd1000;      // 1000ms
        end
        else if(start_sig)
        begin
            case (i)
            
                3'd0, 3'd2, 3'd4:
                    if (count_MS == rTime)
                    begin
                        i <= i + 1'b1;
                        isCount <= 1'b0;
                        rPin_out <= 1'b1;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 10'd400;
                        rPin_out <= 1'b0;
                    end

                3'd1, 3'd3, 3'd5:
                    if (count_MS == rTime)
                    begin
                        i <= i + 1'b1;
                        isCount <= 1'b0;
                    end
                    else
                    begin
                        isCount <= 1'b1;
                        rTime <= 10'd50;
                    end

                3'd6:
                    begin
                        i <= i + 1'b1;
                        isDone <= 1'b1;
                    end
                
                3'd7:
                    begin
                        i <= 3'd0;
                        isDone <= 1'b0;
                    end
                    
            endcase
        end
    end
    
    assign done_sig = isDone;
    assign pin_out = rPin_out;
    
endmodule
