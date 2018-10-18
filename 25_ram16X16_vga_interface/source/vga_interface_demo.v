//数据源:存由16幅图像的ROM,每张图像16words*16bit分辨率
//数据目的:VGA显示模块
//控制:每隔250ms写入1幅图像信息到VGA接口


module vga_interface_demo
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
    reg [3:0] image_index; //指示0~15幅图
    always @(posedge clk_vga or negedge rst_n)
    begin
        if(!rst_n)
        begin
            count <= 24'd0;
            image_index <= 4'd0;
        end
        else if(image_index == 4'd15)
            image_index <= 4'd0;
        else if(count == T250MS)
        begin
            count <= 24'd0;
            image_index <= image_index + 1'b1;
        end
        else
            count <= count + 1'b1;
    end
    
    
    reg [3:0] addr_index; //指示一幅图像地址变化
    
    always @(posedge clk_vga or negedge rst_n)
    begin
        if(!rst_n)
            addr_index <= 4'd0;
        else if(addr_index == 4'd15)
            addr_index <= 4'd0;
        else
            addr_index <= addr_index + 1'b1;
    end
    
    /*******************************************/
    
    reg isWrite;        //指示RAM写入
    reg [3:0]Ram_Addr;  //指RAM写入地址
    reg [6:0]Rom_Addr;  //指示RAM写入数据 -- 由ROM输出提供
    reg i;
    
    always @(posedge clk_vga or negedge rst_n)
    begin
        if(!rst_n)
        begin
            isWrite <= 1'b0;
            Ram_Addr <= 4'd0;
            Rom_Addr <= 7'd0;
            i <= 1'b0;
        end
        else begin
            case(i)
            
                0: //从ROM取得一幅图像数据写入RAM
                if(addr_index == 4'd15)
                    i <= 1;
                else
                begin
                    isWrite <= 1'b1;                            //往RAM写入数据
                    Ram_Addr <= addr_index;                     //写入RAM的地址 -- Ram_Addr(0~15)
                    // Ram_Addr <= Rom_Addr[3:0];                  //一样的!!!!
                    Rom_Addr <= addr_index + image_index << 4;  //写入的数据由ROM输出 -- Rom_Addr(0~15) + 16*(0~15)
                end
                
                1: //从RAM读取数据输出到VGA -- 每幅图像的停留时间250ms
                if(count == T250MS) //image_index也将发生变化
                    i <= 0;
                else
                    isWrite <= 1'b0;
            
            endcase
        end
    end
    
    
    assign write_en = isWrite;
    //rom_addr:0~95
    assign rom_addr = Rom_Addr;
    //ram_addr:0~15
    assign write_addr = Ram_Addr;
    //data
    assign write_data = rom_data;
    
    
endmodule


/*
流程:




*/
