


module pll_module(
    clk_in,
    RST_n,
    clk_out
    );
    
    input clk_in;
    input RST_n;
    output clk_out;
    
    // 50MHz --> 25.175MHz
    // freqdiv #(.DIV_IN(50), .DIV_OUT(25.175)) F1
    freqdiv #(.DIV_IN(50), .DIV_OUT(25)) F1
    (
        .clk_in(clk_in),
        .rst(RST_n),
        .clk_out(clk_out)
    );
    
endmodule

