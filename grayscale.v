`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 
// Design Name: pcam-5c-zybo
// Module Name: colour_change
// Project Name: pcam-5c-zybo
// Target Devices: Zybo Z7 20
// 
// Dependencies: N/A 
//////////////////////////////////////////////////////////////////////////////////


module greyscale #
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

    /*
     * Pixel output
     */
    output reg [7:0] o_vid_data,
    output reg                  o_vid_hsync,
    output reg                  o_vid_vsync,
    output reg                  o_vid_VDE,
  
    /*
     * Control
     */
    input wire [3:0]            btn  
);

wire enable;
wire [7:0] red;
wire [7:0] blu;
wire [7:0] gre;
reg [7:0] grey;
//reg [7:0] threshold = 8'd128;

assign {red, blu, gre} = i_vid_data;
assign enable = btn[0];
//assign threshhold_enable = btn[1];

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

        grey <= (red*299 + gre*587 + blu*114) /1000;
        o_vid_data <= grey;
        
    end
end

endmodule