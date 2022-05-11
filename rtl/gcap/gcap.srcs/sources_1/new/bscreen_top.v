`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// 
// Create Date: 02/23/2020 05:51:57 PM
// Design Name: 
// Module Name: bscreen_top
// Project Name: gcap
// Target Devices: Basys3
// Tool Versions: 
// Description: Top level module for capturing data from the bottom touch screen
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bscreen_top(
        input wire[7:0] red,
        input wire[7:0] green,
        input wire[7:0] blue,
        
        input wire clk,
        // Note the HSYNC and VSYNC lines will be edge detected
        input wire hsync,
        input wire vsync
    );
endmodule
