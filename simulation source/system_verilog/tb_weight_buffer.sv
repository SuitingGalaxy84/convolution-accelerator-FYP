`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: testbench for weight buffer
// Module Name: tb_WeightBuff
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
/////////////////////////////

module tb_WeightBuff #(
    parameter DATA_WIDTH = 16,
    parameter CLK_PERIOD = 10,
    parameter BUFFER_DEPTH = 16
)();

    wire [DATA_WIDTH-1:0] data_in;
    reg clk;
    reg rstn;
    reg flush;
    reg en;

    wire flush_VALID;
    wire read_VALID;

    reg [7:0] kernel_size;
    wire [DATA_WIDTH-1:0] data_out;
    
    WeightBuff_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .CLK_PERIOD(CLK_PERIOD)
    ) WeightBuff_driver(
        .clk(clk),
        .rstn(rstn),
        .data_in(data_in),
        .flush(flush)
    );

    WeightBuff #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) WeightBuff(
        .clk(clk),
        .rstn(rstn),
        .flush(flush),
        .kernel_size(kernel_size),
        .data_in(data_in),
        .data_out(data_out),
        .pseusdo_out(),
        .flush_VALID(flush_VALID),
        .read_VALID(read_VALID)
        .en(en)
    );
endmodule 