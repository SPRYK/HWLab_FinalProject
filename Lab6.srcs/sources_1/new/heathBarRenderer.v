`timescale 1ns / 1ps

module heathBarRenderer(
    output out,
    input [31:0] x,
    input [31:0] y,
    input [31:0] posx,
    input [31:0] posy,
    input [31:0] heath
    );
    
    // TODO color and show based on remaining heath
    assign out = (x >= posx && x <= posx+heath) && (y >= posy && y <= posy+20);
endmodule
