`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global Processing Element Driver
// Module Name: SV_glb_PE_driver
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

module SV_glb_PE_driver #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4,
    parameter CLK_PERIOD = 10
    )(
        output reg clk,
        input rstn,
        BUS_IF.BUS_port BUS_IF,
        input [$clog2(NUM_COL):0] ID, // extended by 1 bit
        input [$clog2(NUM_COL):0] TAG, // extended by 1 bit
        input READY,
        input EN,
        input [7:0] kernel_size
    );
    
    localparam MAX_NUM = 2^(DATA_WIDTH) - 1;
    localparam MIN_NUM = 1;
    reg [DATA_WIDTH-1:0] ifmap_data_B2M;
    reg [DATA_WIDTH-1:0] fltr_data_B2M;
    reg [2*DATA_WIDTH-1:0] psum_data_B2M;
    assign BUS_IF.ifmap_data_B2M = ifmap_data_B2M;
    assign BUS_IF.fltr_data_B2M = fltr_data_B2M;
    assign BUS_IF.psum_data_B2M = psum_data_B2M;
    assign BUS_IF.ID = ID;
    assign BUS_IF.TAG = TAG;
    assign BUS_IF.READY = READY;
    assign BUS_IF.CASTER_EN = EN;
    assign BUS_IF.kernel_size = kernel_size;
    
    initial begin
        clk = 1'b1;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    always_ff @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ifmap_data_B2M <= 0;
            fltr_data_B2M <= 0;
            psum_data_B2M <= 0;
        end
        else begin
            ifmap_data_B2M <= $urandom_range(MIN_NUM, MAX_NUM);
            fltr_data_B2M <= $urandom_range(MIN_NUM, MAX_NUM);
            psum_data_B2M <= $urandom_range(MIN_NUM, MAX_NUM);
        end
    end

endmodule