module vga_interface
(
     input RSTn,
     
     input Write_En_Sig,
     input [3:0]Write_Addr_Sig,
     input [15:0]Write_Data,
     
     input VGA_CLK,  // 40MHz
     output VSYNC_Sig,
     output HSYNC_Sig,
     output Red_Sig,
     output Green_Sig,
     output Blue_Sig
         
);

     /******************************************/
     
    wire Ready_Sig;
     wire [10:0]Column_Addr_Sig;
     wire [10:0]Row_Addr_Sig; 

     sync_module U1
     (
         .CLK( VGA_CLK ),            // input - from top
          .RSTn( RSTn ),                        
          .VSYNC_Sig( VSYNC_Sig ),    // output - to top
          .HSYNC_Sig( HSYNC_Sig ),    // output - to top
          .Ready_Sig( Ready_Sig ),    // output - to U2
          .Column_Addr_Sig( Column_Addr_Sig ), // output - to U2
         .Row_Addr_Sig( Row_Addr_Sig )  // output - to U2
     );
     
     /*********************************************/
     
     wire [3:0]Read_Addr_Sig;
     wire [15:0]Read_Data;
     
     vga_control_module U2
     (
         .CLK( VGA_CLK ),    // input - from top
          .RSTn( RSTn ),
          .Ready_Sig( Ready_Sig ),  // input - from U1
          .Column_Addr_Sig( Column_Addr_Sig ), // input - from U1
          .Row_Addr_Sig( Row_Addr_Sig ),       // input - from U1
          .Ram_Data( Read_Data ),              // output - to U3
          .Ram_Addr( Read_Addr_Sig ),          // output - to U3 
          .Red_Sig( Red_Sig ),                 // output - top
          .Green_Sig( Green_Sig ),             // output - top 
          .Blue_Sig( Blue_Sig )                // output - top
     );
     
     /*********************************************/
     
     
    ram16X16 ram
    (
        .clk(VGA_CLK),
        .rst_n(~RSTn),
        .write_en(Write_En_Sig),
        .write_addr(Write_Addr_Sig),
        .write_data(Write_Data),
        .read_addr(Read_Addr_Sig),
        .read_data(Read_Data)
    );
    
    
    /*********************************************/
     
endmodule
