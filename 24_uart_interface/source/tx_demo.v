module tx_demo
(
    input clk,
    input rst_n,
    output tx_pin
);

    reg fifo_write_req;
    reg [7:0] fifo_write_data;
    wire full;


    tx_interface u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .fifo_write_req(fifo_write_req),
        .fifo_write_data(fifo_write_data),
        .full(full),
        .tx_pin(tx_pin)
    );
    
    
    
    localparam T1S = 24'd12_000_000;
    
    reg [23:0]count;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            count <= 24'd0;
        else if(count == T1S)
            count <= 24'd0;
        else
            count <= count + 1'b1;
    end
    
    
    
    reg [2:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            i <= 3'd0;
            fifo_write_req <= 1'b0;
            fifo_write_data <= 8'd0;
        end
        else
        begin
            case(i)
                
                0:
                if(count == T1S)
                    i <= 1;
                
                1:
                if(!full)
                begin
                    i <= 2;
                    fifo_write_req <= 1'b1;
                    fifo_write_data <= 8'haa;
                end
                
                2:
                begin
                    i <= 3;
                    fifo_write_req <= 1'b0;
                end
                
                3:
                if(!full)
                begin
                    i <= 4;
                    fifo_write_req <= 1'b1;
                    fifo_write_data <= 8'h55;
                end
                
                4:
                begin
                    i <= 5;
                    fifo_write_req <= 1'b0;
                end
                
                5:
                    i <= 0;
            
            endcase
        end
    end
    
    
endmodule

