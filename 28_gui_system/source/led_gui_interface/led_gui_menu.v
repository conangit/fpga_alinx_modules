

module led_gui_menu
(
    input clk,
    input rst_n,
    
    input [3:0] config_sig,  //[3]up [2]down [1]left [0]right
    output [11:0] menu_sig   //[11:9]menu [8:6]menuA [5:3]menuB [2:0]menuC
);
    
    /**********************************/
    //注解
    //[3]up [2]down -- 当前(同级)目录之间的上下切换
    //[1]left [0]right -- 不同级目录之间的左右切换
    /**********************************/
    
    reg [3:0] i;
    reg [2:0] menu;     //主目录
    reg [2:0] menuA;
    reg [2:0] menuB;
    reg [2:0] menuC;
    
    
    always @(posedge clk or negedge rst_n)
    begin
        if(~rst_n)
        begin
            i <= 4'd0;
            menu <= 3'b100;
            menuA <= 3'b000;
            menuB <= 3'b000;
            menuC <= 3'b000;
        end
        else
        begin
            case(i)
            
                //menuA
                0:
                if(config_sig[2]) //menuA -> menuB
                begin
                    i <= 1;
                    menu <= 3'b010;
                end
                else if(config_sig[0]) //->下级菜单
                begin
                    i <= 3;
                    menuA <= 3'b100;
                end
                
                //menuB
                1:
                if(config_sig[3]) //menuB -> menuA
                begin
                    i <= 0;
                    menu <= 3'b100;
                end
                else if(config_sig[2]) //menuB -> menuC
                begin
                    i <= 2;
                    menu <= 3'b001;
                end
                else if(config_sig[0]) //->下级菜单
                begin
                    i <= 6;
                    menuB <= 3'b100;
                end
                
                //menuC
                2:
                if(config_sig[3]) //menuC -> menuB
                begin
                    i <= 1;
                    menu <= 3'b010;
                end
                else if(config_sig[0]) //->下级菜单
                begin
                    i <= 9;
                    menuC <= 3'b100;
                end
                
                /*********/
                
                //menuAA
                3:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 0;
                    menuA <= 3'b000;
                end
                else if(config_sig[2])  //->right
                begin
                    menuA <= 3'b010;
                    i <= 4;
                end
                
                //menuAB
                4:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 0;
                    menuA <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    menuA <= 3'b100;
                    i <= 3;
                end
                else if(config_sig[2]) //->right
                begin
                    menuA <= 3'b001;
                    i <= 5;
                end
                
                
                //menuAC
                5:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 0;
                    menuA <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    i <= 4;
                    menuA <= 3'b010;
                end
                
                /*********/
                
                //menuBA
                6:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 1;
                    menuB <= 3'b000;
                end
                else if(config_sig[2])  //->right
                begin
                    menuB <= 3'b010;
                    i <= 7;
                end
                
                //menuBB
                7:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 1;
                    menuB <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    menuB <= 3'b100;
                    i <= 6;
                end
                else if(config_sig[2]) //->right
                begin
                    menuB <= 3'b001;
                    i <= 8;
                end
                
                //menuBC
                8:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 1;
                    menuB <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    i <= 7;
                    menuB <= 3'b010;
                end
                
                /*********/
                
                //menuCA
                9:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 2;
                    menuC <= 3'b000;
                end
                else if(config_sig[2])  //->right
                begin
                    menuC <= 3'b010;
                    i <= 10;
                end
                
                //menuCB
                10:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 2;
                    menuC <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    menuC <= 3'b100;
                    i <= 9;
                end
                else if(config_sig[2]) //->right
                begin
                    menuC <= 3'b001;
                    i <= 11;
                end
                
                //menuCC
                11:
                if(config_sig[1])   //->上级菜单
                begin
                    i <= 2;
                    menuC <= 3'b000;
                end
                else if(config_sig[3]) //->left
                begin
                    i <= 10;
                    menuC <= 3'b010;
                end
                
            endcase
        end
    end
    
    
    assign menu_sig = {menu, menuA, menuB, menuC};

endmodule

