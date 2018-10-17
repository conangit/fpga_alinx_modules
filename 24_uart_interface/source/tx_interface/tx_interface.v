module tx_interface
(
    input clk,
    input rst_n,
    
    input fifo_write_req,
    input [7:0] fifo_write_data,
    output full,
    
    output tx_pin
);


    wire fifo_read_req;
    wire [7:0] fifo_read_data;
    wire empty;

    fifo_ip tx_fifo
    (
        .Data(fifo_write_data),
        .WrClock(clk),
        .RdClock(clk),
        .WrEn(fifo_write_req),
        .RdEn(fifo_read_req),
        .Reset(!rst_n),
        .RPReset(),
        .Q(fifo_read_data),
        .Empty(empty),
        .Full(full),
        .AlmostEmpty(),
        .AlmostFull()
    );
    
    
    wire tx_en_sig;
    wire tx_done;
    wire [7:0] tx_data;
    
    tx_top_control u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .fifo_read_req(fifo_read_req),
        .fifo_read_data(fifo_read_data),
        .empty(empty),
        .tx_en_sig(tx_en_sig),
        .tx_done(tx_done),
        .tx_data(tx_data)
    );
    
    
    tx_module u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done(tx_done),
        .tx_pin(tx_pin)
    );

endmodule

