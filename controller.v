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
module frame_toggle (
    input wire clk,
    input wire n_rst,
    input wire trigger,  // Toggle trigger (e.g., from a button or frame done signal)
    output reg toggle
);
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            toggle <= 0;
        end
        else if (trigger) begin
            toggle <= ~toggle;  // Toggle the frame role
        end
    end
endmodule
