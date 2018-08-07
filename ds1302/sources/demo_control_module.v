
module demo_control_module(
    CLK,
    RSTn,
    cmd_start_sig,
    cmd_done_sig,
    time_write_data,
    time_read_data,
    leds
);

    input   CLK;
    input   RSTn;
    input   cmd_done_sig;
    input   [7:0]time_read_data;
    
    output  [7:0]cmd_start_sig;
    output  [7:0]time_write_data;
    output  [3:0]leds;
    
    reg [2:0]i;
    reg [7:0]cmd;
    reg [7:0]rTime_write_data;
    reg [3:0]rLEDs;
    
    
    /* 1ms计时 */
    localparam T1MS = 16'd49_999;
    reg [15:0]count;
    reg isCount;
    
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
    
    reg [11:0]count_ms;
    reg [11:0]rTime;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_ms <= 12'd0;
        else if (count_ms == rTime)
            count_ms <= 12'd0;
        else if (count == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    
    /* 关写保护-->写入时-->写入分-->写入秒-->读秒 */
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 3'd0;
            cmd <= 8'h00;
            rTime_write_data <= 8'h00;
            rLEDs <= 4'b0000;
        end
        else begin
            case(i)
            
                0:
                    if(cmd_done_sig) begin
                        cmd <= 8'h00;
                        i <= i + 1'b1;
                    end
                    else begin
                        cmd <= 8'b1000_0000;
                        rTime_write_data <= 8'h00;
                    end
                        
                1:
                    if(cmd_done_sig) begin
                        cmd <= 8'h00;
                        i <= i + 1'b1;
                    end
                    else begin
                        cmd <= 8'b0100_0000;
                        rTime_write_data <= {4'b0001, 4'd8}; //18hour
                    end
                    
                2:
                    if(cmd_done_sig) begin
                        cmd <= 8'h00;
                        i <= i + 1'b1;
                    end
                    else begin
                        cmd <= 8'b0010_0000;
                        rTime_write_data <= {4'd2, 4'd5}; //25minit
                    end
                    
                3:
                    if(cmd_done_sig) begin
                        cmd <= 8'h00;
                        i <= i + 1'b1;
                    end
                    else begin
                        cmd <= 8'b0001_0000;
                        rTime_write_data <= {1'b0, 3'd0, 4'd1}; //写秒 并启动DS1302
                    end
                    
                // 肉眼难以观察
                /*
                4:
                    if (cmd_done_sig) begin
                        rLEDs <= time_read_data[3:0]; //0-9循环
                        cmd <= 8'h00;
                        i <= 3'd4; //必不可少
                    end
                    else begin
                        cmd <= 8'b0000_0001; //读秒
                        rLEDs <= 4'b0000;
                    end
                */
                
                4:
                    /* 前450ms 读秒寄存器操作 LEDs熄灭 */
                    if (count_ms == rTime) begin
                        isCount <= 1'b0;
                        rLEDs <= time_read_data[3:0];
                        i <= 3'd5;
                    end
                    else begin
                        isCount <= 1'b1;
                        rTime <= 12'd450;
                        
                        if (cmd_done_sig) begin
                            cmd <= 8'h00;
                        end
                        else
                            cmd <= 8'b0000_0001; //读秒
                    end
                    
                5:
                    /* 延时500ms LEDs显示4状态"最后一次"秒寄存器低4bits */
                    if (count_ms == rTime) begin
                        isCount <= 1'b0;
                        rLEDs <= 4'b0000;
                        i <= 3'd4;
                    end
                    else begin
                        isCount <= 1'b1;
                        rTime <= 12'd500;
                    end

            endcase
        end
    end
    
    assign cmd_start_sig = cmd;
    assign time_write_data = rTime_write_data;
    assign leds = rLEDs;
    
endmodule

