`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Data Feeder
// Module Name: DataFeeder
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

`include "interface.sv"

module DataFeeder#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512,
    parameter DATA_TYPES = 3
)(
    input clk,
    input rstn,
    input [2*DATA_WIDTH+$clog2(NUM_COL)+$clog2(NUM_ROW)+$clog2(DATA_TYPES)+2:0] data_in,
    YBUS_IF.EXTRNL_port YBUS_IF_insts
);
    
    localparam IDEL = 2'b00;
    localparam IFMAP = 2'b01;
    localparam FLTR = 2'b10;
    localparam PSUM = 2'b11;
    
    wire [$clog2(DATA_TYPES)-1:0] data_type;
    assign data_type = data_in[$clog2(DATA_TYPES)-1:0];
    
    
    reg [$clog2(BUFFER_SIZE)-1:0] ifmap_addr;
    reg [$clog2(BUFFER_SIZE)-1:0] fltr_addr;
    reg [$clog2(BUFFER_SIZE)-1:0] psum_addr;

    reg[DATA_WIDTH + $clog2(NUM_COL):0] ifmap_data;
    reg[DATA_WIDTH + $clog2(NUM_COL):0] fltr_data;
    reg[DATA_WIDTH + $clog2(NUM_COL):0] psum_data;

    always_ff@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            ifmap_addr <= 0;
            fltr_addr <= 0;
            psum_addr <= 0;

            ifmap_data <= 0;
            fltr_data <= 0;
            psum_data <= 0;
        end else begin
            ifmap_addr <= ifmap_addr + 1;
            fltr_addr <= fltr_addr + 1;
            psum_addr <= psum_addr + 1;

            ifmap_data <= YBUS_IF_insts.ifmap_data;
            fltr_data <= YBUS_IF_insts.fltr_data;
            psum_data <= YBUS_IF_insts.psum_data;
        end
    end 
    

    assign YBUS_IF_insts.ifmap_data = ifmap_data;
    assign YBUS_IF_insts.fltr_data = fltr_data;
    assign YBUS_IF_insts.psum_data = psum_data;

    assign YBUS_IF_insts.ifmap_addr = ifmap_addr;
    assign YBUS_IF_insts.fltr_addr = fltr_addr;
    assign YBUS_IF_insts.psum_addr = psum_addr;


endmodule