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

//FIXME: PE_EN is the signal to enable the data in the buffer
//FIXME: READY is the signal to enable the data out of the buffer

module SV_CCD_Buffer#(
    parameter DATA_WIDTH,
    parameter FIFO_DEPTH
)(
    input wire rstn,
    input wire bus_clk,
    input wire pe_clk,
    
    output kernel_rden,
    output wire overflow,
    output wire empty,
    output wire buffer_busy,
    output wire buffer_busy_sync,

    PE_IF.PE_port MC_BUFFER,
    PE_IF.MC_port PE_BUFFER
);
    
    wire ifmap_overflow;
    wire fltr_overflow;
    wire psum_overflow;

    wire ifmap_empty;
    wire fltr_empty;
    wire psum_empty;

    wire buffer_busy_ifmap;
    wire buffer_busy_fltr;
    wire buffer_busy_psum;

    wire buffer_busy_sync_ifmap;
    wire buffer_busy_sync_fltr;
    wire buffer_busy_sync_psum;

    assign buffer_busy = ~buffer_busy_ifmap || ~buffer_busy_fltr || ~buffer_busy_psum;
    assign buffer_busy_sync = ~buffer_busy_sync_ifmap || ~buffer_busy_sync_fltr || ~buffer_busy_sync_psum;

    assign overflow = ifmap_overflow || fltr_overflow || psum_overflow;
    assign empty = ifmap_empty || fltr_empty || psum_empty;
    assign kernel_rden = rd_en;

    pulse_accumulator rd_en_synchronizer (
        .fast_clk(bus_clk),
        .fast_pulse(MC_BUFFER.PE_EN),
        .rstn(rstn),
        
        .slow_clk(pe_clk),
        .slow_pulse(rd_en)
    );
    
    wire [DATA_WIDTH-1:0] ifmap_rd_data;
    wire [2*DATA_WIDTH-1:0] psum_rd_data;
    
    async_fifo_with_prefill #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) IFMAP_FIFO(
        .wr_clk(bus_clk),
        .wr_rstn(rstn),
        .wr_en(MC_BUFFER.PE_EN),
        .wr_data(MC_BUFFER.ifmap_data_M2P),
        .full(ifmap_overflow),
        .pre_fill_done(buffer_busy_ifmap),

        .rd_clk(pe_clk),
        .rd_rstn(rstn),
        .rd_en(rd_en), 
        .rd_data(ifmap_rd_data), 
        .empty(ifmap_empty),
        .pre_fill_done_sync(buffer_busy_sync_ifmap)
    );

    assign PE_BUFFER.fltr_data_M2P = MC_BUFFER.fltr_data_M2P;
//    assign PE_BUFFER.ifmap_data_M2P = rd_en ? ifmap_rd_data : 0;
//    assign PE_BUFFER.psum_data_M2P = rd_en ? psum_rd_data : 0;
    assign PE_BUFFER.ifmap_data_M2P = ifmap_rd_data;
    assign PE_BUFFER.psum_data_M2P = psum_rd_data;


    async_fifo_with_prefill #(
        .DATA_WIDTH(2*DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) PSUM_FIFO(
        .wr_clk(bus_clk),
        .wr_rstn(rstn),
        .wr_en(MC_BUFFER.PE_EN),
        .wr_data(MC_BUFFER.psum_data_M2P),
        .full(psum_overflow),
        .pre_fill_done(buffer_busy_psum),

        .rd_clk(pe_clk),
        .rd_rstn(rstn),
        .rd_en(rd_en),
        .rd_data(psum_rd_data),
        .empty(psum_empty),
        .pre_fill_done_sync(buffer_busy_sync_psum)
    );



endmodule