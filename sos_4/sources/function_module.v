/* S信号 -- . -- . -- .
 *       0  1 2  3 4  5
 * 0 2 4 三声短 100ms
 * 1 3 5 间隔50ms
 *
 * O信号 -------- . -------- . -------- .
 *           0    1     2    3     4    5
 * 0 2 4 三声长 400ms
 * 1 3 5 间隔50ms
 */

module function_module (
    CLK,
    RSTn,
    func_start_sig,
    func_en_sig,
    func_done_sig,
    func_pin_out
);

    input CLK;
    input RSTn;
    // func_start_sig[1]=2'b10 S信号
    // func_start_sig[0]=2'b01 O信号
    input [1:0]func_start_sig;
    input func_en_sig;
    output func_done_sig;
    output func_pin_out;
    
    /* 1ms计时 */
    localparam T1MS = 16'd49_999;
    
    reg [15:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else if (isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    /* ms计时 max=400ms */
    reg [8:0]count_ms;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_ms <= 9'd0;
        else if (count_ms == rTime)
            count_ms <= 9'd0;
        else if (count == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    /* 产生:S信号 O信号 */
    reg [2:0]i;
    reg isCount;
    reg [8:0]rTime;
    reg isDone;
    reg rPin_out;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
              i <= 3'd0;
              isCount <= 1'b0;
              rTime <= 9'h1_ff;
              isDone <= 1'b0;
              rPin_out <= 1'b1; //buzzer低电平有效
        end
        else if (func_en_sig && func_start_sig[1]) begin // S信号
            case(i)
            
                3'd0, 3'd2, 3'd4:
                    if (count_ms == rTime) begin
                        rPin_out <= 1'b1;
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        rTime <= 9'd100;
                        isCount <= 1'b1;
                        rPin_out <= 1'b0;
                    end
                        
                3'd1, 3'd3, 3'd5:
                    if (count_ms == rTime) begin
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        rTime <= 9'd50;
                        isCount <= 1'b1;
                    end
                    
                3'd6:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd7:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            
            endcase
        end
        else if (func_en_sig && func_start_sig[0]) begin // O信号
            case(i)
            
                3'd0, 3'd2, 3'd4:
                    if (count_ms == rTime) begin
                        rPin_out <= 1'b1;
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        rTime <= 9'd400;
                        isCount <= 1'b1;
                        rPin_out <= 1'b0;
                    end
                        
                3'd1, 3'd3, 3'd5:
                    if (count_ms == rTime) begin
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    else begin
                        rTime <= 9'd50;
                        isCount <= 1'b1;
                    end
                    
                3'd6:
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                3'd7:
                    begin
                        isDone <= 1'b0;
                        i <= 3'd0;
                    end
            
            endcase
        end
    end
    
    assign func_done_sig = isDone;
    assign func_pin_out = rPin_out;

endmodule

