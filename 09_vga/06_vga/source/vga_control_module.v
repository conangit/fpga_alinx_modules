/*
0：64bit
1：64bit
...
...
63：64bit
*/

module vga_control_module(
    vga_clk,
    rst_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig,
    rom_addr,
    red_rom_data,
    green_rom_data,
    blue_rom_data
    );
    
    input vga_clk;
    input rst_n;
    
    input Ready_Sig;
    input [11:0] Column_Addr_Sig;   //水平同步信号
    input [11:0] Row_Addr_Sig;      //垂直同步信号
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    output [5:0] rom_addr;
    input [63:0] red_rom_data;
    input [63:0] green_rom_data;
    input [63:0] blue_rom_data;
    
    /*********************************/
    
    reg [5:0] y;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            y <= 6'd0;
        end
        else if(Ready_Sig && Row_Addr_Sig < 64)
            y <= Row_Addr_Sig[5:0];
    end
    
    reg [5:0] x;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            x <= 6'd0;
        end
        else if(Ready_Sig && Column_Addr_Sig < 64)
            x <= Column_Addr_Sig[5:0];
    end
    
    
    assign rom_addr = y;
    
    //ROM存储的信息高位在前
    assign Red_Sig   = Ready_Sig ? {5{red_rom_data[6'd63-x]}} : {5{1'b0}};
    assign Green_Sig = Ready_Sig ? {6{green_rom_data[6'd63-x]}} : {6{1'b0}};
    assign Blue_Sig  = Ready_Sig ? {5{blue_rom_data[6'd63-x]}} : {5{1'b0}};
    
    
    //y=0取得第0行数据 x:0~63
    //y=0,x=0:第0行第0个像素:如该bit对应颜色的图层为1则混合该颜色,如该bit为0则表示不需要该种颜色来混合
    
    
endmodule

