/*
 * 模式：
 * PC机发送数据经uart回环返回到PC
 *
 */

module rx_tx_demo (
    input CLK,
    input RST_n,
    input Rx_Pin_In,
    output Tx_Pin_Out
    );

    wire [7:0]rData;
    wire [7:0]tData;
    
    wire Rx_En_Sig;
    wire Rx_Done_Sig;
    
    wire Tx_En_Sig;
    wire Tx_Done_Sig;

    
    rx_module U1(
        .CLK(CLK),
        .RST_n(RST_n),
        .Rx_Pin_In(Rx_Pin_In),
        .Rx_En_Sig(Rx_En_Sig),
        .Rx_Done_Sig(Rx_Done_Sig),
        .Rx_Data(rData)
    );
    
    tx_module U2(
       .CLK(CLK),
       .RST_n(RST_n),
       .Tx_En_Sig(Tx_En_Sig),
       .Tx_Data(tData),
       .Tx_Done_Sig(Tx_Done_Sig),
       .Tx_Pin_Out(Tx_Pin_Out)
    );
    
    rx_tx_contect_module U3(
        .CLK(CLK),
        .RST_n(RST_n),
        .Rx_Done_Sig(Rx_Done_Sig),
        .Tx_Done_Sig(Tx_Done_Sig),
        .Rx_Data(rData),
        .Rx_En_Sig(Rx_En_Sig),
        .Tx_En_Sig(Tx_En_Sig),
        .Tx_Data(tData)
    );
    
endmodule

