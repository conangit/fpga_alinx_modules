/*
 * 照抄课件
 */

module vga_control_module_bak (
    CLK,
    RST_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig
    );
    
    input CLK;
    input RST_n;
    input Ready_Sig;
    input [10:0 ]Column_Addr_Sig;
    input [9:0] Row_Addr_Sig;
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    reg isRectangle;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            isRectangle <= 1'b0;
        else if (11'd0 < Column_Addr_Sig && Row_Addr_Sig < 10'd100)
            isRectangle <= 1'b1;
        else
            isRectangle <= 1'b0;
    end

    assign Red_Sig   = Ready_Sig && isRectangle ? 5'b1_1111 : 5'b0_0000;
    assign Green_Sig = Ready_Sig && isRectangle ? 6'b11_1111 : 6'b00_0000;
    assign Blue_Sig  = Ready_Sig && isRectangle ? 5'b1_1111 : 5'b0_0000;
    
endmodule

