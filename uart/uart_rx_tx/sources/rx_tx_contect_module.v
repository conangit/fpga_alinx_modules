

module rx_tx_contect_module(
    CLK,
    RST_n,
    Rx_Done_Sig,
    Tx_Done_Sig,
    Rx_Data,
    Rx_En_Sig,
    Tx_En_Sig,
    Tx_Data
    );

    input CLK;
    input RST_n;
    
    input Rx_Done_Sig;
    input Tx_Done_Sig;
    input [7:0]Rx_Data;
    
    output Rx_En_Sig;
    output Tx_En_Sig;
    output [7:0]Tx_Data;
    
    /*
    // rx tx之间的数据使用一个D触发器隔离
    reg [7:0]tData;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            tData <= 8'h00;
        end
        else begin
            tData <= Rx_Data;
        end
    end
    */


    // rx模块接收完一帧数据 产生一个Rx_Done_Sig脉冲
    // 在Rx_Done_Sig和Tx_Done_Sig之间，应保持Tx_En_Sig有效
    // reg isEn;
    
    /*
    //将不停的发送数据
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            isEn <= 1'b0;
        else if (Rx_Done_Sig)
            isEn <= 1'b1;
        else if (Tx_Done_Sig)
            isEn <= 1'b0;
    end
    */
    
    /*
    //接收一帧数据后 无法再接收数据?
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            isEn <= 1'b0;
        else if (Tx_Done_Sig)
            isEn <= 1'b0;
        else if (Rx_Done_Sig)
            isEn <= 1'b1;
    end
    */
    
    reg [2:0]i;
    reg is_Rx_En;
    reg is_Tx_En;
    reg [7:0]tData;

    // 仿顺序建模
    // 为什么没法实现如下逻辑？在接收一个字符后，PC再次发送，模块不正常工作
    // rx tx模块一帧数据的收尾工作出现错误!!!!
    /*
    // 修正后 下列过程块表现正常
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 3'd0;
            is_Rx_En <= 1'b0;
            is_Tx_En <= 1'b0;
            tData <= 8'h00;
        end
        else begin
            case (i)
                3'd0: begin
                    i <= i + 1'b1;
                    // 使能Rx模块
                    is_Rx_En <= 1'b1;
                end
                
                3'd1: begin
                    // 等待Rx接收一帧数据
                    if (Rx_Done_Sig) begin
                        i <= i + 1'b1;
                        is_Rx_En <= 1'b0;
                    end
                end
                
                3'd2: begin
                    i <= i + 1'b1;
                    // tx采集rx数据
                    tData <= Rx_Data;
                end
                
                3'd3: begin
                    i <= i + 1'b1;
                    // 使能tx模块
                    is_Tx_En <= 1'b1;
                end
                
                3'd4: begin
                    // 等待tx发送一帧数据
                    if (Tx_Done_Sig) begin
                        i <= i + 1'b1;
                        is_Tx_En <= 1'b0;
                    end
                end
                
                3'd5: begin
                    i <= 3'd0;
                end
            endcase
        end
    end
    */
    
    /* 另一种简洁写法 */
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n) begin
            i <= 3'd0;
            is_Rx_En <= 1'b0;
            is_Tx_En <= 1'b0;
            tData <= 8'h00;
        end
        else begin
            case(i)
                3'd0:
                    if (Rx_Done_Sig) begin
                        i <= i + 1'b1;
                        is_Rx_En <= 1'b0;
                    end
                    else 
                        is_Rx_En <= 1'b1;
                        
                3'd1:
                    if (Tx_Done_Sig) begin
                        i <= i + 1'b1;
                        is_Tx_En <= 1'b0;
                    end
                    else begin
                        tData <= Rx_Data;
                        is_Tx_En <= 1'b1;
                    end
                    
                3'd2:
                    i <= 3'd0;
            endcase
        end
    end
    
    assign Tx_Data = tData;
    assign Rx_En_Sig = is_Rx_En;
    assign Tx_En_Sig = is_Tx_En;
    
endmodule

