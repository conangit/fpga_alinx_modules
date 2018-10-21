module led_gui_control
(
    input clk,
    input rst_n,
    
    input [11:0] menu_sig,
    output [3:0] led_out
);


    parameter T1MS = 16'd50_000;
    
    reg [15:0] count;
    reg isCount;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            count <= 16'd0;
        else if(count == T1MS)
            count <= 16'd0;
        else if(isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    
    reg [9:0] count_MS;
    reg [9:0] rTime;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            count_MS <= 10'd0;
        else if(count_MS == rTime)
            count_MS <= 10'd0;
        else if(count == T1MS)
            count_MS <= count_MS + 1'b1;
    end
    
    /*****************************************/
    
    
    reg [11:0] f1_sig;
    reg [11:0] f2_sig;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            f1_sig <= 12'd0;
            f2_sig <= 12'd0;
        end
        else
        begin
        
            f1_sig <= menu_sig;
            f2_sig <= f1_sig;
        end
    end
    
    
    
    reg [2:0] mode;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            mode <= 3'b100;
            rTime <= 10'h3ff;
        end
        else if(f1_sig != f2_sig)
        begin
            case(menu_sig)
            
            12'b100_000_000_000 : begin mode <= 3'b100; rTime <= 1000; end
            12'b010_000_000_000 : begin mode <= 3'b010; rTime <= 1000; end
            12'b001_000_000_000 : begin mode <= 3'b001; rTime <= 1000; end
            
            12'b100_100_000_000 : begin mode <= 3'b100; rTime <= 500; end
            12'b100_010_000_000 : begin mode <= 3'b100; rTime <= 250; end
            12'b100_001_000_000 : begin mode <= 3'b100; rTime <= 50; end
            
            12'b010_000_100_000 : begin mode <= 3'b010; rTime <= 500; end
            12'b010_000_010_000 : begin mode <= 3'b010; rTime <= 250; end
            12'b010_000_001_000 : begin mode <= 3'b010; rTime <= 50; end
            
            12'b001_000_000_100 : begin mode <= 3'b001; rTime <= 500; end
            12'b001_000_000_010 : begin mode <= 3'b001; rTime <= 250; end
            12'b001_000_000_001 : begin mode <= 3'b001; rTime <= 50; end
            
            endcase
        end
    end
    
    /*****************************************/
    
    reg [3:0] rLED;
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
            rLED <= 4'b1000;
        else
        begin
            case(mode)
            
                3'b100:
                if(isCount && count_MS == rTime)
                begin
                    isCount <= 1'b0;
                    rLED <= {rLED[0], rLED[3:1]}; //右移
                end
                else
                    isCount <= 1'b1;
                
                3'b010:
                if(isCount && count_MS == rTime)
                begin
                    isCount <= 1'b0;
                    rLED <= {rLED[2:0], rLED[3]}; //左移
                end
                else
                    isCount <= 1'b1;
                
                3'b001:
                if(isCount && count_MS == rTime)
                begin
                    isCount <= 1'b0;
                    rLED <= ~rLED; //闪烁
                end
                else
                    isCount <= 1'b1;
                    
            endcase
        end
    end
    
    
    assign led_out = rLED;

endmodule


