`timescale 1ns / 1ps

module monster1Renderer(
    output out,
    input [31:0] x,
    input [31:0] y
    );
    //                                  body                                                  head                                               left arm                                              right arm
    assign out = ((x >= 270 && x <= 370) && (y >= 100 && y <= 200)) || ((x >= 308 && x <= 332) && (y >= 75 && y <= 100)) || ((x >= 220 && x <= 270) && (y >= 120 && y <= 140)) || ((x >= 370 && x <= 420) && (y >= 120 && y <= 140));
endmodule
