`timescale 1ns / 1ps

module heathBarRenderer(
    output out,
    input [31:0] x,
    input [31:0] y,
    input [6:0] heath
    );
    // TODO color and show based on remaining heath
    assign out = (x >= 270 && x <= 370) && (y >= 380 && y <= 400);
endmodule
