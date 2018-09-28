`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:33:47 06/24/2018 
// Design Name: 
// Module Name:    inter_control_module 
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
module inter_control_module(
    CLK,
    RST_n,
    Trig_Sig,
    SOS_En_Sig
    );
    
    input CLK;
    input RST_n;
    input Trig_Sig;
    output reg SOS_En_Sig;

    /*
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            SOS_En_Sig <= 1'b0;
        end
        else if (Trig_Sig) begin
            SOS_En_Sig <= 1'b1;
        end
        else begin
            SOS_En_Sig <= 1'b0;
        end
    end
    */
    
    reg i;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            SOS_En_Sig <= 1'b0;
            i <= 1'b0;
        end
        else begin
            case (i)
            1'b0:
            begin
                if (Trig_Sig) begin
                    SOS_En_Sig <= 1'b1;
                    i <= 1'b1;
                end
            end
            
            1'b1:
            begin
                SOS_En_Sig <= 1'b0;
                i <= 1'b0;
            end
            endcase
        end
    end
    
endmodule
