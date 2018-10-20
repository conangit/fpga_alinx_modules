module vga_interface_demo_alinx
(
    input sysclk,
    input rst_n,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0] Red_Sig,
    output [5:0] Green_Sig,
    output [4:0] Blue_Sig
);

    /****************************/
     
    wire clk_vga;
    wire clk_locked;
    
    pll_ip pll
    (
        .CLK_IN1(sysclk),       //50M
        .CLK_OUT1(clk_vga),     //25.175M
        .RESET(~rst_n),
        .LOCKED(clk_locked)
    );
     
     /*****************************/
    
     parameter T1MS = 16'd24_999;

     /*****************************/
     
     reg [15:0]C1;
     
     always @ ( posedge clk_vga    or negedge rst_n )
         if( !rst_n )
              C1 <= 15'd0;
          else if( C1 == T1MS )
              C1 <= 15'd0;
          else if( isCount )
              C1 <= C1 + 1'b1;
          else 
              C1 <= 15'd0;
                
     /*****************************/
     
     reg [9:0]CMS;
     
     always @ ( posedge clk_vga or negedge rst_n )
         if( !rst_n )
              CMS <= 10'd0;
          else if( CMS == rTimes )
              CMS <= 10'd0;
          else if( C1 == T1MS )
              CMS <= CMS + 1'b1;
     
     /*****************************/
     
     reg [6:0]Y;
     
     always @ ( posedge clk_vga or negedge rst_n )
         if( !rst_n )
              Y <= 7'd0;
          else 
              case( i )
                
                    0 : Y <= 7'd0;
                     2 : Y <= 7'd16;
                     4 : Y <= 7'd32;
                     6 : Y <= 7'd48;
                     8 : Y <= 7'd64;
                     10: Y <= 7'd80;
                
                endcase
                
     /*****************************/
      
     reg [3:0]i;
     reg [6:0]rAddr;
     reg [4:0]X;
     reg isWrite;
     reg isCount;
     reg [9:0]rTimes;
     
     always @ ( posedge clk_vga or negedge rst_n )
         if( !rst_n )
              begin
                    i <= 4'd0;
                     rAddr <= 7'd0;
                     X <= 5'd0;
                     isWrite <= 1'b0;
                     isCount <= 1'b0;
                     rTimes <= 10'd100;
                end
          else
              case ( i )
                    
                    0, 2, 4, 6, 8, 10: 
                     if( X == 16 ) begin rAddr <= 7'd0; X <= 5'd0; isWrite <= 1'b0; i <= i + 1'b1; end
                     else begin rAddr <= Y + X; X <= X + 1'b1; isWrite <= 1'b1;end
                     
                1, 3, 5, 7, 9, 11:
                     if( CMS == rTimes ) begin isCount <= 1'b0; i <= i + 1'b1; end
                     else begin rTimes <= 10'd250; isCount <= 1'b1; end
                     
                12:
                     i <= 4'd0;
                     
                endcase
     
     /*****************************/
     
     
    rom_ip rom
    (
        .clka(clk_vga),
        .addra(rAddr),
        .douta(Rom_Data)
    );
     
    
     /*****************************/
     
     
    vga_interface vga
    (
        .rst_n(rst_n),
        //VGA signal
        .vga_clk(clk_vga),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig),
        //display source
        .write_en(isWrite),
        .write_addr(rAddr[3:0]),
        .write_data(Rom_Data)
    );
     
     
     /*****************************/

endmodule
