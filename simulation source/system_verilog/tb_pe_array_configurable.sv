`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Testbench for Configurable PE Array
// Module Name: tb_pe_array_configurable 
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

module tb_pe_array_configurable #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512
)();

    parameter CLK_PERIOD = 10;
    parameter PE_CLK_PERIOD = CLK_PERIOD * NUM_COL;

    parameter KERNEL_SIZE = 5;
    parameter BUFFER_SIZE = 512;


    /*
        initialized clock signals 
    */

    reg clk, pe_clk, rstn;

    initial begin
        clk = 1;
        forever #(CLK_PERIOD/2) clk = ~clk; 
    end
    initial begin
        pe_clk = 0;
        forever #(PE_CLK_PERIOD/2) pe_clk = ~pe_clk;
    end

    /*
        initialized control signals
    */
    reg [NUM_ROW-1:0] load_ifmap, load_fltr, load_psum;
    reg [NUM_ROW-1:0] flush_tag, flush_kernel;
    reg [7:0] kernel_size;
    reg [NUM_ROW-1:0] start;

    /*
        initialized status signals
    */
    wire [NUM_ROW-1:0] ram_rst_busy, tag_busy, kernel_busy;
    wire [NUM_ROW-1:0] ram_load_busy;
    wire [NUM_ROW-1:0] full;
    pe_array_configurable #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW), .BUFFER_SIZE(BUFFER_SIZE)) pe_array_inst(
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

        .YBUS_IF_insts()
    );
endmodule