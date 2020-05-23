`timescale 1ns / 1ps

module textRenderer(
    output video_on,
    input [31:0] VGA_horzCoord,
    input [31:0] VGA_vertCoord,
    input clk
    );
        wire member1, member2, member3, member4, member5;
        Pixel_On_Text2 #(.displayText("Group members")) t1(
                clk,
                280,
                50,
                VGA_horzCoord,
                VGA_vertCoord,
                title 
            );
        Pixel_On_Text2 #(.displayText("1. Kasidit Ratanawongpitak 6030031021")) t2(
                clk,
                200,
                150,
                VGA_horzCoord,
                VGA_vertCoord,
                member1
            ); 
        Pixel_On_Text2 #(.displayText("2. Papon Chaisrisookumporn 6030352521")) t3(
                clk,
                200,
                200,
                VGA_horzCoord,
                VGA_vertCoord,
                member2
            );
        Pixel_On_Text2 #(.displayText("3. Seth Poophak 6030583121")) t4(
                clk,
                200,
                250,
                VGA_horzCoord,
                VGA_vertCoord,
                member3
            );
        Pixel_On_Text2 #(.displayText("4. Rapipong Setwipattanachai 6030665021")) t5(
                clk,
                200,
                300,
                VGA_horzCoord,
                VGA_vertCoord,
                member4
            );
        Pixel_On_Text2 #(.displayText("Enter to continue")) t6(
                clk,
                270,
                400,
                VGA_horzCoord,
                VGA_vertCoord,
                continue
            );                                                
            
        assign video_on = title || member1 || member2 || member3 || member4 || continue;
            
endmodule
