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
	reg [31:0] heath, heathPosx, heathPosy, heathTextPosx, heathTextPosy; 
	reg [31:0] heathMonster1, heathMonster1Posx, heathMonster1Posy, heathTextMonster1Posx, heathTextMonster1Posy;
	reg isFirstPage = 1;
	wire renderPlayer, renderBox, renderFirstPage, renderHeathBar, renderHeathText;
	wire renderMonster1, renderHeathMonster1Bar, renderHeathMonster1Text, renderHit1; 
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
       
        heath = 100;
        heathPosx = 270;
        heathPosy = 380;
        heathTextPosx = 250;
        heathTextPosy = 385;
        
        heathMonster1 = 100;
        heathMonster1Posx = 120;
        heathMonster1Posy = 50;
        heathTextMonster1Posx = 100;
        heathTextMonster1Posy = 55;
    end
    
    firstPageRenderer firstPage(renderFirstPage, {22'd0,x}, {22'd0,y}, clk);
    
    playerRenderer player(renderPlayer, {22'd0, center_x}, {22'd0,center_y}, {22'd0,x}, {22'd0,y}, 4);
    playerRenderer hit1(renderHit1, {22'd0, center_x_hit1}, {22'd0,center_y_hit1}, {22'd0,x}, {22'd0,y}, 4);
    playerRenderer hit2(renderHit2, {22'd0, center_x_hit2}, {22'd0,center_y_hit2}, {22'd0,x}, {22'd0,y}, 4); 
    boxRenderer box(renderBox, {22'd0,x}, {22'd0,y});
   
    heathBarRenderer heathBar(renderHeathBar, {22'd0,x}, {22'd0,y}, heathPosx, heathPosy, heath);
    heathTextRenderer heathText(renderHeathText, {22'd0,x}, {22'd0,y}, heathTextPosx, heathTextPosy, clk);
    
    monster1Renderer monster1(renderMonster1, {22'd0,x}, {22'd0,y});
    heathBarRenderer heathBarMonster1(renderHeathMonster1Bar, {22'd0,x}, {22'd0,y}, heathMonster1Posx, heathMonster1Posy, heathMonster1);
    heathTextRenderer heathTextMonster1(renderHeathMonster1Text, {22'd0,x}, {22'd0,y}, heathTextMonster1Posx, heathTextMonster1Posy, clk); 
    
    assign out = (renderFirstPage&&isFirstPage) || ((renderPlayer || renderBox || renderHeathBar || renderHeathText || renderMonster1 || renderHeathMonster1Bar || renderHeathMonster1Text || renderHit1 || renderHit2) && (~isFirstPage)) ? rgb_reg : 12'b0;
    
    always @(posedge clk)
    begin
        // color
        if (~isFirstPage)
            if (renderHeathBar || renderHeathMonster1Bar)
                rgb_reg <= 12'h0A0;
            else if (renderPlayer)
                rgb_reg <= 12'hF00;
            else 
                rgb_reg <= 12'hFFF;
        // control
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
        else if (kbControl == 32) //spacebar
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