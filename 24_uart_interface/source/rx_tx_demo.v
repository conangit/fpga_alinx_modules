module rx_tx_demo
(
    input clk,
    input rst_n,
    input rx_pin,
    output tx_pin
);

    reg fifo_read_req;
    wire [7:0] fifo_read_data;
    wire empty;

    rx_interface rx
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_pin(rx_pin),
        .fifo_read_req(fifo_read_req),
        .fifo_read_data(fifo_read_data),
        .empty(empty)
    );
    
    reg fifo_write_req;
    reg [7:0] fifo_write_data;
    wire full;
    
    
    tx_interface tx
    (
        .clk(clk),
        .rst_n(rst_n),
        .fifo_write_req(fifo_write_req),
        .fifo_write_data(fifo_write_data),
        .full(full),
        .tx_pin(tx_pin)
    );


    reg [3:0] i;
    

    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 4'd0;
            fifo_read_req <= 1'b0;
            fifo_write_req <= 1'b0;
            fifo_write_data <= 8'd0;
        end
        else
        begin
            case(i)
            
                0:
                if(!empty)
                    i <= 1;
                
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
                    fifo_write_data <= fifo_read_data;
                end
                
                4:
                if(!full)
                    i <= 5;
                    
                5:
                begin
                    i <= 6;
                    fifo_write_req <= 1'b1;
                end
                
                6:
                begin
                    i <= 7;
                    fifo_write_req <= 1'b0;
                end
                
                7:
                    i <= 0;
                
                default:
                begin
                    i <= 4'd0;
                    fifo_read_req <= 1'b0;
                    fifo_write_req <= 1'b0;
                    fifo_write_data <= 8'd0;
                end
                
            endcase
        end
    end

endmodule

