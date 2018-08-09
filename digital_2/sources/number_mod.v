`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:58:29 06/24/2018 
// Design Name: 
// Module Name:    number_mod 
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
module number_mod(
    CLK,
    RST_n,
    data_in,
    ten_data,
    one_data
    );
    
    input  CLK;
    input  RST_n;
    input  [7:0] data_in;
    output [3:0] ten_data;
    output [3:0] one_data;
    
    //综合软件 默认情况下 "除法器" 和 "求余器" 都是32位输出
    reg [31:0] rTen;
    reg [31:0] rOne;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            rTen <= 32'd0;
            rOne <= 32'd0;
        end
        else begin
            rTen <= data_in / 10;
            rOne <= data_in % 10;
        end
    end
    

    assign ten_data = rTen[3:0];
    assign one_data = rOne[3:0];
    
endmodule
