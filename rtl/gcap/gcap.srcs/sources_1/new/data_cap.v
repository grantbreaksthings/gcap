`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// 
// Create Date: 02/23/2020 06:12:33 PM
// Design Name: 
// Module Name: color_cap
// Project Name: gcap
// Target Devices: 
// Tool Versions: 
// Description: Captures a frame on a single color channel
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_cap # (parameter WIDTH = 8)(
        // The parallel video input data
        input wire[WIDTH-1:0] red,
        input wire[WIDTH-1:0] grn,
        input wire[WIDTH-1:0] blu,
        
        // The master video clock
        input wire clk,
        
        
        // The HSYNC video signal
        input wire hsync,
        // The VSYNC video signal
        input wire vsync,
        
        // Output to signal when the module has incremented its line count
        output reg new_line,
        // Output to signal when the module has finished its current frame
        output reg new_frame
    );
    
    // The current pixel in the line being captured (x coordinate)
    reg [8:0] pixel_count;
    // The current line in the frame being captured (y coordinate)
    reg [7:0] line_count;
endmodule
