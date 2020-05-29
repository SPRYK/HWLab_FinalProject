`timescale 1ns / 1ps

module attackBar(
    output out,
    input [31:0] x,
    input [31:0] y
    );
    //                                                                border                                                                          hit zone
    assign out = ((x == 250 || x == 390) && ((y >= 240)&&(y <= 350))) || ((y == 240 || y == 350) && ((x >= 250)&&(x <= 390))) || ((x >= 300 && x <= 340 ) && (y >= 240 && y <= 350 ));
endmodule
