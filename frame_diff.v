`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Frame Differencing Module
// Design Name: pcam-5c-zybo
// Module Name: frame_diff
//////////////////////////////////////////////////////////////////////////////////

module frame_diff #
(
    parameter DATA_WIDTH = 24,            // Pixel data width
    parameter ADDR_WIDTH = 14,            // Address width for BRAM (depends on resolution)
    parameter DIFF_THRESHOLD = 8         // Motion detection threshold
)
(
    input  wire                       clk,         // Clock signal
    input  wire                       n_rst,       // Active-low reset

    // Video sync signals
    input  wire                       i_vid_hsync, // Horizontal sync
    input  wire                       i_vid_vsync, // Vertical sync
    input  wire                       i_vid_VDE,   // Video Data Enable

    // Grayscale pixel input (current frame)
    input  wire [7:0]                 i_curr_gray, // Current pixel in grayscale

    // BRAMs for storing the previous frame (previous frame data)
    input  wire [7:0]                 i_prev_gray, // Previous frame data from BRAM

    // BRAM addresses (pixel location in the image)
    input  wire [ADDR_WIDTH-1:0]      pixel_addr,  // Address of the current pixel

    // Output to video encoder or display
    output reg [23:0]                 o_vid_data,  // Output video data (highlighted motion or grayscale)
    output reg                        o_vid_hsync, // Output horizontal sync
    output reg                        o_vid_vsync, // Output vertical sync
    output reg                        o_vid_VDE     // Output Video Data Enable
);

    reg [7:0] diff;                 // Pixel difference
    reg [23:0] motion_color;        // Color for motion (e.g., bright red)
    reg motion_detected;            // Flag indicating motion detected

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            o_vid_data  <= 24'd0;
            o_vid_hsync <= 1'b0;
            o_vid_vsync <= 1'b0;
            o_vid_VDE   <= 1'b0;
            motion_detected <= 1'b0;
        end else begin
            // Pass-through the sync signals (hsync, vsync, VDE)
            o_vid_hsync <= i_vid_hsync;
            o_vid_vsync <= i_vid_vsync;
            o_vid_VDE   <= i_vid_VDE;

            // Process frame differencing only when VDE is high (valid video data)
            if (i_vid_VDE) begin
                // Calculate the absolute difference between current and previous pixel
                diff <= (i_curr_gray > i_prev_gray) ? 
                            (i_curr_gray - i_prev_gray) : 
                            (i_prev_gray - i_curr_gray);

                // If the difference exceeds the threshold, consider it as motion
                if (diff > DIFF_THRESHOLD) begin
                    motion_detected <= 1'b1;
                    motion_color <= 24'hFF0000; // Red color for motion detection
                end else begin
                    motion_detected <= 1'b0;
                    motion_color <= 24'h000000; // No motion (black)
                end
            end else begin
                o_vid_data <= 24'd0;
            end

            // Output video data based on motion detection
            if (motion_detected) begin
                o_vid_data <= motion_color; // Highlight motion with red color
            end else begin
                o_vid_data <= {diff, diff, diff}; // Grayscale output
            end
        end
    end
endmodule
