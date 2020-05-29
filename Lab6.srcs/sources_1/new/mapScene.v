`timescale 1ns / 1ps

module clk_divider(
    output reg fclk,
    input wire clk
);
    initial fclk = 0;
    always @(posedge clk) 
        fclk = !fclk;
endmodule

module mapScene(
    output wire[11:0] out,
    input wire[7:0] kbControl, //keyboard key
    input [9:0] x,
    input [9:0] y,
    input wire clk
    );
    wire [32:0]fclk;
    wire h1clock;
    wire h2clock;
    assign fclk[0] = clk;
    genvar i;
    for(i=1;i<26;i=i+1)
        begin
            clk_divider aclk(fclk[i], fclk[i-1]);
        end
    assign h1clock = fclk[25];
    assign h2clock = fclk[23];
    
    reg [11:0] rgb_reg;
	reg [9:0] center_x, center_y;
	reg [9:0] center_x_hit1, center_y_hit1;
	reg hit1_direction = 1;
	reg [9:0] center_x_hit2, center_y_hit2;
	reg hit2_direction = 1;
	reg [31:0] heath;
	reg isFirstPage = 1;
	wire renderPlayer, renderBox, renderFirstPage, renderHeathBar, renderHeathText;
	wire renderMonster1, renderHit1; 
	wire renderHit2;
	
	initial
    begin
        center_x = 320;
        center_y = 304;
        rgb_reg = 12'hFFF;
        // hit pattern 1
        hit1_direction = 1;
        center_x_hit1 = 156;
        center_y_hit1 = 244;
        // hit pattern 2
        hit2_direction = 1;
        center_x_hit2 = 56;
        center_y_hit2 = 280;
        // heath is 270 if 0%, 370 if 100%
        heath = 370;
    end
    
    firstPageRenderer firstPage(renderFirstPage, {22'd0,x}, {22'd0,y}, clk);
    
    playerRenderer player(renderPlayer, {22'd0, center_x}, {22'd0,center_y}, {22'd0,x}, {22'd0,y}, 4);
    playerRenderer hit1(renderHit1, {22'd0, center_x_hit1}, {22'd0,center_y_hit1}, {22'd0,x}, {22'd0,y}, 4);
    playerRenderer hit2(renderHit2, {22'd0, center_x_hit2}, {22'd0,center_y_hit2}, {22'd0,x}, {22'd0,y}, 4); 
    boxRenderer box(renderBox, {22'd0,x}, {22'd0,y});
   
    heathBarRenderer heathBar(renderHeathBar, {22'd0,x}, {22'd0,y}, heath);
    heathTextRenderer heathText(renderHeathText, {22'd0,x}, {22'd0,y}, clk, "100/100");
    
    monster1Renderer monster1(renderMonster1, {22'd0,x}, {22'd0,y}); 
    
    assign out = (renderFirstPage&&isFirstPage) || ((renderPlayer || renderBox || renderHeathBar || renderHeathText || renderMonster1 || renderHit1 || renderHit2) && (~isFirstPage)) ? rgb_reg : 12'b0;
    
    always @(posedge clk)
    begin
        if (kbControl == 119) //w
            begin
                if (center_y > 248)
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
    // hit 1 movement speed
    always @(posedge h1clock) 
    begin
        if (center_y_hit1 == 340)
            hit1_direction = 0;
        else if (center_y_hit1 == 252)
             hit1_direction = 1;
        if (hit1_direction)
            center_y_hit1 <= center_y_hit1 + 8;
        else
            center_y_hit1 <= center_y_hit1 - 8;     
    end
    // hit 2 movement speed
    always @(posedge h2clock) 
    begin
        if (center_x_hit2 == 584)
            hit2_direction = 0;
        else if (center_x_hit2 == 56)
             hit2_direction = 1;
        if (hit2_direction)
            center_x_hit2 <= center_x_hit2 + 8;
        else
            center_x_hit2 <= center_x_hit2 - 8;     
    end    
endmodule