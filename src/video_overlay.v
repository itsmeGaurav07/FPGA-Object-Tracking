// video_overlay.v
`timescale 1ns / 1ps

module video_overlay#(
    parameter H_ACTIVE = 640,
    parameter V_ACTIVE = 480
)(
    input wire clk,
    input wire rst,
    input wire h_sync,
    input wire v_sync,
    input wire [23:0] pixel_in,
    input wire [15:0] bbox_x_min,
    input wire [15:0] bbox_x_max,
    input wire [15:0] bbox_y_min,
    input wire [15:0] bbox_y_max,

    output reg [23:0] pixel_out
);

    reg [15:0] x_coord;
    reg [15:0] y_coord;

    // Track current pixel coordinates
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_coord <= 0;
            y_coord <= 0;
        end else if (v_sync) begin
            if (h_sync) begin
                if (x_coord == H_ACTIVE - 1) begin
                    x_coord <= 0;
                    y_coord <= y_coord + 1;
                end else begin
                    x_coord <= x_coord + 1;
                end
            end
        end else begin
            x_coord <= 0;
            y_coord <= 0;
        end
    end

    // Bounding box color (Red)
    parameter BOX_COLOR = 24'hFF0000; 

    // Logic to draw the box
    always @(*) begin
        // Check if the current coordinate is on the box's horizontal or vertical lines
        if (h_sync && v_sync &&
           (((x_coord >= bbox_x_min && x_coord <= bbox_x_max) && (y_coord == bbox_y_min || y_coord == bbox_y_max)) || 
            ((y_coord >= bbox_y_min && y_coord <= bbox_y_max) && (x_coord == bbox_x_min || x_coord == bbox_x_max)))) begin
            pixel_out = BOX_COLOR;
        end else begin
            pixel_out = pixel_in;
        end
    end

endmodule