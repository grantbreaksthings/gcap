`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2020 04:48:00 PM
// Design Name: 
// Module Name: tb_dram
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


module tb_dram;
    
    wire dq[7:0]; 
    
    wire rwds;
    wire rclk;
    wire rnclk;
    wire rncs;
    wire rnrst;

    reg rw;
    reg as;
    reg burst;
    
    reg [15:0]din;
    wire [15:0]dout;
    reg [12:0]row;
    reg [5:0]hpage;
    reg [2:0]word;
    reg cs = 0;
    wire datrdy;
    reg rst = 0;
    reg clk = 0;
    
    dram_top DUT(
        .rncs(rncs),
        .rnrst(rnrst),
        .rw(rw),
        .as(as),
        .burst(burst),
        .din(din),
        .dout(dout),
        .row(row),
        .hpage(hpage),
        .word(word),
        .cs(cs),
        .datrdy(datrdy),
        .rst(rst),
        .clk(clk)
    );
    
    task tickup;
        begin
            clk = 1'b1; #5;
        end
    endtask
    
    task tickdown;
        begin
            clk = 1'b0; #5;
        end
    endtask
    
    initial begin
        cs = 1;
        row = 0;
        hpage = 0;
        word = 0;
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
        tickup;
        tickdown;
        
    end
    
endmodule
