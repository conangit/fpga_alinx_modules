


module pll_module(
    clk_in,
    RST_n,
    clk_out
    );
    
    input clk_in;
    input RST_n;
    output clk_out;
    
    // 50MHz --> 40MHz 扫描频率为60Hz
    freqdiv #(.DIV_IN(50), .DIV_OUT(40)) F1
    (
        .clk_in(clk_in),
        .rst(RST_n),
        .clk_out(clk_out)
    );
    
    // 50MHz --> 25MHz
    // 观察VGA扫描 : 此时扫描频率为38Hz
    // 调试发现 某优派显示器 当扫描频率低于39Hz时，会认为无信号输入
    // freqdiv #(.DIV_IN(50), .DIV_OUT(25)) F1
    // (
        // .clk_in(clk_in),
        // .rst(RST_n),
        // .clk_out(clk_out)
    // );
    
endmodule

