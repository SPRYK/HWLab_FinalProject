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
    wire hitBarclock;
    wire dodgeModeclock;
    assign fclk[0] = clk;
    genvar i;
    for(i=1;i<26;i=i+1)
        begin
            clk_divider aclk(fclk[i], fclk[i-1]);
        end
    assign h1clock = fclk[25];
    assign h2clock = fclk[23];
    assign hitBarclock = fclk[22];
    assign dodgeModeclock = fclk[25];
    reg count = 0;
    
    reg [11:0] rgb_reg;
	reg [9:0] center_x_player, center_y_player;
	reg [9:0] center_x_monster1, center_y_monster1;
	reg [9:0] center_x_monster2, center_y_monster2;
	reg [9:0] center_x_hitBar;
	reg hitBar_direction = 1;
	reg [9:0] center_x_hit1, center_y_hit1;
	reg hit1_direction = 1;
	reg [9:0] center_x_hit2, center_y_hit2;
	reg hit2_direction = 1;
	reg [31:0] heath, heathPosx, heathPosy, heathTextPosx, heathTextPosy; 
	reg [31:0] heathMonster1, heathMonster1Posx, heathMonster1Posy, heathTextMonster1Posx, heathTextMonster1Posy;
	reg [31:0] heathMonster2, heathMonster2Posx, heathMonster2Posy, heathTextMonster2Posx, heathTextMonster2Posy;
	wire renderPlayer, renderBox, renderAttackBar, renderHitBar, renderFirstPage, renderHeathBar, renderHeathText;
	wire renderMonster1, renderHeathMonster1Bar, renderHeathMonster1Text, renderHit1;
	wire renderMonster2, renderHeathMonster2Bar, renderHeathMonster2Text, renderHit2;
	
	reg isFirstPage = 1;
	reg isAttackMode = 1;
	reg selectedMonster = 0;
	reg monster1isDead = 0;
	reg monster2isDead = 0;
	reg isHit1 = 0;
	reg isHit2 = 0;
    	
	initial
    begin
        center_x_player = 320;
        center_y_player = 304;
        center_x_hitBar = 255;
        center_x_monster1 = 170;
        center_y_monster1 = 150;
        center_x_monster2 = 470;
        center_y_monster2 = 150;
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
        
        heathMonster2 = 100;
        heathMonster2Posx = 420;
        heathMonster2Posy = 50;
        heathTextMonster2Posx = 400;
        heathTextMonster2Posy = 55;
    end
    
    firstPageRenderer firstPage(renderFirstPage, {22'd0,x}, {22'd0,y}, clk);
    
    circleRenderer player(renderPlayer, {22'd0, center_x_player}, {22'd0,center_y_player}, {22'd0,x}, {22'd0,y}, 4);
    boxRenderer box(renderBox, {22'd0,x}, {22'd0,y});
    attackBar attackBar(renderAttackBar, {22'd0,x}, {22'd0,y});
    hitBar hitBar(renderHitBar, center_x_hitBar, {22'd0,x}, {22'd0,y}, 5);
   
    heathBarRenderer heathBar(renderHeathBar, {22'd0,x}, {22'd0,y}, heathPosx, heathPosy, heath);
    heathTextRenderer heathText(renderHeathText, {22'd0,x}, {22'd0,y}, heathTextPosx, heathTextPosy, clk);
    
    squareRenderer monster1(renderMonster1, {22'd0, center_x_monster1}, {22'd0,center_y_monster1}, {22'd0,x}, {22'd0,y}, 50);
    squareRenderer hit1(renderHit1, {22'd0, center_x_hit1}, {22'd0,center_y_hit1}, {22'd0,x}, {22'd0,y}, 4);
    heathBarRenderer heathBarMonster1(renderHeathMonster1Bar, {22'd0,x}, {22'd0,y}, heathMonster1Posx, heathMonster1Posy, heathMonster1);
    heathTextRenderer heathTextMonster1(renderHeathMonster1Text, {22'd0,x}, {22'd0,y}, heathTextMonster1Posx, heathTextMonster1Posy, clk); 
    
    circleRenderer monster2(renderMonster2, {22'd0, center_x_monster2}, {22'd0,center_y_monster2}, {22'd0,x}, {22'd0,y}, 50);
    circleRenderer hit2(renderHit2, {22'd0, center_x_hit2}, {22'd0,center_y_hit2}, {22'd0,x}, {22'd0,y}, 4); 
    heathBarRenderer heathBarMonster2(renderHeathMonster2Bar, {22'd0,x}, {22'd0,y}, heathMonster2Posx, heathMonster2Posy, heathMonster2);
    heathTextRenderer heathTextMonster2(renderHeathMonster2Text, {22'd0,x}, {22'd0,y}, heathTextMonster2Posx, heathTextMonster2Posy, clk); 
    
    //                      first page                                                                                                                                                                              dodge mode                                                                                                                                                                                                              attack mode
    assign out = (renderFirstPage&&isFirstPage) || ((renderPlayer || renderBox || renderHeathBar || renderHeathText || ((renderMonster1 || renderHeathMonster1Bar || renderHeathMonster1Text) && (~monster1isDead)) || ((renderHit1) && (~selectedMonster && ~monster1isDead && ~isHit1)) || ((renderMonster2 || renderHeathMonster2Bar || renderHeathMonster2Text) && (~monster2isDead)) || ((renderHit2) && (selectedMonster && ~monster2isDead  && ~isHit2))) && (~isFirstPage && ~isAttackMode )) || ((renderAttackBar || renderHitBar || ((renderMonster1 || renderHeathMonster1Bar || renderHeathMonster1Text) && (~monster1isDead)) || ((renderMonster2 || renderHeathMonster2Bar || renderHeathMonster2Text) && (~monster2isDead)) || renderHeathBar || renderHeathText) && (~isFirstPage && isAttackMode )) ? rgb_reg : 12'b0;
    
    always @(posedge clk)
    begin
        // game end
        if ((heath == 0) || (monster1isDead && monster2isDead))
            // reset
            begin
                isFirstPage <= 1;
                heath <= 100;
                heathMonster1 <= 100;
                heathMonster2 <= 100;
                monster1isDead <= 0;
                monster2isDead <= 0;
                isAttackMode <= 1;
	            selectedMonster <= 0;
	            isHit1 <= 0;
	            isHit2 <= 0;
            end
        if (heathMonster1 == 0)
            begin
                monster1isDead <= 1;
                selectedMonster <= 1;
            end
        if (heathMonster2 == 0)
            begin
                monster2isDead <= 1;
                selectedMonster <= 0;
            end
        if (renderPlayer && renderHit1)
            begin
                isHit1 <= 1;
                heath <= heath - 20;
            end
        if (renderPlayer && renderHit2)
            begin
                isHit2 <= 1;
                heath <= heath - 20;
            end
            
        // color dodge mode 
        if (~isFirstPage && ~isAttackMode)
            begin
                if (renderHeathBar || renderHeathMonster1Bar || renderHeathMonster2Bar)
                    rgb_reg <= 12'h0A0;
                else if (renderPlayer)
                    rgb_reg <= 12'hF00;
                else if (renderMonster1)
                    if (~selectedMonster)
                        rgb_reg <= 12'hF00;
                    else
                        rgb_reg <= 12'hFFF;
                else if (renderMonster2)
                    if (selectedMonster)
                        rgb_reg <= 12'hF00;
                    else
                        rgb_reg <= 12'hFFF;
                else 
                    rgb_reg <= 12'hFFF;
            end
        // color attack mode
        else if (~isFirstPage && isAttackMode)
            begin
                if (renderHeathBar || renderHeathMonster1Bar || renderHeathMonster2Bar)
                    rgb_reg <= 12'h0A0;
                else if (renderHitBar)
                    rgb_reg <= 12'hF00;
                else if (renderMonster1)
                    if (~selectedMonster)
                        rgb_reg <= 12'hF00;
                    else
                        rgb_reg <= 12'hFFF;
                else if (renderMonster2)
                    if (selectedMonster)
                        rgb_reg <= 12'hF00;
                    else
                        rgb_reg <= 12'hFFF;
                else 
                    rgb_reg <= 12'hFFF;
            end
        // control in first page
        if (isFirstPage)
            begin
                if (kbControl == 32) //spacebar to continue
                    isFirstPage <= 0;
            end
        // attack mode
        else if (isAttackMode)
            begin
                // control
                if (kbControl == 97) //a
                    selectedMonster = 0;
                else if (kbControl == 100) //d
                    selectedMonster = 1;
                else if (kbControl == 32) //spacebar to attack
                    begin
                        // stop in hit zone
                        if ((center_x_hitBar - 5 >= 300 && center_x_hitBar - 5 <= 340) || (center_x_hitBar + 5 >= 300 && center_x_hitBar + 5 <= 340))
                            begin
                                if (~selectedMonster)
                                    heathMonster1 <= heathMonster1 - 20; 
                                else
                                    heathMonster2 <= heathMonster2 - 20;
                            end        
                        isAttackMode <= 0;
                    end              
            end
        // dodge mode
        else if (~isAttackMode)
            begin
                // reset hit
                isHit1 <= 0;
	            isHit2 <= 0;
	            // control
                if (kbControl == 119) //w
                    begin
                        if (center_y_player > 248)
                            center_y_player <= center_y_player - 8;
                    end
                else if (kbControl == 97) //a
                    begin
                        if (center_x_player > 58)
                            center_x_player <= center_x_player - 8;
                    end
                else if (kbControl == 115) //s
                    begin
                        if (center_y_player < 342)
                            center_y_player <= center_y_player + 8;
                    end
                else if (kbControl == 100) //d
                    begin
                        if (center_x_player < 582)
                            center_x_player <= center_x_player + 8;
                    end
            end
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
    // hit bar movement speed
    always @(posedge hitBarclock) 
    begin
        if (center_x_hitBar == 385)
            hitBar_direction = 0;
        else if (center_x_hitBar == 255)
            hitBar_direction = 1;
        if (hitBar_direction)
           center_x_hitBar <= center_x_hitBar + 5;
        else
            center_x_hitBar <= center_x_hitBar - 5;        
    end
    // 5 sec timer when in dodge mode
//    always @(posedge dodgeModeclock) 
//    begin
//        // in dodge mode
//        if (~isAttackMode && ~isFirstPage)
//            count <= count + 1;
//        if (count == 10)
//            isAttackMode <= 1;
//            count = 0;    
//    end        
endmodule