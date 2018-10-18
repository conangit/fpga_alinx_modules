`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:29 08/11/2018 
// Design Name: 
// Module Name:    vga_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_interface
(
    input rst_n,
    
    //VGA signal
    input vga_clk,      //need 25.175MHz
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0] Red_Sig,
    output [5:0] Green_Sig,
    output [4:0] Blue_Sig,
    
    //display source
    input write_en,
    input [3:0] write_addr,
    input [15:0] write_data
);
    
    
    wire isReady;
    wire [11:0] x_addr;
    wire [11:0] y_addr;
    wire frame_sig;
    
    wire [6:0] rom_addr;
    wire [15:0] rom_data;
    
    
    vga_sync_module_640_480_60 u2(
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .Ready_Sig(isReady),
        .HSYNC_Sig(HSYNC_Sig),
        .VSYNC_Sig(VSYNC_Sig),
        .Frame_Sig(frame_sig),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr)
    );
    
    
    ram16X16 u3
    (
        .clk(vga_clk),
        .rst_n(rst_n),
        .write_en(write_en),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr(ram_addr),
        .read_data(ram_data)
    );
    
    
    vga_control_module u4
    (
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .Ready_Sig(isReady),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr),
        .Frame_Sig(frame_sig),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig),
        .ram_addr(ram_addr),
        .ram_data(ram_data)
    );
    
    
endmodule

