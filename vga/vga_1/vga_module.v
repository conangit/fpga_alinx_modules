

module vag_module (
    CLK, RST_n,
    VSYNC_Sig, HSYNC_Sig,
    Red_Sig, Green_Sig, Blue_Sig
    );
    
    input CLK;
    input RST_n;
    
    output VSYNC_Sig;
    output HSYNC_Sig;
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    wire CLK_40MHz;
    
    pll_module U1
    (
        .clk_in(CLK),
        .RST_n(RST_n),
        .clk_out(CLK_40MHz)
    );
    
    wire Ready_Sig;
    wire [10:0] Column_Addr_Sig;
    wire [9:0] Row_Addr_Sig;
    
    /*
    sync_module_bak U2(
        .CLK(CLK_40MHz),
        .RST_n(RST_n),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(Ready_Sig),
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig)
    );
    
    vga_control_module_bak U3(
        .CLK(CLK_40MHz),
        .RST_n(RST_n),
        .Ready_Sig(Ready_Sig), 
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    */
    
    
    sync_module U2(
        .CLK(CLK_40MHz),
        .RST_n(RST_n),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(Ready_Sig),
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig)
    );
    
    vga_control_module U3(
        .CLK(CLK_40MHz),
        .RST_n(RST_n),
        .Ready_Sig(Ready_Sig), 
        .Column_Addr_Sig(Column_Addr_Sig),
        .Row_Addr_Sig(Row_Addr_Sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    
    
endmodule

