`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: weight buffer driver
// Module Name: WeightBuff_driver
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: Processing Element for Convolution Accelerator
/*
    
*/
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module WeightBuff_driver #(
    parameter DATA_WIDTH = 16, 
    parameter CLK_PERIOD = 10
)(
    output reg clk,
    input rstn, 
    output [DATA_WIDTH-1:0] data_in,
    input flush,
    input flush_BUSY
);
    parameter MAX_NUM = 2^(DATA_WIDTH) - 1;
    parameter MIN_NUM = 0;


    reg [DATA_WIDTH-1:0] data_in_reg;
    assign data_in = flush_BUSY ? data_in_reg : 0;
    initial begin
        clk = 1;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            data_in_reg <= 0;
        end else begin
            data_in_reg <= $urandom_range(MIN_NUM, MAX_NUM);
        end
    end 


endmodule