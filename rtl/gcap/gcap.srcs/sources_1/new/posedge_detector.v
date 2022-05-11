`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2020 08:43:53 PM
// Design Name: 
// Module Name: posedge_detector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: https://programmer.help/blogs/5ce5b74dbd866.html
// 
//////////////////////////////////////////////////////////////////////////////////



module posedge_detector(
        // The signal to detect
        input wire in,
        // The master clock
        input wire clk,
        
        // The output
        output wire out
    );
    // Store the previous state
    reg prev = 0;
    
    always @(posedge clk) begin
        // Always clock in a new state
        prev <= in;
    end
    
    // This design worries me a bit because it relies on the input being stable
    // for more than one clock cycle, but so far all the signals seem to do that
    assign out = ~prev & in;
     
endmodule
