`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2020 12:28:18 AM
// Design Name: 
// Module Name: dram_top
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


module dram_top(
        // RAM interface
        inout [7:0]dq,              // Main RAM data bus
        // Control signals for RAM
        inout rwds,                 // Read/Write data strobe. Handshaking signal
        output rclk,                // DRAM differential clock (CK)
        output rnclk,               // DRAM differential clock (CK#)
        output reg rncs = 1,        // DRAM chip select, active low
        output reg rnrst = 1,
        // Operation types
        input rw,                   // Read/Write bit
        input as,                   // Address space bit (0 is memory, 1 is register)
        input burst,                // 0 for wrapped burst, 1 for linear burst

        
        // Module Interface
        // Data
        input [15:0]din,            // Data input to the module
        output reg [15:0]dout = 0,  // Data output from the module
        // Address
        input [12:0]row,            // The row in the chip to read (8192 per chip)
        input [5:0]hpage,           // The half page in the row to read (64 per row). Datasheet calls this upper column select
        input [2:0]word,            // The word in the half page to read (8 words per hpage). Datasheet calls this lower column select
        // Control signals
        input cs,                   // Activate the module
        output reg datrdy = 0,      // Read: High when data is ready on dout. Write: High when ready for another byte
        input rst,                  // Async reset
        input clk                   // Main clock
    );
    
    // Initialize the state machine
    reg [3:0]state = 0;
    
    // Extra latency flag
    reg extra_latency = 0;
    
    // Latency count reg
    reg [2:0]latency_count = 6;
    
    // Set up the clocks
    assign rclk = clk;
    assign rnclk = ~clk;
    
    // SRAM bus is bidirectional, set up input and output to be tristated
    reg [8:0] dq_out;
    wire [8:0] dq_in;
    reg sram_tx = 0;
    
    assign dq = sram_tx ? dq_out : 8'bZ;
    assign dq_in = dq;
    
    always @(negedge clk, posedge clk, posedge rst) begin
        if(rst) begin
            // Reset the state machine
            state <= 0;
            // Clear all the data that could be in the module
            datrdy <= 0;
            dout <= 0;
            // Deselect and reset the DRAM
            rncs <= 1;
            rnrst <= 0;
            // Set the module to read mode
            sram_tx <= 0;
        end
        else begin
            if (cs) begin
                case(state)
                // State 0: Activate the SRAM
                0: begin
                    $display("State 0: Activating SRAM");
                    rncs <= 0;
                    state <= 1;
                    sram_tx <= 0;
                    // Clear all the data that could be in the module
                    datrdy <= 0;
                    dout <= 0;
                end
                // State 1: Read RWDS for latency, send first CA0 byte
                1: begin
                    $display("State 1: Reading RWDS, Sending first CA0");
                    if(rwds) begin
                        $display("Chip needs extra latency");
                        extra_latency = 1;
                    end
                    // Send rw bit, address space bit, burst bit, padding for unused address
                    dq_out <= {rw,as,burst,5'b0};
                    sram_tx <= 1;
                    state <= 2;
                end
                // State 2: Send the next CA0 byte
                2: begin
                    $display("State 2: Sending second CA0 = 0b%b", {4'b0, 1'b0, row[12:10]});
                    // Send padding for unused address, 0 for die select, top 3 bits of row select
                    dq_out <= {4'b0, 1'b0, row[12:10]};
                    sram_tx <= 1;
                    state <= 3;
                end
                // State 3: Send first CA1 byte
                3: begin
                    $display("State 3: Sending first CA1 = 0b%b", {row[9:2]});
                    // Send next 8 bits of row select
                    dq_out <= {row[9:2]};
                    
                    sram_tx <= 1;
                    state <= 4;
                end
                // State 4: Send second CA1 byte
                4: begin
                    $display("State 4: Sending second CA1 = 0b%b", {row[1:0], hpage});
                    // Send last 2 bits of row select, then upper column select
                    dq_out <= {row[1:0], hpage};
                    sram_tx <= 1;
                    state <= 5;
                end
                // State 5: Send first CA2 byte
                5: begin
                    $display("State 5: Sending first CA2 = 0b%b", {8'b0});
                    // Send padding. This part is currently unused in hyperbus protocol
                    dq_out <= {8'b0};
                    sram_tx <= 1;
                    state <= 6;
                end
                // State 6: Send the second CA2 byte
                6: begin
                    $display("State 6: Sending second CA2 = 0b%b", {6'b0, word});
                    // Send 6 bits of padding, then lower column select
                    dq_out <= {6'b0, word};
                    sram_tx <= 1;
                    if(as) begin
                        $display("Register read, skipping wait state");
                        state = 8;
                    end
                    else begin
                        $display("Memory read, entering wait state");
                        state = 7;
                    end
                end
                // State 7: Wait state
                7: begin
                    $display("State 7: Wait state");
                    // Indicate that data is not ready
                    datrdy <= 0;
                    // Stop sending data
                    sram_tx <= 0;
                    // Decrement the latency count
                    latency_count = latency_count - 1;
                    $display("Latency count: %d", latency_count);
                    // Check to see if we've waited long enough
                    if(latency_count == 0) begin
                        // If the chip needed another latency period, then reset the latency count
                        if(extra_latency) begin
                            $display("Extra latency period requested");
                            latency_count <= 6;
                            extra_latency <= 0;
                            state <= 7;
                        end
                        // Otherwise, go to next state
                        else begin
                            $display("Wait loop finished");
                            state <= 8;
                        end
                    end
                end
                // State 8: Read state
                8: begin
                    $display("State 8: Read state, byte 1");
                    // Put the first byte on the output bus
                    dout <= dq_in << 8;
                    // Indicate that data is not ready yet
                    datrdy <= 0;
                    $display("dout = 0b%b", dout);
                    state <= 9;
                end
                9: begin
                    $display("State 9: Read state, byte 2");
                    // Put the second byte on the output bus
                    dout <= dout | dq_in;
                    // Indicate that there is now data ready
                    datrdy <= 1;
                    $display("dout = 0b%b", dout);
                    // Check RWDS to see if the chip needs more latency
                    if(rwds) begin
                        $display("Chip is requesting a wait state");
                        // If the chip is asking for latency, go to wait state and declare data not ready
                        state <= 7;
                    end
                    // Otherwise, read another word
                    else begin
                        state <= 8;
                     end
                end
                endcase
            end
            else begin
                $display("DRAM CS de-asserted, resetting state machine");
                state <= 0;
                rncs = 1;
            end
        end
    end
endmodule
