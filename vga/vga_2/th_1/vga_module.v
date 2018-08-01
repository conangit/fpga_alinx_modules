

module vag_module (
    CLK, RST_n,
    VSYNC_Sig, HSYNC_Sig,
    Red_Sig, Green_Sig, Blue_Sig
    );
    
    input CLK;
    input RST_n;
    
    output HSYNC_Sig;           //列同步信号
    output VSYNC_Sig;           //行同步信号
    output [4:0] Red_Sig;       //R
    output [5:0] Green_Sig;     //G
    output [4:0] Blue_Sig;      //B
    
    wire CLK_25MHz;
    
    pll_module U1
    (
        .clk_in(CLK),
        .RST_n(RST_n),
        .clk_out(CLK_25MHz)
    );
    
    wire Ready_Sig;
    // 当然这里也可以取 Soc能支持的最大分辨率下的 x,y极限值，以保持兼容
    wire [10:0] x_Addr; //0~639
    wire [10:0] y_Addr; //0~479
    
    // 显示标准模块
    sync_module U2(
        .CLK(CLK_25MHz),
        .RST_n(RST_n),
        .HSYNC_Sig(HSYNC_Sig),
        .VSYNC_Sig(VSYNC_Sig),
        .Ready_Sig(Ready_Sig),
        .Column_Addr_Sig(x_Addr),   //列
        .Row_Addr_Sig(y_Addr)       //行
    );
    
    // 图像显示控制
    vga_control_module U3(
        .CLK(CLK_25MHz),
        .RST_n(RST_n),
        .Ready_Sig(Ready_Sig), 
        .Column_Addr_Sig(x_Addr),
        .Row_Addr_Sig(y_Addr),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    
    
endmodule

