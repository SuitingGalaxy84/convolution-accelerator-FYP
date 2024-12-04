module Multiplier_2 #(
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire rstn,
    input wire en,
    input wire [DATA_WIDTH-1:0] a, // DATA_WIDTH-bit input A
    input wire [DATA_WIDTH-1:0] b, // DATA_WIDTH-bit input B
    output wire [2*DATA_WIDTH-1:0] result// 2*DATA_WIDTH-bit result
);

    // Pipeline registers
    reg [DATA_WIDTH-1:0] a_reg1, b_reg1;
    reg [2*DATA_WIDTH-1:0] result_reg;   // Stage 1 pipeline registers
    assign result = result_reg;
    // Stage 1: Capture inputs and compute partial products
    always @(posedge clk or negedge rstn) begin
        if (~rstn || ~en) begin
            a_reg1 <= {DATA_WIDTH{1'b0}};
            b_reg1 <= {DATA_WIDTH{1'b0}};
            result_reg <= {2*DATA_WIDTH-1{1'b0}};
        end else begin
            a_reg1 <= a;
            b_reg1 <= b;
            result_reg <= a*b;
        end
    end


endmodule