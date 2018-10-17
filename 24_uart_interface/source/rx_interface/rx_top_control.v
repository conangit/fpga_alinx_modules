module rx_top_control
(
    clk,
    rst_n,
    rx_done,
    rx_data,
    rx_en_sig,
    fifo_write_req,
    fifo_write_data,
    full
);

    input clk;
    input rst_n;
    
    input rx_done;
    input [7:0] rx_data;
    output reg rx_en_sig;
    
    output reg fifo_write_req;
    output reg [7:0] fifo_write_data;
    input full;
    
    /*************************************/
    
    reg [3:0] i;
    
    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            i <= 4'd0;
            rx_en_sig <= 1'b0;
            fifo_write_req <= 1'b0;
            fifo_write_data <= 8'd0;
        end
        else
        begin
            case(i)
            
                0:
                if(rx_done)
                begin
                    i <= 1;
                    rx_en_sig <= 1'b0;
                end
                else
                    rx_en_sig <= 1'b1;
                
                1:
                if(!full)
                    i <= 2;
                
                2:
                begin
                    i <= 3;
                    fifo_write_req <= 1'b1;
                    fifo_write_data <= rx_data;
                end
                
                3:
                begin
                    i <= 0;
                    fifo_write_req <= 1'b0;
                end
                
                default:
                begin
                    i <= 4'd0;
                    fifo_write_req <= 1'b0;
                    fifo_write_data <= 8'd0;
                end
                
            endcase
        end
    end

endmodule

