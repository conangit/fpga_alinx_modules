
module rom_module(
    input clk,
    input [5:0]rom_addr,
    output [63:0]red_rom_data,
    output [63:0]green_rom_data,
    output [63:0]blue_rom_data
    );
    
    red_rom_ip r1 (
        .clka(clk),
        .addra(rom_addr),
        .douta(red_rom_data)
    );
    
    green_rom_ip g1 (
        .clka(clk),
        .addra(rom_addr),
        .douta(green_rom_data)
    );
    
    blue_rom_ip b1 (
        .clka(clk),
        .addra(rom_addr),
        .douta(blue_rom_data)
    );
    
endmodule

