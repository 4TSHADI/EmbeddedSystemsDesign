`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 09.04.2019 
// Design Name: pcam-5c-zybo
// Module Name: grayscale
// Project Name: pcam-5c-zybo
// Target Devices: Zybo Z7 20
// Tool Versions: Vivado 2017.4
// Description: RGB to grayscale Module (vid_io)
// 
// Dependencies: N/A
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module thresholding #
(
    parameter DATA_WIDTH = 24 // 8 bits for R, G & B
)
(
    input  wire                   clk,
    input  wire                   n_rst,

    /*
     * Pixel inputs
     */
    input  wire [DATA_WIDTH-1:0] i_vid_data,
    input  wire                  i_vid_hsync,
    input  wire                  i_vid_vsync,
    input  wire                  i_vid_VDE,
    input  wire [7:0]            i_curr_grey,
    input  wire [7:0]            i_prev_grey,

    /*
     * Pixel output
     */
    output reg [DATA_WIDTH-1:0] o_vid_data,
    output reg                  o_vid_hsync,
    output reg                  o_vid_vsync,
    output reg                  o_vid_VDE,
    
    /*
     * Control
     */
    input wire [3:0]            btn
);

wire enable;
reg [7:0] diff;
parameter threshold = 8'd128;
assign threshhold_enable = btn[1];

always @ (posedge clk) begin
    if(!n_rst) begin
        o_vid_hsync <= 0;
        o_vid_vsync <= 0; 
        o_vid_VDE <= 0;
        o_vid_data <= 0;
    end
    else begin
        o_vid_hsync <= i_vid_hsync;
        o_vid_vsync <= i_vid_vsync; 
        o_vid_VDE <= i_vid_VDE;
        if(threshhold_enable) begin
            diff <= (i_curr_grey > i_prev_grey) ? (i_curr_grey - i_prev_grey) : (i_prev_grey - i_curr_grey);
            if (diff > threshold)begin
                o_vid_data <= {8'd255, 8'd0, 8'd0};
            end 
            else begin
                o_vid_data <= i_vid_data;
            
            end      
        end
    end
end

endmodule