`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:20:25 08/09/2018 
// Design Name: 
// Module Name:    demo_control_module 
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
module demo_control_module(
    CLK,
    RSTn,
    number_sig
    );
    
    input CLK;
    input RSTn;
    output [23:0]number_sig;
    
    localparam T1S = 26'd49_999_999;
    reg [25:0]count_s;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count_s <= 26'd0;
        else if(count_s == T1S)
            count_s <= 26'd0;
        else
            count_s <= count_s + 1'b1;
    end
    
    
    reg [23:0] rNum;
    
    // 显示123456
    /*
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            rNum <= 24'd0;
        else
            rNum <= 24'h123456;
    end
    */
    
    // 显示abcdef
    /*
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            rNum <= 24'd0;
        else
            rNum <= 24'habcdef;
    end
    */
    
    
    // 逐步显示000_000~fff_fff
    /*
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            rNum <= 24'd0;
        else
            if(count_s == T1S)
                if (rNum == 24'hfff_fff)
                    rNum <= 24'd0;
                else
                    rNum <= rNum + 1'b1;
    end
    */
    
    // 滚动显示000_000~fff_fff
    /*
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            rNum <= 24'd0;
        else
            if(count_s == T1S)
                if (rNum == 24'hfff_fff)
                    rNum <= 24'd0;
                else
                    rNum <= rNum + {6{4'd1}};
    end
    */
    
    // 分段滚动显示000_000~fff_fff
    reg [1:0]i;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            rNum <= 24'd0;
            i <= 2'd0;
        end
        else
            case(i)
            
                0:
                    begin
                        i <= 2'd1;
                        rNum <= 24'd0;
                    end
            
                1:
                    if(count_s == T1S) begin
                        if (rNum == 24'hfff_fff)
                            i <= 2'd0;
                        else begin
                            i <= 2'd2;
                            rNum <= rNum + {{3{4'd0}}, {3{4'd1}}}; // Error: rNum <= rNum + {3{4'd0}, 3{4'd1}}; 缺少{}
                        end
                    end
                
                2:
                    if(count_s == T1S) begin
                        if (rNum == 24'hfff_fff)
                            i <= 2'd0;
                        else begin 
                            i <= 2'd1;
                            rNum <= rNum + {{3{4'd1}}, {3{4'd0}}};
                        end
                    end
                    
            endcase
    end

    assign number_sig = rNum;

endmodule
