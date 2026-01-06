// bounding_box_generator.v
`timescale 1ns / 1ps

module bounding_box_generator#(
    parameter H_ACTIVE = 640, // Horizontal resolution
    parameter V_ACTIVE = 480  // Vertical resolution
)(
    input wire clk,
    input wire rst,
    input wire is_feature,
    input wire h_sync, // High when scanning a line
    input wire v_sync, // High for a valid frame

    output reg [15:0] bbox_x_min,
    output reg [15:0] bbox_x_max,
    output reg [15:0] bbox_y_min,
    output reg [15:0] bbox_y_max
);

    reg [15:0] x_coord;
    reg [15:0] y_coord;
    reg first_feature_found;

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

    // Logic to calculate bounding box
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bbox_x_min <= H_ACTIVE;
            bbox_x_max <= 0;
            bbox_y_min <= V_ACTIVE;
            bbox_y_max <= 0;
            first_feature_found <= 1'b0;
        end else begin
            // Reset at the start of a new frame (falling edge of vsync)
            if (!v_sync) begin
                bbox_x_min <= H_ACTIVE;
                bbox_x_max <= 0;
                bbox_y_min <= V_ACTIVE;
                bbox_y_max <= 0;
                first_feature_found <= 1'b0;
            end 
            // If a feature is detected in the active frame
            else if (is_feature && h_sync) begin
                if (!first_feature_found) begin
                    // This is the first feature, initialize all coords
                    bbox_x_min <= x_coord;
                    bbox_x_max <= x_coord;
                    bbox_y_min <= y_coord;
                    bbox_y_max <= y_coord;
                    first_feature_found <= 1'b1;
                end else begin
                    // Update min/max values
                    if (x_coord < bbox_x_min) bbox_x_min <= x_coord;
                    if (x_coord > bbox_x_max) bbox_x_max <= x_coord;
                    if (y_coord < bbox_y_min) bbox_y_min <= y_coord;
                    if (y_coord > bbox_y_max) bbox_y_max <= y_coord;
                end
            end
        end
    end

endmodule