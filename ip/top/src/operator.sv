`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Operator
// Module Name: conv_operator
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

module conv_operator#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512
)(
    input clk,
    input pe_clk,
    input rstn,
    input [7:0] kernel_size,
    output [2*DATA_WIDTH-1:0] ofmap_out
);
    
    PEA_control #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .BUFFER_SIZE(BUFFER_SIZE)
    ) CU_insts (
        .clk(clk),
        .rstn(rstn),

        .load_ifmap(load_ifmap),
        .load_fltr(load_fltr),
        .load_psum(load_psum),
        .load_done(load_done),

        .start(start),
        .flush_tag(flush_tag),
        .flush_kernel(flush_kernel),

        .ram_rst_busy(ram_rst_busy),
        .tag_busy(tag_busy),
        .kernel_busy(kernel_busy),
        .ram_load_busy(ram_load_busy),
        .full(full)
    );

    

    wire load_ifmap, load_fltr, load_psum;
    wire flush_tag, flush_kernel;
    wire [NUM_ROW-1:0] start;
    wire ram_rst_busy, tag_busy, kernel_busy, ram_load_busy, full;
    wire [2*DATA_WIDTH-1:0] opsum [NUM_COL-1:0];
    YBUS_IF#(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW), .BUFFER_SIZE(BUFFER_SIZE)) YBUS_IF_insts();
    
    data_collector#(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL)
    )(
        .clk(clk),
        .pe_clk(pe_clk),
        .rstn(rstn),
        .data_in(opsum),
        .data_out(ofmap_out)
    );
    pe_array_configurable #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .BUFFER_SIZE(BUFFER_SIZE)
    ) PE_array_insts (
        .clk(clk),
        .pe_clk(pe_clk),
        .rstn(rstn),

        .load_ifmap(load_ifmap),
        .load_fltr(load_fltr),
        .load_psum(load_psum),
        
        .flush_tag(flush_tag),
        .flush_kernel(flush_kernel),

        .kernel_size(kernel_size),

        .start(start),
        
        .ram_rst_busy(ram_rst_busy),
        .tag_busy(tag_busy),
        .kernel_busy(kernel_busy),
        .ram_load_busy(ram_load_busy),
        .full(full),
        
        .opsum(opsum),
        .YBUS_IF_insts(YBUS_IF_insts)
    );

    DataFeeder #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .BUFFER_SIZE(BUFFER_SIZE)
    ) DataFeeder_insts (
        .clk(clk),
        .rstn(rstn),
        .YBUS_IF_insts(YBUS_IF_insts)
    );
endmodule
