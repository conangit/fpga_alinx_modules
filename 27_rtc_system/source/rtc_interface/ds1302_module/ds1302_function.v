module ds1302_function
(
    input clk,
    input rst_n,
    
    input [1:0] func_start,
    output reg func_done,
    
    input [7:0] register_addr,
    input [7:0] write_data,
    output reg [7:0] read_data,
    
    output reg rtc_sclk,
    output reg rtc_rst,
    inout rtc_sio
);
    
    
    //使用1Mbit/s的速率进行读写
    //datasheet 2.0V:500Kbit/s 5.0V:2Mbit/s
    parameter T0P5US = 5'd24;
    
    reg [4:0] count;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            count <= 5'd0;
        else if(count == T0P5US)
            count <= 5'd0;
        else if(func_start[1] == 1'b1 | func_start[0] == 1'b1)
            count <= count + 1'b1;
        else
            count <= 5'd0;
    end
    
    reg [5:0] i;
    reg [5:0] go;
    reg isOut;
    reg rSIO;
    reg [7:0] rData;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 6'd0;
            go <= 6'd0;
            isOut <= 1'b1;
            rSIO <= 1'b0;
            rData <= 8'd0;
            func_done <= 1'b0;
            read_data <= 8'd0;
            rtc_sclk <= 1'b0;
            rtc_rst <= 1'b0;
        end
        else if(func_start[1]) //write
        begin
            case(i)
                0: //write_addr
                    begin
                        i <= 2;
                        go <= i + 1;
                        isOut <= 1'b1;
                        rData <= register_addr;
                        rtc_sclk <= 1'b0;
                        rtc_rst <= 1'b1;
                    end
                
                1: //write_data
                    begin
                        i <= 2;
                        go <= 19;
                        isOut <= 1'b1;
                        rData <= write_data;
                        rtc_sclk <= 1'b0;
                        rtc_rst <= 1'b1;
                    end
                    
                2,4,6,8,10,12,14,16:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                    begin
                        rtc_sclk <= 1'b0;
                        rSIO <= rData[(i-2)>>1]; //LSB
                    end
                    
                3,5,7,9,11,13,15,17:
                    if(count == T0P5US)
                        i <= i + 1'b1;
                    else
                        rtc_sclk <= 1'b1;
                
                18:
                    begin
                        i <= go;
                    end
                    
                19:
                    begin
                        rtc_rst <= 1'b0;
                        i <= 20;
                    end
                
                20:
                    begin
                        func_done <= 1'b1;
                        i <= 21;
                    end
                    
                21:
                    begin
                        func_done <= 1'b0;
                        i <= 0;
                    end
                    
                default: i <= 0;
            endcase
        end
        else if(func_start[0]) //read
        begin
            case(i)
                0:
                    begin
                        i <= 1;
                        isOut <= 1'b1;
                        rData <= register_addr;
                        rtc_sclk <= 1'b0;
                        rtc_rst <= 1'b1;
                    end
                    
                1,3,5,7,9,11,13,15:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                    begin
                        rtc_sclk <= 1'b0;
                        rSIO <= rData[(i-1)>>1]; //LSB
                    end
                    
                2,4,6,8,10,12,14,16:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                        rtc_sclk <= 1'b1;
                        
                17:
                    begin
                        i <= 18;
                        isOut <= 1'b0;
                    end
                
                //按照时序图,写完后的一个下降沿开始输出数据(当然由于SCLK是FPGA产生,你可以稍微延时几个时钟,再拉低SCLK;也可以立马拉低SCLK读取数据)
                //写法一
                18,20,22,24,26,28,30,32:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                    begin
                        rtc_sclk <= 1'b0; //拉低时钟读取数据
                        read_data[(i-18)>>1] <= rtc_sio; //LSB
                    end
                    
                19,21,23,25,27,29,31,33:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                        rtc_sclk <= 1'b1;
                
                /*
                //写法二
                18,20,22,24,26,28,30,32:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                        rtc_sclk <= 1'b1;
                        
                19,21,23,25,27,29,31,33:
                    if(count == T0P5US)
                        i <= i + 1;
                    else
                    begin
                        rtc_sclk <= 1'b0; //拉低时钟读取数据
                        read_data[(i-19)>>1] <= rtc_sio; //LSB
                    end
                 */
                 
                34:
                    begin
                        rtc_rst <= 1'b0;
                        i <= 35;
                    end
                    
                35:
                    begin
                        func_done <= 1'b1;
                        i <= 36;
                    end
                    
                36:
                    begin
                        func_done <= 1'b0;
                        i <= 0;
                    end
                    
                default: i <= 0;
            endcase
        end
    end
    
    
    assign rtc_sio = isOut ? rSIO : 1'bz;
    
    
endmodule

