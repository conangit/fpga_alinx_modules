module beep_function_module(
    clk,
    rst_n,
    start_sig,
    done_sig,
    pin_out
    );
    
    input clk;
    input rst_n;
    
    input [1:0]start_sig;
    
    output done_sig;
    output pin_out;
    
    /**********************************/
    
    reg isDone;
    reg pin;
    
    parameter T1MS = 16'd49_999;
    
    reg [15:0]count;
    reg isCount;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    reg [8:0]count_ms;
    reg [8:0]rTime;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_ms <= 9'd0;
        else if (count_ms == rTime)
            count_ms <= 9'd0;
        else if (count == T1MS)
            count_ms <= count_ms + 1'b1;
    end
    
    
    reg [3:0]i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            isCount <= 1'b0;
            isDone <= 1'b0;
            pin <= 1'b0;
            rTime <= 9'h1ff;
        end
        else if (start_sig[1]) //S码
            
            case(i)
            
                0,2,4:
                if (count_ms == rTime) begin
                    i <= i + 1'b1;
                    isCount <= 1'b0;
                    pin <= 1'b0;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 9'd100;
                    pin <= 1'b1;
                end
                
                1,3,5:
                if (count_ms == rTime) begin
                    i <= i + 1'b1;
                    isCount <= 1'b0;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 9'd50;
                end
                
                6:
                begin
                    i <= i + 1'b1;
                    isDone <= 1'b1;
                end
                
                7:
                begin
                    i <= 4'd0;
                    isDone <= 1'b0;
                end
            
            endcase
        
        else if (start_sig[0]) //O码
        
            case(i)
            
                0,2,4:
                if (count_ms == rTime) begin
                    i <= i + 1'b1;
                    isCount <= 1'b0;
                    pin <= 1'b0;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 9'd400;
                    pin <= 1'b1;
                end
                
                1,3,5:
                if (count_ms == rTime) begin
                    i <= i + 1'b1;
                    isCount <= 1'b0;
                end
                else begin
                    isCount <= 1'b1;
                    rTime <= 9'd50;
                end
                
                6:
                begin
                    i <= i + 1'b1;
                    isDone <= 1'b1;
                end
                
                7:
                begin
                    i <= 4'd0;
                    isDone <= 1'b0;
                end
            
            endcase
    end
    
    
    assign done_sig = isDone;
    assign pin_out = ~pin;
    
endmodule

