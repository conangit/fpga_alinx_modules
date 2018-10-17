module rx_interface
(
    input clk,
    input rst_n,
    input rx_pin,
    
    input fifo_read_req,
    output [7:0] fifo_read_data,
    output empty
);

    wire rx_done;
    wire [7:0] rx_data;
    wire rx_en_sig;
    wire fifo_write_req;
    wire [7:0] fifo_write_data;
    wire full;

    fifo_ip rx_fifo
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
    
    
    rx_top_control u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_done(rx_done),
        .rx_data(rx_data),
        .rx_en_sig(rx_en_sig),
        .fifo_write_req(fifo_write_req),
        .fifo_write_data(fifo_write_data),
        .full(full)
    );
    
    
    rx_module u3
    (
        .clk(clk),
        .rst_n(rst_n),
        .rx_en_sig(rx_en_sig),
        .rx_pin(rx_pin),
        .rx_done(rx_done),
        .rx_data(rx_data)
    );
    
endmodule


