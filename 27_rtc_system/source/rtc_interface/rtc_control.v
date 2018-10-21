//rtc三种模式:初始化模式 正常模式 配置模式

module rtc_control
(
    input clk,
    input rst_n,
    
    input [3:0] rtc_config,
    output [23:0] rtc_time,
    
    input cmd_done,
    output reg [7:0] cmd_sig,
    
    input [7:0] time_read_data,
    output reg [7:0] time_write_data,
    
    output config_sig
);


    parameter write_unprotect       = 8'b1000_0000;
    parameter write_hour            = 8'b0100_0000;
    parameter write_minute          = 8'b0010_0000;
    parameter write_second          = 8'b0001_0000;
    parameter write_protect         = 8'b0000_1000;
    parameter read_hour             = 8'b0000_0100;
    parameter read_minute           = 8'b0000_0010;
    parameter read_second           = 8'b0000_0001;


    /**************************/
    
    reg isConfig; //配置模式标志位
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            isConfig <= 1'b0;
        else if(rtc_config[3])
            isConfig <= ~isConfig;
    end
    
    assign config_sig = isConfig;
    
    /**************************/
    
    reg [5:0] i;            //步骤
    reg [5:0] go;           //步骤返回态
    reg [7:0] hour;         //小时寄存器
    reg [7:0] minute;       //分钟寄存器
    reg [7:0] second;       //秒寄存器
    reg [7:0] temp;         //时,分,秒配置暂存寄存器
    reg [7:0] comp;         //时,分,秒允许的最大值
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 6'd0;
            go <= 6'd0;
            cmd_sig <= 8'd0;
            time_write_data <= 8'd0;
            hour <= 8'd0;
            minute <= 8'd0;
            second <= 8'd0;
            temp <= 8'd0;
            comp <= 8'd0;
        end
        else
        begin
            case(i)
                
                /* initial mode */
                
                0:
                begin //read hour value for initializing hour register
                    if(cmd_done)
                    begin
                        i <= 1;
                        cmd_sig <= 8'd0;
                        hour <= time_read_data;
                    end
                    else
                        cmd_sig <= read_hour;
                end
                
                1:
                begin //read minute value for initializing minute register
                    if(cmd_done)
                    begin
                        i <= 2;
                        cmd_sig <= 8'd0;
                        minute <= time_read_data;
                    end
                    else
                        cmd_sig <= read_minute;
                end
                
                2:
                begin //read second value for initializing second register
                    if(cmd_done)
                    begin
                        i <= 3;
                        cmd_sig <= 8'd0;
                        second <= time_read_data;
                    end
                    else
                        cmd_sig <= read_second;
                end
                
                3:
                begin //write unprotect
                    if(cmd_done)
                    begin
                        i <= 4;
                        cmd_sig <= 8'd0;
                    end
                    else
                        cmd_sig <= write_unprotect;
                end
                
                4:
                begin //init hour
                    if(cmd_done)
                    begin
                        i <= 5;
                        cmd_sig <= 8'd0;
                    end
                    else
                    begin
                        cmd_sig <= write_hour;
                        time_write_data <= hour;
                    end
                end
                
                5:
                begin //init minute
                    if(cmd_done)
                    begin
                        i <= 6;
                        cmd_sig <= 8'd0;
                    end
                    else
                    begin
                        cmd_sig <= write_minute;
                        time_write_data <= minute;
                    end
                end
                
                6:
                begin //init second and start
                    if(cmd_done)
                    begin
                        i <= 7;
                        cmd_sig <= 8'd0;
                    end
                    else
                    begin
                        cmd_sig <= write_second;
                        time_write_data <= (second & 8'h7F); //bit7=0 -- start
                    end
                end
                
                7:
                begin //write protect
                    if(cmd_done)
                    begin
                        i <= 8;
                        cmd_sig <= 8'd0;
                    end
                    else
                        cmd_sig <= write_protect;
                end
                
                /* normal mode */
                
                8:
                begin //judge ? setting
                    if(isConfig)
                        i <= 12;
                    else
                        i <= 9;
                end
                
                9:
                begin //read hour
                    if(cmd_done)
                    begin
                        i <= 10;
                        cmd_sig <= 8'd0;
                        hour <= time_read_data;
                    end
                    else
                        cmd_sig <= read_hour;
                end
                
                10:
                begin //read minute
                    if(cmd_done)
                    begin
                        i <= 11;
                        cmd_sig <= 8'd0;
                        minute <= time_read_data;
                    end
                    else
                        cmd_sig <= read_minute;
                end
                
               11:
                begin //read second
                    if(cmd_done)
                    begin
                        i <= 8;
                        cmd_sig <= 8'd0;
                        second <= time_read_data;
                    end
                    else
                        cmd_sig <= read_second;
                end
                
                /* setting mode */
                
                12:
                begin //write unprotect
                    if(cmd_done)
                    begin
                        i <= 13;
                        cmd_sig <= 8'd0;
                    end
                    else
                        cmd_sig <= write_unprotect;
                end
                
                13:
                begin //Pre-config:<1>"当前时间暂存到hour,minute,second寄存器";<2>关闭RTC时钟
                    if(cmd_done)
                    begin
                        i <= 14;
                        cmd_sig <= 8'd0;
                        temp <= hour; //这点很重要--默认进入配置小时 如不按键 将会把temp赋给hour
                    end
                    else
                    begin
                        cmd_sig <= write_second;
                        time_write_data <= 8'h80; //bit7=1 -- stop
                    end
                end
                
                14:
                begin //config hour
                    if(!isConfig) //退出配置模式
                        i <= 4;
                    else if(rtc_config[2]) //+1操作
                    begin
                        i <= 17;
                        go <= 14;
                        temp <= hour;
                        comp <= 8'h23;
                    end
                    else if(rtc_config[1]) //-1操作
                    begin
                        i <= 20;
                        go <= 14;
                        temp <= hour;
                    end
                    else if(rtc_config[0]) //循环操作
                    begin
                        i <= 15;
                        temp <= minute;
                    end
                    else
                        hour <= temp; //将作用结果反馈回hour寄存器
                end
                
                15:
                begin //config minute
                    if(!isConfig) //退出配置模式
                        i <= 4;
                    else if(rtc_config[2]) //+1操作
                    begin
                        i <= 17;
                        go <= 15;
                        temp <= minute;
                        comp <= 8'h59;
                    end
                    else if(rtc_config[1]) //-1操作
                    begin
                        i <= 20;
                        go <= 15;
                        temp <= minute;
                    end
                    else if(rtc_config[0]) //循环操作
                    begin
                        i <= 16;
                        temp <= second;
                    end
                    else
                        minute <= temp;
                end
                
                16:
                begin //config second
                    if(!isConfig) //退出配置模式
                        i <= 4;
                    else if(rtc_config[2]) //+1操作
                    begin
                        i <= 17;
                        go <= 16;
                        temp <= second;
                        comp <= 8'h59;
                    end
                    else if(rtc_config[1]) //-1操作
                    begin
                        i <= 20;
                        go <= 16;
                        temp <= second;
                    end
                    else if(rtc_config[0]) //循环操作
                    begin
                        i <= 14;
                        temp <= hour;
                    end
                    else
                        second <= temp;
                end
                
                17: //increase
                begin
                    if(temp < comp)
                    begin
                        temp <= temp + 1'b1;
                        i <= 18;
                    end
                    else
                    begin
                        hour <= temp;
                        i <= go;
                    end
                end
                
                18:
                begin
                    if(temp[3:0] > 4'd9)
                    begin
                        temp <= {temp[7:4]+1'b1, 4'd0};
                        i <= 19;
                    end
                    else
                        i <= 19;
                end
                
                19:
                begin
                    if(temp[7:4] > comp[7:4])
                    begin
                        temp <= comp;
                        i <= go;
                    end
                    else
                        i <= go;
                end
                
                20: //decrease
                begin
                    if(temp[3:0] > 0)
                    begin
                        temp[3:0] <= temp[3:0] - 1'b1;
                        i <= go;
                    end
                    else if(temp[3:0] == 0 & temp[7:4] > 0)
                    begin
                        temp <= {temp[7:4]-1'b1, 4'd9};
                        i <= go;
                    end
                    else
                    begin
                        temp <= 8'h00;
                        i <= go;
                    end
                end
                
            endcase
        end
    end
    
    
    assign rtc_time = {hour, minute, second};
    
    
endmodule


