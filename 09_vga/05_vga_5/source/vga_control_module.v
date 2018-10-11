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
    
    output [6:0] rom_addr;
    input [79:0] rom_data;
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    /*********************************/
    
    reg [6:0] y;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            y <= 7'd0;
        end
        else if(Ready_Sig && Row_Addr_Sig < 86)
            y <= Row_Addr_Sig[6:0];
    end
    
    reg [6:0] x;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            x <= 7'd0;
        end
        else if(Ready_Sig && Column_Addr_Sig < 80)
            x <= Column_Addr_Sig[6:0];
    end
    
    
    assign rom_addr = y;
    
    assign Red_Sig   = Ready_Sig ? ~{5{rom_data[x]}} : {5{1'b0}};
    assign Green_Sig = Ready_Sig ? ~{6{rom_data[x]}} : {6{1'b0}};
    assign Blue_Sig  = Ready_Sig ? ~{5{rom_data[x]}} : {5{1'b0}};
    
    
    //n=0取得第0行数据 m:0~63
    //n=0 m=0:第0行第0个像素 如该bit为1则点亮该bit(5R+6G+5B--白色)
    
    
endmodule

