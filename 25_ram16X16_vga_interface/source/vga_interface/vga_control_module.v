

module vga_control_module
(
    vga_clk,
    rst_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Frame_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig,
    ram_addr,
    ram_data
);
    
    input vga_clk;
    input rst_n;
    
    input Ready_Sig;
    input Frame_Sig;
    input [11:0] Column_Addr_Sig;   //水平同步信号
    input [11:0] Row_Addr_Sig;      //垂直同步信号
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    output [3:0] ram_addr;
    input [15:0] ram_data;
    
    /*********************************/
    
    reg [3:0] y;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            y <= 4'd0;
        end
        else if(Ready_Sig && Row_Addr_Sig < 16)
            y <= Row_Addr_Sig[3:0];
        else
            y <= 4'd0;
    end
    
    
    reg [3:0] x;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            x <= 4'd0;
        end
        else if(Ready_Sig && Column_Addr_Sig < 16)
            x <= Column_Addr_Sig[3:0];
        else
            x <= 4'd0;
    end
    
    
    //显示区域
    reg isImage;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            isImage <= 1'd0;
        end
        else if(Row_Addr_Sig >= 0 && Row_Addr_Sig <= 15 && Column_Addr_Sig >= 0 && Column_Addr_Sig <= 15)
            isImage <= 1'd1;
        else
            isImage <= 1'd0;
    end
    
    /*********************************/
    
    assign ram_addr = y;
    
    //对RAM写入时,RAM存储的信息高位在前
    assign Red_Sig   = Ready_Sig && isImage ? {5{ram_data[4'd15-x]}} : {5{1'b0}};
    assign Green_Sig = Ready_Sig && isImage ? {6{ram_data[4'd15-x]}} : {6{1'b0}};
    assign Blue_Sig  = Ready_Sig && isImage ? {5{ram_data[4'd15-x]}} : {5{1'b0}};
    
    
endmodule

