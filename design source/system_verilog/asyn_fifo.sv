`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Asynchronous FIFO
// Module Name: AsyncFIFO
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
/*
 
 */
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

module AsyncFIFO #(
    parameter DATA_WIDTH = 8,   // Width of the data
    parameter FIFO_DEPTH = 16  // Depth of the FIFO (must be a power of 2)
)(
    input wire                   wr_clk,   // Write clock
    input wire                   rd_clk,   // Read clock
    input wire                   rst,      // Asynchronous reset
    input wire                   wr_en,    // Write enable
    input wire                   rd_en,    // Read enable
    input wire [DATA_WIDTH-1:0]  wr_data,  // Data to write
    output reg [DATA_WIDTH-1:0]  rd_data,  // Data read
    output wire                  full,     // FIFO full flag
    output wire                  empty     // FIFO empty flag

);

    // Depth should be a power of 2 for pointer wrapping to work efficiently
    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

    // FIFO memory
    reg [DATA_WIDTH-1:0] fifo_mem[FIFO_DEPTH-1:0];

    // Write and read pointers
    reg [ADDR_WIDTH:0] wr_ptr = 0;  // Write pointer (ADDR_WIDTH+1 for gray encoding)
    reg [ADDR_WIDTH:0] rd_ptr = 0;  // Read pointer (ADDR_WIDTH+1 for gray encoding)

    // Synchronized pointers
    reg [ADDR_WIDTH:0] wr_ptr_gray_wr = 0, wr_ptr_gray_rd1 = 0, wr_ptr_gray_rd2 = 0;
    reg [ADDR_WIDTH:0] rd_ptr_gray_rd = 0, rd_ptr_gray_wr1 = 0, rd_ptr_gray_wr2 = 0;

    // Gray code conversion
    function [ADDR_WIDTH:0] to_gray(input [ADDR_WIDTH:0] bin);
        to_gray = bin ^ (bin >> 1);
    endfunction

    function [ADDR_WIDTH:0] gray_to_bin(input [ADDR_WIDTH:0] gray);
        integer i;
        begin
            gray_to_bin = 0;
            for (i = 0; i <= ADDR_WIDTH; i = i + 1)
                gray_to_bin[i] = ^(gray >> i);
        end
    endfunction

    // Write logic
    always_ff@(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read logic
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Pointer synchronization
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_wr1 <= 0;
            rd_ptr_gray_wr2 <= 0;
        end else begin
            rd_ptr_gray_wr1 <= to_gray(rd_ptr);
            rd_ptr_gray_wr2 <= rd_ptr_gray_wr1;
        end
    end

    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_rd1 <= 0;
            wr_ptr_gray_rd2 <= 0;
        end else begin
            wr_ptr_gray_rd1 <= to_gray(wr_ptr);
            wr_ptr_gray_rd2 <= wr_ptr_gray_rd1;
        end
    end

    // Full and empty flags
    assign full  = (to_gray(wr_ptr) == {~rd_ptr_gray_wr2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_wr2[ADDR_WIDTH-2:0]});
    assign empty = (to_gray(rd_ptr) == wr_ptr_gray_rd2);

endmodule