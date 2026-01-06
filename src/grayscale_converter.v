// grayscale_converter.v
`timescale 1ns / 1ps

module grayscale_converter(
    input  wire [23:0] rgb_in,
    output reg  [7:0]  gray_out
);

    wire [7:0] r, g, b;
    assign r = rgb_in[23:16];
    assign g = rgb_in[15:8];
    assign b = rgb_in[7:0];

    // Using integer arithmetic for hardware synthesis:
    // gray = 0.299*R + 0.587*G + 0.114*B
    // gray = (77*R + 150*G + 29*B) / 256
    always @(*) begin
        gray_out = (r * 77 + g * 150 + b * 29) >> 8;
    end

endmodule