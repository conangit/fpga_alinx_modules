module exp15_demo
(
    input clk,
    input rst_n,
    
    output rtc_sclk,
    output rtc_ce,
    inout rtc_sio,
    
    output tx_pin

);


    parameter write_unprotect       = 8'b1000_0000;
    parameter write_hour            = 8'b0100_0000;
    parameter write_minit           = 8'b0010_0000;
    parameter write_second          = 8'b0001_0000;
    parameter write_protect         = 8'b0000_1000;
    parameter read_hour             = 8'b0000_0100;
    parameter read_minit            = 8'b0000_0010;
    parameter read_second           = 8'b0000_0001;
    
    
    //增加PLL
    wire clk_out;
    wire clk_locked;
    
    pll_ip u1
    (
        .CLK_IN1(clk),
        .CLK_OUT1(clk_out),
        .RESET(!rst_n),
        .LOCKED(clk_locked) //指示时钟达到稳态 可辅作为其他所有输出时钟驱动模块的使能信号的一部分 -- 直接作用在"异步复位同步释放"上
    );
    
    
    //增加异步复位同步释放
    reg reset_1;
    reg reset_2;
    wire reset_in;
    
    always @(posedge clk_out or negedge rst_n)
    begin
        if(!rst_n)
            begin
            reset_1 <= 1'b0;
            reset_2 <= 1'b0;
            end
        else if(clk_locked) //确保复位后 电路时钟是稳定态
            begin
            reset_1 <= 1'b1;
            reset_2 <= reset_1;
            end
        else
            begin
                reset_1 <= 1'b0;
                reset_2 <= 1'b0;
            end
    end

    assign reset_in = reset_2;
    
    /**************************************/

    reg [7:0] cmd;
    wire cmd_done;
    wire [7:0] read_data;

    ds1302_module u2
    (
        .clk(clk_out),
        .rst_n(reset_in),
        .cmd(cmd),
        .cmd_done(cmd_done),
        .read_data(read_data),
        .sclk(rtc_sclk),
        .ce(rtc_ce),
        .sio(rtc_sio)
    );
    
    reg tx_en_sig;
    reg [7:0] tx_data;
    wire tx_done;
    
    tx_module u3
    (
        .CLK(clk_out),
        .RST_n(reset_in),
        .Tx_En_Sig(tx_en_sig),
        .Tx_Data(tx_data),
        .Tx_Done_Sig(tx_done),
        .Tx_Pin_Out(tx_pin)
    );
    
    
    parameter T1S = 26'd49_999_999;
    
    reg [25:0] count;
    reg isCount;
    
    always @(posedge clk_out or negedge reset_in)
    begin
        if(!reset_in)
            count <= 26'd0;
        else if(count == T1S)
            count <= 26'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 26'd0;
    end
    
    reg [3:0] i;
    
    always @(posedge clk_out or negedge reset_in)
    begin
        if(!reset_in)
        begin
            i <= 4'd5; //用于一直读取时间 输出到串口
            isCount <= 1'b0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
            cmd <= 8'd0;
        end
        else
        begin
            case(i)
                0:
                    if(cmd_done)
                    begin
                        i <= 1;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= write_unprotect;
            
                1:
                    if(cmd_done)
                    begin
                        i <= 2;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= write_hour;
                
                2:
                    if(cmd_done)
                    begin
                        i <= 3;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= write_minit;
            
                3:
                    if(cmd_done)
                    begin
                        i <= 4;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= write_second;
            
                4:
                    if(cmd_done)
                    begin
                        i <= 5;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= write_protect;
                        
                5:
                    if(count == T1S)
                    begin
                        i <= 6;
                        isCount <= 1'b0;
                    end
                    else
                        isCount <= 1'b1;
                        
                6:
                    if(cmd_done)
                    begin
                        i <= 7;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= read_hour;
                        
                7:
                    if(tx_done)
                    begin
                        tx_en_sig <= 1'b0;
                        i <= 8;
                    end
                    else
                    begin
                        tx_en_sig <= 1'b1;
                        tx_data <= read_data;
                    end
                    
                8:
                    if(cmd_done)
                    begin
                        i <= 9;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= read_minit;
                        
                9:
                    if(tx_done)
                    begin
                        tx_en_sig <= 1'b0;
                        i <= 10;
                    end
                    else
                    begin
                        tx_en_sig <= 1'b1;
                        tx_data <= read_data;
                    end
                    
                10:
                    if(cmd_done)
                    begin
                        i <= 11;
                        cmd <= 8'd0;
                    end
                    else
                        cmd <= read_second;
                    
                11:
                    if(tx_done)
                    begin
                        tx_en_sig <= 1'b0;
                        i <= 5;
                    end
                    else
                    begin
                        tx_en_sig <= 1'b1;
                        tx_data <= read_data;
                    end
                    
                default: i <= 5;
            endcase
        end
    end
    
    
endmodule





