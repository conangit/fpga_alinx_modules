`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:17:55 08/03/2018 
// Design Name: 
// Module Name:    tx_demo 
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
module tx_demo(
    input CLK,
    input RST_n,
    output Tx_Pin_Out
    );
    
    reg Tx_En_Sig;
    reg [7:0] tData;
    wire Tx_Done_Sig;
    
    tx_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Tx_En_Sig(Tx_En_Sig),
        .Tx_Data(tData),
        .Tx_Done_Sig(Tx_Done_Sig),
        .Tx_Pin_Out(Tx_Pin_Out)
    );
    
    parameter T1S = 26'd49_999_999;
    
    reg [25:0]Count;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            Count <= 26'd0;
        else if (Count == T1S)
            Count <= 26'd0;
        else
            Count <= Count + 1'b1;
    end

    
    reg [3:0]i;
    
    /*
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 4'd0;
            Tx_En_Sig <= 1'b0;
            tData <= 8'd0;
        end
        else
            case(i)
            
                0:
                if(Count == T1S) begin //1s计时到,使能tx模块发送数据,此在再次计时1秒到来,才由有可能取消数据发送,故串口在这一秒内会一直发送00
                    Tx_En_Sig <= 1'b1;
                    if(Tx_Done_Sig) i <= 1; //引发跳转的信号,应该处于最前面
                end
                
                1:
                begin
                    Tx_En_Sig <= 1'b0;
                    tData <= tData + 1'b1;
                    i <= 0;
                end
            
            endcase
    end
    */
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 4'd0;
            Tx_En_Sig <= 1'b0;
            tData <= 8'd0;
        end
        else
            case(i)
            
                0:
                begin
                    if(Tx_Done_Sig) //并且两个条件有点类似"并行判断"关系
                        i <= 1;
                    if(Count == T1S)
                        Tx_En_Sig <= 1'b1;
                end
                
                1:
                begin
                    Tx_En_Sig <= 1'b0;
                    tData <= tData + 1'b1;
                    i <= 0;
                end
            
            endcase
    end


endmodule
