

module tx_top_control
(
    clk,
    rst_n,
    fifo_read_req,
    fifo_read_data,
    empty,
    tx_en_sig,
    tx_done,
    tx_data
);

    input clk;
    input rst_n;
    
    output reg fifo_read_req;
    input [7:0] fifo_read_data;
    input empty;
    
    output reg tx_en_sig;
    input tx_done;
    output reg [7:0] tx_data;

    /*******************************/

    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 4'd0;
            fifo_read_req <= 1'b0;
            tx_en_sig <= 1'b0;
            tx_data <= 8'd0;
        end
        else
        begin
            case(i)
                
                0:
                if(!empty)
                begin
                    i <= 1;
                end
                
                1:
                begin
                    i <= 2;
                    fifo_read_req <= 1'b1;
                end
                
                2:
                begin
                    i <= 3;
                    fifo_read_req <= 1'b0;
                end
                
                3:
                begin
                    i <= 4;
                    tx_en_sig <= 1'b1;
                    tx_data <= fifo_read_data;
                end
                
                4:
                if(tx_done)
                begin
                    i <= 0;
                    tx_en_sig <= 1'b0;
                end
                
                default:
                begin
                    i <= 4'd0;
                    fifo_read_req <= 1'b0;
                    tx_en_sig <= 1'b0;
                    tx_data <= 8'd0;
                end
                
            endcase
        end
    end
    
    
endmodule

