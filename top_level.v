`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2025 19:59:03
// Design Name: 
// Module Name: top_level
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

module top_level (
    input wire clk,
    input wire n_rst,
    input wire [23:0] grayscale_data, // Grayscale processed data
    output wire [23:0] diff_data       // Output for the frame difference
);

// Signals for Copy Module
wire copy_enable;

// Signals for BRAMs
wire [7:0] douta_bram1;  // Data output from BRAM 1 (current frame)
wire [7:0] douta_bram2;  // Data output from BRAM 2 (previous frame)

// Instantiate Copy Module
copy_module copy_inst (
    .clk(clk),
    .n_rst(n_rst),
    .copy_enable(copy_enable)
);

// Instantiate BRAM Writer 1 (Grayscale data to BRAM 1)
bram_writer bram_writer1 (
    .clk(clk),
    .rst(n_rst),
    .pixel_in(grayscale_data[7:0]),  // Grayscale pixel (8-bit)
    .vsync(1'b0),
    .hsync(1'b0),
    .copy_enable(copy_enable),       // Control signal from Copy Module
    .bram_addr(),       // BRAM address input (to be connected manually)
    .bram_data(),       // Data input for BRAM (to be connected to BRAM 1)
    .bram_we()          // Write Enable (to be connected to BRAM 1)
);

// Instantiate BRAM Writer 2 (Copy data from BRAM 1 to BRAM 2)
bram_writer bram_writer2 (
    .clk(clk),
    .rst(n_rst),
    .pixel_in(douta_bram1),  // Copying data from BRAM 1 to BRAM 2
    .vsync(1'b0),
    .hsync(1'b0),
    .copy_enable(copy_enable), // Enable writing to BRAM 2 when copy is enabled
    .bram_addr(),       // BRAM address input (to be connected manually)
    .bram_data(),       // Data input for BRAM 2
    .bram_we(copy_enable) // Enable copy to BRAM 2
);

// Instantiate Frame Diff Module
frame_diff frame_diff_inst (
    .clk(clk),
    .n_rst(n_rst),
    .i_curr_gray(douta_bram1),  // Current frame from BRAM 1
    .i_prev_gray(douta_bram2),  // Previous frame from BRAM 2
    .i_vid_hsync(1'b0),
    .i_vid_vsync(1'b0),
    .i_vid_VDE(1'b0),
    .o_vid_data(diff_data)  // Output for frame difference data
);

endmodule
