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
    rom_addr,
    rom_data,
    Red_Sig,
    Green_Sig,
    Blue_Sig
    );
    
    input vga_clk;
    input rst_n;
    input Ready_Sig;
    input [11:0] Column_Addr_Sig;   //列
    input [11:0] Row_Addr_Sig;      //行
    
    output [5:0] rom_addr;
    input [63:0] rom_data;
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    /*********************************/
    
    reg [5:0] m;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            m <= 6'd0;
        end
        else if(Ready_Sig && Row_Addr_Sig < 64)
            m <= Row_Addr_Sig[5:0];
    end
    
    reg [5:0] n;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            n <= 6'd0;
        end
        else if(Ready_Sig && Column_Addr_Sig < 64)
            n <= Column_Addr_Sig[5:0];
    end
    
    
    assign rom_addr = m;
    
    assign Red_Sig   = Ready_Sig ? {5{rom_data[6'd63-n]}} : {5{1'b0}};
    assign Green_Sig = Ready_Sig ? {6{rom_data[6'd63-n]}} : {6{1'b0}};
    assign Blue_Sig  = Ready_Sig ? {5{rom_data[6'd63-n]}} : {5{1'b0}};
    
    
    //n=0取得第0行数据 m:0~63
    //n=0 m=0:第0行第0个像素 如该bit为1则点亮该bit(5R+6G+5B--白色)
    
    
endmodule

