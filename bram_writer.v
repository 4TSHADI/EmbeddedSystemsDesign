`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: pcam-5c-zybo
// Module Name: bram_writer
// Project Name: pcam-5c-zybo
// Target Devices: Zybo Z7 20
//////////////////////////////////////////////////////////////////////////////////

module bram_writer (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_in,    // Input pixel data (8 bits)
    input wire vsync,              // Vertical sync signal
    input wire hsync,              // Horizontal sync signal
    input wire copy_enable,        // Enable signal to start copying to BRAM 2
    output reg [13:0] bram_addr,   // Address for BRAM write
    output reg [7:0] bram_data,    // Data to be written to BRAM
    output reg bram_we             // Write Enable for BRAM
);

    reg [13:0] pixel_index;  // Pixel index counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pixel_index <= 0;
            bram_we <= 0;  // Disable BRAM write on reset
        end else if (vsync) begin
            pixel_index <= 0;  // Reset pixel index at the start of a new frame
        end else begin
            if (copy_enable) begin
                bram_data <= pixel_in;  // Copy the pixel data to BRAM
                bram_addr <= pixel_index;  // Use pixel index as BRAM address
                bram_we <= 1'b1;  // Enable write to BRAM
            end else begin
                bram_we <= 0;  // No write if copying is not enabled
            end
            pixel_index <= pixel_index + 1;  // Increment pixel index for next pixel
        end
    end
endmodule
