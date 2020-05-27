`timescale 1ns / 1ps

module playerRenderer(
    output out,
    input [31:0] center_x,
    input [31:0] center_y,
    input [31:0] x,
    input [31:0] y,
    input [31:0] radius
    );
    
    assign out = 
        ((center_x - x) * (center_x - x) 
        + (center_y - y) * (center_y - y))
        <= (radius * radius);
endmodule
