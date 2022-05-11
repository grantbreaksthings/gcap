`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2020 08:50:58 PM
// Design Name: 
// Module Name: tb_edge_detectors
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_edge_detectors;

    reg in = 0;
    reg clk = 0;
    wire posedge_out;
    wire negedge_out;
    
    posedge_detector posedge_DUT(
        .clk    (clk),
        .in     (in),
        .out    (posedge_out)
    );
    
    negedge_detector negedge_DUT(
        .clk    (clk),
        .in     (in),
        .out    (negedge_out)
    );
    
    task tick; 
        begin 
            clk = 1'b0; #5;
            clk = 1'b1; #5;
        end
    endtask
    
    initial begin
        tick;
        in = 1'b0;
        tick;
        tick;
        tick;
        in = 1'b1;
        tick;
        tick;
        in = 1'b0;
        tick;
        tick;
        tick;
        in = 1'b1;
        tick;
        tick;
    end
    
    
endmodule
