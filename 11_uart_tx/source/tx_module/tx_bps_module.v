`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:23 08/02/2018 
// Design Name: 
// Module Name:    tx_bps_module 
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
module tx_bps_module
#(parameter BPS = 13'd434)
(
    CLK,
    RST_n,
    Count_Sig,
    BPS_CLK
);
    
    input CLK;
    input RST_n;
    
    input Count_Sig;
    output BPS_CLK;
    
    reg [12:0]Count_BPS;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            Count_BPS <= 13'd0;
        else if (Count_BPS == BPS)
            Count_BPS <= 13'd0;
        else if (Count_Sig)
            Count_BPS <= Count_BPS + 1'b1;
        else
            Count_BPS <= 13'd0;
    end
    
    assign BPS_CLK = (Count_BPS == (BPS>>1)) ? 1'b1: 1'b0;

endmodule
