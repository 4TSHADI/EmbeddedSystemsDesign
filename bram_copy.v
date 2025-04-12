`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: pcam-5c-zybo
// Module Name: copy_module
// Project Name: pcam-5c-zybo
// Target Devices: Zybo Z7 20
//////////////////////////////////////////////////////////////////////////////////

module copy_module (
    input wire clk,
    input wire n_rst,
    output reg copy_enable // Signal to enable copying to BRAM 2 every clock cycle
);

    // State definitions for state machine using localparam
    localparam IDLE    = 2'b00;
    localparam COPY    = 2'b01;

    reg [1:0] current_state, next_state;

    // State machine to manage the copy operation
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        // Default values for next state and copy enable signal
        next_state = current_state;
        copy_enable = 0;

        case (current_state)
            IDLE: begin
                next_state = COPY;  // Immediately start copy operation on the next clock cycle
            end
            COPY: begin
                copy_enable = 1;  // Enable copy operation
                next_state = COPY; // Stay in COPY state for continuous copying
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
