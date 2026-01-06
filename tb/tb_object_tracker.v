// tb_object_tracker.v
`timescale 1ns / 1ps

module tb_object_tracker;

    // Testbench parameters
    parameter H_RES = 10;
    parameter V_RES = 10;
    parameter CLK_PERIOD = 10; // 100 MHz clock

    // Inputs to DUT
    reg clk;
    reg rst;
    reg h_sync;
    reg v_sync;
    reg [23:0] pixel_in;

    // Output from DUT
    wire [23:0] pixel_out;

    // Instantiate the DUT (Device Under Test)
    object_tracker_top #(
        .H_ACTIVE(H_RES),
        .V_ACTIVE(V_RES)
    ) dut (
        .clk(clk),
        .rst(rst),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );

// Correct clock generator
    always #(CLK_PERIOD/2) clk = ~clk;

    // Main simulation block
  // Main simulation block
    initial begin
        // Initialize signals
        clk = 0; // <-- ADD THIS LINE BACK
        rst = 1;
        h_sync = 0;
        v_sync = 0;
        pixel_in = 24'h000000; // Black
    
        // Apply reset
        #20;
        rst = 0;
        // ... rest of the code
        #10;
        
        $display("Starting simulation...");

        // Start of frame
        v_sync = 1;
        
        // Loop through each pixel of the frame
        for (integer y = 0; y < V_RES; y = y + 1) begin
            h_sync = 1;
            for (integer x = 0; x < H_RES; x = x + 1) begin
                
                // Create a bright 3x3 square from (3,3) to (5,5)
                // This is the line to check
                 if (x >= 3 && x <= 5 && y >= 3 && y <= 5) begin
                    pixel_in = 24'hFFFFFF; // White (will be detected as feature)
                end else begin
                    pixel_in = 24'h101010; // Dark Gray
                end
                
                #(CLK_PERIOD);
            end
            h_sync = 0; // Horizontal blanking period
            #(CLK_PERIOD * 2); 
        end
        v_sync = 0; // Vertical blanking period
        
        $display("Frame finished. Bounding box should be calculated.");
        #100;
        
        $display("Simulation complete.");
        $finish;
    end

endmodule