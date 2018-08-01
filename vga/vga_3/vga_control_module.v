

module vga_control_module (
    CLK,
    RST_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Rom_Data,
    Rom_Addr,
    Red_Sig,
    Green_Sig,
    Blue_Sig
    );
    
    input CLK;
    input RST_n;
    input Ready_Sig;
    input [10:0] Column_Addr_Sig;
    input [10:0] Row_Addr_Sig;
    
    input [63:0] Rom_Data;
    output [5:0] Rom_Addr;
    
    output [4:0] Red_Sig;
    output [5:0] Green_Sig;
    output [4:0] Blue_Sig;
    
    // 当前y地址 即当前的行
    reg [5:0] m;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            m <= 6'd0;
        else if(Ready_Sig && Row_Addr_Sig <64)
            m <= Row_Addr_Sig[5:0];
    end
    
    // 当前x地址 即当前的列
    reg [5:0] n;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            n <= 6'd0;
        else if(Ready_Sig && Column_Addr_Sig < 64)
            n <= Column_Addr_Sig[5:0];
    end
    
    assign Rom_Addr = m;
    
    assign Red_Sig   = Ready_Sig ? 5{Rom_Data[6'd63-n]} : 5{1'b0};
    assign Green_Sig = Ready_Sig ? 6{Rom_Data[6'd63-n]} : 6{1'b0};
    assign Blue_Sig  = Ready_Sig ? 5{Rom_Data[6'd63-n]} : 5{1'b0};
    
    
endmodule

