`timescale 1ns / 1ps

module mapScene(
    output wire[11:0] out,
    input wire[7:0] kbControl, //keyboard key
    input [9:0] x,
    input [9:0] y,
    input clk
    );
    
    reg [11:0] rgb_reg;
	reg [9:0] center_x, center_y;
	reg isFirstPage = 1;
	wire renderPlayer, renderBox, renderFirstPage, renderHeathBar, renderHeathText, renderMonster1;
	
	initial
    begin
        center_x = 9'd320;
        center_y = 9'd305;
        rgb_reg = 12'hFFF;
    end
    
    firstPageRenderer firstPage(renderFirstPage, {22'd0,x}, {22'd0,y}, clk);
    
    playerRenderer player(renderPlayer, {22'd0, center_x}, {22'd0,center_y}, {22'd0,x}, {22'd0,y}, 4); 
    boxRenderer box(renderBox, {22'd0,x}, {22'd0,y});
   
    heathBarRenderer heathBar(renderHeathBar, {22'd0,x}, {22'd0,y}, 100);
    heathTextRenderer heathText(renderHeathText, {22'd0,x}, {22'd0,y}, clk, "100/100");
    
    monster1Renderer monster1(renderMonster1, {22'd0,x}, {22'd0,y});
   
    assign out = (renderFirstPage&&isFirstPage) || ((renderPlayer || renderBox || renderHeathBar || renderHeathText || renderMonster1) && (~isFirstPage)) ? rgb_reg : 12'b0;
    
    always @(posedge clk)
    begin
        if (kbControl == 119) //w
            begin
                if (center_y > 252)
                    center_y <= center_y - 8;
            end
        else if (kbControl == 97) //a
            begin
                if (center_x > 58)
                    center_x <= center_x - 8;
            end
        else if (kbControl == 115) //s
            begin
                if (center_y < 342)
                    center_y <= center_y + 8;
            end
        else if (kbControl == 100) //d
            begin
                if (center_x < 582)
                    center_x <= center_x + 8;
            end
        // color
        else if (kbControl == 99) //c
            rgb_reg <= 12'h0FF;
        else if (kbControl == 109) //m
            rgb_reg <= 12'hF0F;
        else if (kbControl == 121) //y
            rgb_reg <= 12'hFF0;
        // TODO control change to ENTER
        else if (kbControl == 32) //spacebar
            //rgb_reg <= 12'hFFF;
            //TODO Change to ENTER
            isFirstPage <= 0;
    end
    
endmodule