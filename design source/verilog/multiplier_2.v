module Multiplier_2 #(
    parameter DATA_WIDTH = 32
)(
    input wire clk,
    input wire rst,
    input wire [DATA_WIDTH-1:0] a, // DATA_WIDTH-bit input A
    input wire [DATA_WIDTH-1:0] b, // DATA_WIDTH-bit input B
    output reg [2*DATA_WIDTH-1:0] result // 2*DATA_WIDTH-bit result
);

    // Pipeline registers
    reg [DATA_WIDTH-1:0] a_reg1, b_reg1;  // Stage 1 pipeline registers
    reg [2*DATA_WIDTH-1:0] partial_result_reg; // Stage 2 pipeline register

    // Stage 1: Capture inputs and compute partial products
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg1 <= {DATA_WIDTH{1'b0}};
            b_reg1 <= {DATA_WIDTH{1'b0}};
        end else begin
            a_reg1 <= a;
            b_reg1 <= b;
        end
    end

    // Stage 2: Complete multiplication and store the result
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_result_reg <= {2*DATA_WIDTH{1'b0}};
            result <= {2*DATA_WIDTH{1'b0}};
        end else begin
            partial_result_reg <= a_reg1 * b_reg1; // Perform multiplication
            result <= partial_result_reg; // Final result
        end
    end

endmodule