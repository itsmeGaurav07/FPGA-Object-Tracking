// object_tracker_top.v
`timescale 1ns / 1ps

module object_tracker_top#(
    parameter H_ACTIVE = 640,
    parameter V_ACTIVE = 480
)(
    input wire clk,
    input wire rst,
    input wire h_sync,
    input wire v_sync,
    input wire [23:0] pixel_in,
    
    output wire [23:0] pixel_out
);

    // Internal wires
    wire [7:0]  gray_pixel;
    wire        feature_detected;
    wire [15:0] bbox_x_min_wire, bbox_x_max_wire;
    wire [15:0] bbox_y_min_wire, bbox_y_max_wire;

    // Instantiate Grayscale Converter
    grayscale_converter u_grayscale (
        .rgb_in     (pixel_in),
        .gray_out   (gray_pixel)
    );

    // Instantiate Feature Detector
    feature_detector u_detector (
        .gray_in    (gray_pixel),
        .is_feature (feature_detected)
    );

    // Instantiate Bounding Box Generator
    bounding_box_generator #(
        .H_ACTIVE(H_ACTIVE),
        .V_ACTIVE(V_ACTIVE)
    ) u_bbox_gen (
        .clk        (clk),
        .rst        (rst),
        .is_feature (feature_detected),
        .h_sync     (h_sync),
        .v_sync     (v_sync),
        .bbox_x_min (bbox_x_min_wire),
        .bbox_x_max (bbox_x_max_wire),
        .bbox_y_min (bbox_y_min_wire),
        .bbox_y_max (bbox_y_max_wire)
    );

    // Instantiate Video Overlay
    video_overlay #(
        .H_ACTIVE(H_ACTIVE),
        .V_ACTIVE(V_ACTIVE)
    ) u_overlay (
        .clk        (clk),
        .rst        (rst),
        .h_sync     (h_sync),
        .v_sync     (v_sync),
        .pixel_in   (pixel_in),
        .bbox_x_min (bbox_x_min_wire),
        .bbox_x_max (bbox_x_max_wire),
        .bbox_y_min (bbox_y_min_wire),
        .bbox_y_max (bbox_y_max_wire),
        .pixel_out  (pixel_out)
    );

endmodule