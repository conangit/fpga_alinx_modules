module ds_function
(
    input clk,
    input rst_n,
    
    input [1:0] func_start,
    output reg func_done,
    
    input [7:0] register_addr,
    input [7:0] write_data,
    output reg [7:0] read_data,
    
    output reg sclk,
    output reg ce,
    inout sio
);
    
    //datasheet: 2.0V-500K 5.0V-2M
    
    //使用1Mbit/s的速率进行读写
    // parameter T0P5US = 6'd25;
    
    //使用500Kbit/s的速率进行读写
    parameter T1US = 6'd50;
    
    reg [5:0] count;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            count <= 6'd0;
        else if(count == T1US)
            count <= 6'd0;
        else if(func_start[1] == 1'b1 | func_start[0] == 1'b1)
            count <= count + 1'b1;
        else
            count <= 6'd0;
    end
    
    
    /*******************************************************************/
    // 对sio为输入时 进行一定防抖处理
    reg sio_debounce;
    reg [3:0] sio_shift;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            sio_shift <= 4'b1111;
        else if(isOut == 1'b0)
            sio_shift <= {sio_shift[2:0], sio};
        else
            sio_shift <= 4'b1111;
    end
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            sio_debounce <= 1'b1;
        else if(isOut == 1'b0)
            begin
                if(&sio_shift[3:0] == 1'b1)
                    sio_debounce <= 1'b1;
                else if(|sio_shift[3:0] == 1'b0)
                    sio_debounce <= 1'b0;
            end
        else
            sio_debounce <= 1'b1;
    end
    
    
    /*******************************************************************/
    
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
            sclk <= 1'b0;
            ce <= 1'b0;
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
                        sclk <= 1'b0;
                        ce <= 1'b1;
                    end
                
                1: //write_data
                    begin
                        i <= 2;
                        go <= 19;
                        isOut <= 1'b1;
                        rData <= write_data;
                        sclk <= 1'b0;
                        ce <= 1'b1;
                    end
                    
                2,4,6,8,10,12,14,16:
                    if(count == T1US)
                        i <= i + 1;
                    else
                    begin
                        sclk <= 1'b0;
                        rSIO <= rData[(i-2)>>1]; //LSB
                    end
                    
                3,5,7,9,11,13,15,17:
                    if(count == T1US)
                        i <= i + 1'b1;
                    else
                        sclk <= 1'b1;
                
                18:
                    begin
                        i <= go;
                    end
                    
                19:
                    begin
                        ce <= 1'b0;
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
                        sclk <= 1'b0;
                        ce <= 1'b1;
                    end
                    
                1,3,5,7,9,11,13,15:
                    if(count == T1US)
                        i <= i + 1;
                    else
                    begin
                        sclk <= 1'b0;
                        rSIO <= rData[(i-1)>>1]; //LSB
                    end
                    
                2,4,6,8,10,12,14,16:
                    if(count == T1US)
                        i <= i + 1;
                    else
                        sclk <= 1'b1;
                        
                17:
                    begin
                        i <= 18;
                        isOut <= 1'b0;
                    end
                
                //按照时序图,写完后的一个下降沿开始输出数据(当然由于SCLK是FPGA产生,你可以稍微延时几个时钟,再拉低SCLK;也可以立马拉低SCLK读取数据)
                //写法一
                18,20,22,24,26,28,30,32:
                    if(count == T1US)
                        i <= i + 1;
                    else
                    begin
                        sclk <= 1'b0; //拉低时钟读取数据
                        // read_data[(i-18)>>1] <= sio; //LSB
                        read_data[(i-18)>>1] <= sio_debounce;
                    end
                    
                19,21,23,25,27,29,31,33:
                    if(count == T1US)
                        i <= i + 1;
                    else
                        sclk <= 1'b1;
                
                /*
                //写法二
                18,20,22,24,26,28,30,32:
                    if(count == T1US)
                        i <= i + 1;
                    else
                        sclk <= 1'b1;
                        
                19,21,23,25,27,29,31,33:
                    if(count == T1US)
                        i <= i + 1;
                    else
                    begin
                        sclk <= 1'b0; //拉低时钟读取数据
                        read_data[(i-19)>>1] <= sio; //LSB
                    end
                 */
                 
                34:
                    begin
                        ce <= 1'b0;
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
    
    
    assign sio = isOut ? rSIO : 1'bz;
    
    
    
endmodule

