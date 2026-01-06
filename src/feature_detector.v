// feature_detector.v
`timescale 1ns / 1ps

module feature_detector(
    input wire [7:0] gray_in,
    output wire      is_feature
);

    // Any pixel with a grayscale value over 200 is a "feature"
    parameter FEATURE_THRESHOLD = 8'd200; 

    assign is_feature = (gray_in > FEATURE_THRESHOLD);

endmodule