`timescale 1ns / 1ps

module heathTextRenderer(
    output out,
    input [31:0] x,
    input [31:0] y,
    input [31:0] Posx,
    input [31:0] Posy,
    input clk
    );
    
    wire label, heath;
    
    Pixel_On_Text2 #(.displayText("HP")) t1(
            clk,
            Posx,
            Posy,
            x,
            y,
            label 
    );
    // TODO can't use variable so can not change
//    Pixel_On_Text2 #(.displayText(heathText)) t2(
//            clk,
//            380,
//            385,
//            x,
//            y,
//            heath
//    ); 
    
    assign out = label || heath; 
endmodule
