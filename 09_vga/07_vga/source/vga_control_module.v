

module vga_control_module(
    vga_clk,
    rst_n,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig,
    Frame_Sig,
    Red_Sig,
    Green_Sig,
    Blue_Sig,
    rom_addr,
    rom_data
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
    
    output [6:0] rom_addr;
    input [15:0] rom_data;

    
    /*********************************/
    
    reg [4:0] y;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            y <= 5'd0;
        end
        else if(Ready_Sig && Row_Addr_Sig < 16)
            y <= Row_Addr_Sig[4:0];
        else
            y <= 5'd0;
    end
    
    reg [4:0] x;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            x <= 5'd0;
        end
        else if(Ready_Sig && Column_Addr_Sig < 16)
            x <= Column_Addr_Sig[4:0];
        else
            x <= 5'd0;
    end
    
    /*********************************/
    
    parameter FRAME = 6'd60;
    
    reg [5:0]frame_cnt;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n)
            frame_cnt <= 6'd0;
        else if(frame_cnt == FRAME)
            frame_cnt <= 6'd0;
        else if(Frame_Sig)
            frame_cnt <= frame_cnt + 1'b1;
    end
    
    /*********************************/
    
    reg [3:0] i;
    reg [6:0] rADDR;
    
    always @(posedge vga_clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 4'd0;
            rADDR <= 7'd0;
        end
        else
            case(i)
            
                0:
                if(frame_cnt == FRAME)
                    i <= 1;
                else
                    rADDR <= 7'd0;
                
                1:
                if(frame_cnt == FRAME)
                    i <= 2;
                else
                    rADDR <= 7'd16;
                
                2:
                if(frame_cnt == FRAME)
                    i <= 3;
                else
                    rADDR <= 7'd32;
                
                3:
                if(frame_cnt == FRAME)
                    i <= 4;
                else
                    rADDR <= 7'd48;
                
                4:
                if(frame_cnt == FRAME)
                    i <= 5;
                else
                    rADDR <= 7'd64;
                
                5:
                if(frame_cnt == FRAME)
                    i <= 0;
                else
                    rADDR <= 7'd80;
                    
            endcase
    end
    
    
    assign rom_addr = y + rADDR;
    
    //ROM存储的信息高位在前
    assign Red_Sig   = Ready_Sig ? {5{rom_data[5'd15-x]}} : {5{1'b0}};
    assign Green_Sig = Ready_Sig ? {6{rom_data[5'd15-x]}} : {6{1'b0}};
    assign Blue_Sig  = Ready_Sig ? {5{rom_data[5'd15-x]}} : {5{1'b0}};
    
    
    
endmodule

