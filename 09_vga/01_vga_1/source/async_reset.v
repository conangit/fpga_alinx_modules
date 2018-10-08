module async_reset
(
    input clk,
    input rst_n,
    output rst_n_out
);


    //异步复位 同步释放
    reg reset_1;
    reg reset_2;
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            reset_1 <= 1'b0;
            reset_2 <= 1'b0;
        end
        else begin
            reset_1 <= 1'b1;
            reset_2 <= reset_1;
        end
    end
    
    assign rst_n_out = reset_2;
    
endmodule

