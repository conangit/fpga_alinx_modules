//数据源:存有6幅16words*16bit信息的ROM
//数据目的:VGA显示模块
//控制:每隔250ms写入1幅图像信息到VGA接口


module vga_interface_demo
(
    input sysclk,
    input rst_n
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
    wire [15:0] write_data
    
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
    
    
    
    
endmodule

