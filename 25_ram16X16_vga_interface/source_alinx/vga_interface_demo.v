module vga_interface_demo
(
    input CLK,
    input RSTn,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0]Red_Sig,
    output [5:0]Green_Sig,
    output [4:0]Blue_Sig

);

    /****************************/
     
     wire CLK_40Mhz;
     
    pll_ip pll
    (
        .CLK_IN1(CLK),
        .CLK_OUT1(CLK_40Mhz),
        .RESET(~RSTn)
    );
    
    
     /*****************************/
    
     parameter T1MS = 16'd39999;

     /*****************************/
     
     reg [15:0]C1;
     
     always @ ( posedge CLK_40Mhz    or negedge RSTn )
         if( !RSTn )
              C1 <= 15'd0;
          else if( C1 == T1MS )
              C1 <= 15'd0;
          else if( isCount )
              C1 <= C1 + 1'b1;
          else 
              C1 <= 15'd0;
                
     /*****************************/
     
     reg [9:0]CMS;
     
     always @ ( posedge CLK_40Mhz or negedge RSTn )
         if( !RSTn )
              CMS <= 10'd0;
          else if( CMS == rTimes )
              CMS <= 10'd0;
          else if( C1 == T1MS )
              CMS <= CMS + 1'b1;
     
     /*****************************/
     
     reg [6:0]Y;
     
     always @ ( posedge CLK_40Mhz or negedge RSTn )
         if( !RSTn )
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
     
     always @ ( posedge CLK_40Mhz or negedge RSTn )
         if( !RSTn )
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
     
     
     wire [15:0]Rom_Data;
     
    rom_ip your_instance_name (
        .clka(CLK_40Mhz), // input clka
        .addra(rAddr), // input [6 : 0] addra
        .douta(Rom_Data) // output [15 : 0] douta
    );
    
    /*****************************/
    
    wire red_sig;
    wire green_sig;
    wire blue_sig;
    
    assign Red_Sig = {5{red_sig}};
    assign Green_Sig = {6{green_sig}};
    assign Blue_Sig = {5{blue_sig}};
    
    
    vga_interface U3
    (
        .RSTn( RSTn ),
        .Write_En_Sig( isWrite ),
        .Write_Addr_Sig( rAddr[3:0] ),
        .Write_Data( Rom_Data ),
        .VGA_CLK( CLK_40Mhz ),
        .VSYNC_Sig( VSYNC_Sig ),
        .HSYNC_Sig( HSYNC_Sig ),
        .Red_Sig( red_sig ),
        .Green_Sig( green_sig ),
        .Blue_Sig( blue_sig )
    );
     
     /*****************************/

endmodule
