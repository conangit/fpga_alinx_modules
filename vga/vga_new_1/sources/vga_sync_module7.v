
//vga_clk 148.5MHz

module vga_sync_module_1920_1080_60(
    vga_clk,
    rst_n,
    VSYNC_Sig,
    HSYNC_Sig,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig
    );
    
    input vga_clk;
    input rst_n;
    
    output VSYNC_Sig;
    output HSYNC_Sig;
    output Ready_Sig;
    
    output [11:0]Column_Addr_Sig;
    output [11:0]Row_Addr_Sig;
    
    parameter X1 = 12'd44;
    parameter X2 = 12'd148;
    parameter X3 = 12'd1920;
    parameter X4 = 12'd88;
    
    parameter Y1 = 12'd5;
    parameter Y2 = 12'd36;
    parameter Y3 = 12'd1080;
    parameter Y4 = 12'd4;
    
    parameter H_POINT = (X1 + X2 + X3 + X4);
    parameter V_POINT = (Y1 + Y2 + Y3 + Y4);
    
    
    //列像素
    reg [11:0]Count_H;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            Count_H <= 12'd0;
        else if(Count_H == H_POINT)
            Count_H <= 12'd0;
        else
            Count_H <= Count_H + 1'b1;
    end
    
    // 行像素
    reg [11:0]Count_V;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            Count_V <= 12'd0;
        else if (Count_V == V_POINT)
            Count_V <= 12'd0;
        else if (Count_H == H_POINT)
            Count_V <= Count_V + 1'b1;
    end
    
    // 有效区域
    parameter X_L = (X1 + X2);
    parameter X_H = (X1 + X2 + X3 + 1);
    
    parameter Y_L = (Y1 + Y2);
    parameter Y_H = (Y1 + Y2 + Y3 + 1);
    
    reg isReady;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            isReady <= 1'b0;
        else if ((X_L < Count_H && Count_H < X_H) && (Y_L < Count_V && Count_V < Y_H))
            isReady <= 1'b1;
        else
            isReady <= 1'b0;
    end
    
    assign HSYNC_Sig = (Count_H <= X1) ? 1'b0 : 1'b1;
    assign VSYNC_Sig = (Count_V <= Y1) ? 1'b0 : 1'b1;
    assign Ready_Sig = isReady;
    
    // 当前的x和y地址 从0开始
    assign Column_Addr_Sig = isReady ? Count_H - (X_L + 12'd1) : 11'd0;
    assign Row_Addr_Sig = isReady ? Count_V - (Y_L + 12'd1) : 11'd0;
    
endmodule

