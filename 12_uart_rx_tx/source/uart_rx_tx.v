
module uart_rx_tx
(
    input clk,
    input rst_n,
    input rx,
    output tx
);
    
    reg rx_en;
    wire rx_done;
    wire [7:0] data;
    
    reg tx_en;
    wire tx_done;
    
    
    rx_module u1(
        .CLK(clk),
        .RST_n(rst_n),
        .Rx_Pin_In(rx),
        .Rx_En_Sig(rx_en),
        .Rx_Done_Sig(rx_done),
        .Rx_Data(data)
    );
    
    
    tx_module u2(
        .CLK(clk),
        .RST_n(rst_n),
        .Tx_En_Sig(tx_en),
        .Tx_Data(data),
        .Tx_Done_Sig(tx_done),
        .Tx_Pin_Out(tx)
    );
    
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            i <= 4'd0;
            
        end
        else
            case(i)
            
                0:
                if(rx_done) begin
                    rx_en <= 1'b0;
                    tx_en <= 1'b1;
                    i <= 1;
                end
                else begin
                    rx_en <= 1'b1;
                    tx_en <= 1'b0;
                end
                
                1:
                if(tx_done) begin
                    rx_en <= 1'b1;
                    tx_en <= 1'b0;
                    i <= 0;
                end
                else begin
                    rx_en <= 1'b0;
                    tx_en <= 1'b1;
                end
                
            endcase
    end
    
endmodule

