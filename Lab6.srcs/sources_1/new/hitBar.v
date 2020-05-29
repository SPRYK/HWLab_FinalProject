`timescale 1ns / 1ps

module hitBar(
    output out,
    input [31:0] center_x,
    input [31:0] x,
    input [31:0] y,
    input [31:0] width
    );

    assign out = ((x >= center_x - width && x <= center_x + width) && ((y >= 240)&&(y <= 350)));
endmodule
