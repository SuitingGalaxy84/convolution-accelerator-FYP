`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Data Encoder
// Module Name: Data_Enc
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: Processing Element for Convolution Accelerator
/*
    This module encode the data for the XY-NoC bus in a format <row, col, data> format
*/
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

module Data_Enc #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4,
    parameter NUM_ROW = 4
)(
    input clk,
    input rstn,
    input [7:0] COV_EN,
    input [7:0] kernel_size, // kernel_size must no larger than both NUM_COL and NUM_ROW
    input [7:0] num_channel,
    FIFO_IF.FIFO_port FIFO_IF,

    output []
);  
    
    reg [$clog2(NUM_COL):0] COL_ID; // extended by 1 bit
    reg [$clog2(NUM_ROW):0] ROW_ID; // extended by 1 bit
    reg [2*DATA_WIDTH-1:0] data;

    reg [2*DATA_WIDTH-1:0] pip_reg [NUM_ROW-1:0];
    



endmodule 
