`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Cross Clock Domain Wrapper
// Module Name: SV_CCDWrapper
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

module SV_CCDWrapper#(
    parameter DATA_WIDTH,
    parameter FIFO_DEPTH, 
)(
    input wire rstn,
    input wire bus_clk,
    input wire pe_clk,
    input wire external,

    output 

    input wire [DATA_WIDTH-1:0] ifmap_data_M2CCD,
    output wire [DATA_WIDTH-1:0] ifmap_data_CCD2P

    input wire [DATA_WIDTH-1:0] fltr_data_M2CCD,
    output wire [DATA_WIDTH-1:0] fltr_data_CCD2P

    input wire [2*DATA_WIDTH-1:0] opsum_data_M2CCD,
    output wire [2*DATA_WIDTH-1:0] opsum_data_CCD2P,

    input wire [2*DATA_WIDTH-1:0] ipsum_data_M2CCD,
    output wire [2*DATA_WIDTH-1:0] ipsum_data_CCD2P,

);
    async_fifo_gen(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
    ) ifmap_data_ccd (
        .wr_clk(bus_clk),
        .wr_rstn(rstn),
        .wr_en(),
        .wr_data(ifmap_data_M2CCD),
        .full(),
        .pre_fill_done()

        .rd_clk(pe_clk),
        .rd_rstn(rstn),
        .rd_en(),
        .rd_data(ifmap_data_CCD2P),
        .empty(),
        .pre_fill_done_sync()
    )

    async_fifo_gen(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
    ) fltr_data_ccd (
        .wr_clk(bus_clk),
        .wr_rstn(rstn),
        .wr_en(),
        .wr_data(fltr_data_M2CCD),
        .full(),
        .pre_fill_done()

        .rd_clk(pe_clk),
        .rd_rstn(rstn),
        .rd_en(),
        .rd_data(fltr_data_CCD2P),
        .empty(),
        .pre_fill_done_sync()
    )

    async_fifo_gen(
        .DATA_WIDTH(2*DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
    ) opsum_data_ccd (
        .wr_clk(pe_clk),
        .wr_rstn(rstn),
        .wr_en(),
        .wr_data(opsum_data_CCD2P),
        .full(),
        .pre_fill_done()

        .rd_clk(bus_clk),
        .rd_rstn(rstn),
        .rd_en(),
        .rd_data(opsum_data_M2CCD),
        .empty(),
        .pre_fill_done_sync()
    ),

    async_fifo_gen(
        .DATA_WIDTH(2*DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
    ) ipsum_data_ccd (
        .wr_clk(pe_clk),
        .wr_rstn(rstn),
        .wr_en(),
        .wr_data(ipsum_data_CCD2P),
        .full(),
        .pre_fill_done()

        .rd_clk(bus_clk),
        .rd_rstn(rstn),
        .rd_en(),
        .rd_data(ipsum_data_M2CCD),
        .empty(),
        .pre_fill_done_sync()
    )

endmodule