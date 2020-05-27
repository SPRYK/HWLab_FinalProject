`timescale 1ns / 1ps

module boxRenderer(
    output out,
    input [31:0] x,
    input [31:0] y
    );
           
    assign out = ((x == 50 || x == 590) && ((y >= 240)&&(y <= 350))) || ((y == 240 || y == 350) && ((x >= 50)&&(x <= 590)));
endmodule
