`timescale 1ns / 1ps

module squareRenderer(
    output out,
    input [31:0] center_x,
    input [31:0] center_y,
    input [31:0] x,
    input [31:0] y,
    input [31:0] width
    );
    //                                  body                                                  head                                               left arm                                              right arm
    //assign out = ((x >= 270 && x <= 370) && (y >= 100 && y <= 200)) || ((x >= 308 && x <= 332) && (y >= 75 && y <= 100)) || ((x >= 220 && x <= 270) && (y >= 120 && y <= 140)) || ((x >= 370 && x <= 420) && (y >= 120 && y <= 140));
    //                                  body                                                
    assign out = ((x >= center_x - width && x <= center_x + width) && (y >= center_y - width && y <= center_y + width));
endmodule
