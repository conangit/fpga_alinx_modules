

module vag_module (
    CLK,
    RST_n,
    VSYNC_Sig,
    HSYNC_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig
    );
    
    input CLK;
    input RST_n;
    
    output VSYNC_Sig;
    output HSYNC_Sig;
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    /*******************************/
    
    wire CLK_40MHz;
    
    pll_ip u1
    (
        .CLK_IN1(CLK),          //50MHz
        .CLK_OUT1(CLK_40MHz),
        .RESET(!RST_n)
        // .RESET(!reset_in) //pll_ip本身由50MHz时钟驱动 而同步释放却要求与40MHz边沿对齐
    );
    
    //pll_ip模块身份因处于(同步释放、同步扫面、VGA控制这几个模块的)"顶层"模块
    //也即pll_ip的输出时钟,应作为这三个模块的"系统(接口)"时钟
    //带有异步复位的模块(接口)--异步复位应该是该接口的内部的一部分,而不是整个系统的顶层,故驱动时钟也和接口内部的其他模块同等地位
    
    
    //u1是u2 u3 u4的顶层
    wire reset_in;
    
    async_reset u2
    (
        .clk(CLK_40MHz), //CLK为什么会不允许?
        .rst_n(RST_n), //这里可以使用系统顶层的复位(异步的)
        .rst_n_out(reset_in)
    );
    
    wire Ready_Sig;
    wire [10:0] Column_Addr_Sig;
    wire [9:0] Row_Addr_Sig;
    
    
    sync_module u3(
        .CLK(CLK_40MHz),
        .RST_n(reset_in),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(Ready_Sig),
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig)
    );
    
    vga_control_module u4(
        .CLK(CLK_40MHz),
        .RST_n(reset_in),
        .Ready_Sig(Ready_Sig), 
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    
    
    
endmodule

