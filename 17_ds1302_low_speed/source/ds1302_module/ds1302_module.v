module ds1302_module
(
    input clk,
    input rst_n,

    input [7:0] cmd,
    output cmd_done,
    output [7:0] read_data,
    
    output sclk,
    output ce,
    inout sio
);


    wire [1:0] func_start;
    wire func_done;
    wire [7:0] register_addr;
    wire [7:0] write_data;
    

    ds_function u1
    (
        .clk(clk),
        .rst_n(rst_n),
        .func_start(func_start),
        .func_done(func_done),
        .register_addr(register_addr),
        .write_data(write_data),
        .read_data(read_data),
        .sclk(sclk),
        .ce(ce),
        .sio(sio)
    );
    
    
    ds_command u2
    (
        .clk(clk),
        .rst_n(rst_n),
        .cmd(cmd),
        .cmd_done(cmd_done),
        .func_done(func_done),
        .func_start(func_start),
        .register_addr(register_addr),
        .write_data(write_data)
    );

endmodule

