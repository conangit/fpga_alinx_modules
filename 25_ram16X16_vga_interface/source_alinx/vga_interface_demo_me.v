//数据源:存由16幅图像的ROM,每张图像16words*16bit分辨率
//数据目的:VGA显示模块
//控制:每隔250ms写入1幅图像信息到VGA接口


module vga_interface_demo_me
(
    input sysclk,
    input rst_n,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0] Red_Sig,
    output [5:0] Green_Sig,
    output [4:0] Blue_Sig
);



    wire clk_vga;
    wire clk_locked;
    
    pll_ip pll
    (
        .CLK_IN1(sysclk),       //50M
        .CLK_OUT1(clk_vga),     //25.175M
        .RESET(~rst_n),
        .LOCKED(clk_locked)
    );
    
    
    wire [6:0]rom_addr; //0~95
    wire [15:0]rom_data;
    
    rom_ip rom
    (
        .clka(clk_vga),
        .addra(rom_addr),
        .douta(rom_data)
    );
    
    
    wire write_en;
    wire [3:0] write_addr;
    wire [15:0] write_data;
    
    vga_interface vga
    (
        .rst_n(rst_n),
        //VGA signal
        .vga_clk(clk_vga),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig),
        //display source
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data)
    );
    
    /*******************************************/
    
    //clk_vga 25MHz
    parameter T250MS = 24'd6_250_000;
    
    reg [23:0] count;
    reg isCount;
    
    always @(posedge clk_vga or negedge rst_n)
    begin
        if(!rst_n)
            count <= 24'd0;
        else if(count == T250MS)
            count <= 24'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 24'd0;
    end
    
    
    /*******************************************/
    
    reg isWrite;            //指示RAM写入
    reg [6:0] Rom_Addr;     //根据ROM地址输出数据到RAM
    reg [4:0] image_index;  //指示0~15幅图
    reg [4:0] addr_index;   //指示一幅图像地址变化
    reg [3:0] i;
    
    always @(posedge clk_vga or negedge rst_n)
    begin
        if(!rst_n)
        begin
            isWrite <= 1'b0;
            Rom_Addr <= 7'd0;
            image_index <= 5'd0;
            addr_index <= 5'd0;
            isCount <= 1'b0;
            i <= 4'd0;
        end
        else begin
            case(i)
            
                0: //从ROM取得一幅图像数据写入RAM
                if(addr_index == 5'd16)
                begin
                    isWrite <= 1'b0;
                    addr_index <= 5'd0;
                    i <= 1;
                end
                else
                begin
                    isWrite <= 1'b1;                            //往RAM写入数据
                    Rom_Addr <= addr_index + (image_index << 4);  //写入的数据由ROM输出 -- Rom_Addr(0~15) + 16*(0~15)
                    addr_index <= addr_index + 1'b1;
                end
                
                1: //从RAM读取数据输出到VGA -- 每幅图像的停留时间250ms
                if(count == T250MS) //image_index也将发生变化
                begin
                
                    i <= 2;
                    isCount <= 1'b0;
                    
                    if(image_index == 5'd16)
                        image_index <= 5'd0;
                    else
                        image_index <= image_index + 1'b1;
                        
                end
                else
                    isCount <= 1'b1;
                    
                2:
                    i <= 0;
            
            endcase
        end
    end
    
    
    assign write_en = isWrite;
    //rom_addr:0~95
    assign rom_addr = Rom_Addr;
    //ram_addr:0~15
    assign write_addr = Rom_Addr[3:0];
    //data
    assign write_data = rom_data;
    
    
endmodule


/*
流程:
（一） 写入第 0 副图像信息至 vga_interface.v ，延迟 250ms。
（二） 写入第 1 副图像信息至 vga_interface.v ，延迟 250ms。
（三） 写入第 2 副图像信息至 vga_interface.v ，延迟 250ms。
（四） 写入第 3 副图像信息至 vga_interface.v ，延迟 250ms。
（五） 写入第 4 副图像信息至 vga_interface.v ，延迟 250ms。
（六） 写入第 5 副图像信息至 vga_interface.v ，延迟 250ms。
（七） 重复执行步骤 1~6。
*/
