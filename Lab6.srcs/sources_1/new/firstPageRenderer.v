`timescale 1ns / 1ps

module firstPageRenderer(
    output out,
    input [31:0] x,
    input [31:0] y,
    input clk
    );
    
    wire member1, member2, member3, member4, member5, title, continue;
    
    Pixel_On_Text2 #(.displayText("Group members")) t1(
            clk,
            280,
            50,
            x,
            y,
            title 
    );
    Pixel_On_Text2 #(.displayText("1. Kasidit Ratanawongpitak 6030031021")) t2(
            clk,
            200,
            150,
            x,
            y,
            member1
    ); 
    Pixel_On_Text2 #(.displayText("2. Papon Chaisrisookumporn 6030352521")) t3(
            clk,
            200,
            200,
            x,
            y,
            member2
    );
    Pixel_On_Text2 #(.displayText("3. Seth Poophak 6030583121")) t4(
            clk,
            200,
            250,
            x,
            y,
            member3
    );
    Pixel_On_Text2 #(.displayText("4. Rapipong Setwipattanachai 6030665021")) t5(
            clk,
            200,
            300,
            x,
            y,
            member4
    );
    Pixel_On_Text2 #(.displayText("Spacebar to continue")) t6(
            clk,
            270,
            400,
            x,
            y,
            continue
    );                                                
            
    assign out = title || member1 || member2 || member3 || member4 || continue;         
endmodule
