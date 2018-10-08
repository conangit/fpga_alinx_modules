
//vga_clk 40.0MHz
//按照VGA时序标准 VGA的时钟应为40MHz
//但假设200MHz的时钟向下兼容呢?
//要点:VGA的核心--像素时钟

module vga_sync_module_800_600_60(
    vga_clk, //200MHz 非40MHz
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
    output [10:0]Column_Addr_Sig;
    output [10:0]Row_Addr_Sig;
    
    /******************************************/
    
    parameter X1 = 11'd128;
    parameter X2 = 11'd88;
    parameter X3 = 11'd800;
    parameter X4 = 11'd40;
    
    parameter Y1 = 11'd4;
    parameter Y2 = 11'd23;
    parameter Y3 = 11'd600;
    parameter Y4 = 11'd1;
    
    parameter H_POINT = (X1 + X2 + X3 + X4);
    parameter V_POINT = (Y1 + Y2 + Y3 + Y4);
    
    /******************************************/
    
    //40MHz = 25ns
    //50MHz计时25ns
    //parameter T25NS = ?尴尬了50MHz(20ns)无法准确取到25ns!!!!
    //故50MHz"无法向下兼容到40MHz"
    
    //为实现50MHz向下兼容40MHz:需要先将50MHz倍频到200MHz(50和40的公倍数),才能兼容到40MHz
    //难道这是PLL实现的原理?
    
    //40MHz = 25ns
    //200Mhz = 5ns
    parameter T25NS = 3'd5;
    
    reg [2:0]count;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if(count == T25NS)
            count <= 3'd0;
        else
            count <= count + 1'b1;
    end
    
    
    //列像素
    reg [10:0]Count_H;
    
    /*
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            Count_H <= 11'd0;
        else if(Count_H == H_POINT)
            Count_H <= 11'd0;
        else
            Count_H <= Count_H + 1'b1;
    end
    */
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            Count_H <= 11'd0;
        else if(Count_H == H_POINT)
            Count_H <= 11'd0;
        else if(count == T25NS)
            Count_H <= Count_H + 1'b1;
    end
    
    
    //行像素
    reg [10:0]Count_V;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if (!rst_n)
            Count_V <= 11'd0;
        else if (Count_V == V_POINT)
            Count_V <= 11'd0;
        else if (Count_H == H_POINT)
            Count_V <= Count_V + 1'b1;
    end
    
    //有效区域
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
    assign Column_Addr_Sig = isReady ? Count_H - (X_L + 11'd1) : 11'd0;
    assign Row_Addr_Sig = isReady ? Count_V - (Y_L + 11'd1) : 11'd0;
    
endmodule

