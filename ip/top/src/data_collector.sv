`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Data Collector
// Module Name: data_collector
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




module data_collector #(
    parameter DATA_WIDTH = 32,
    parameter NUM_COL = 7,
    parameter FIFO_DEPTH = 16  // 异步FIFO深度，应为2的幂
)(
    input clk,
    input pe_clk,
    input rstn,
    input [7:0] kernel_size,
    input [2*DATA_WIDTH-1:0] data_in [NUM_COL-1:0],
    input data_valid,
    output [2*DATA_WIDTH:0] data_out

);

    wire data_valid_sync;
    wire [2*DATA_WIDTH:0] rd_data [NUM_COL-1:0];
    pulse_collector synchronizer(
        .fast_clk(clk),
        .slow_clk(pe_clk),
        .rstn(rstn),
        .slow_pulse(data_valid),
        .fast_pulse(data_valid_sync)
    );
    genvar i;
    reg [NUM_COL-1:0] pe_selct;
    always_ff@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            pe_selct <= 0;
        end else if(data_valid_sync) begin
            pe_selct <= (pe_selct == kernel_size-1) ? 0 : pe_selct + 1;
        end else begin
            pe_selct <= pe_selct;
        end
    end
    assign data_out = rd_data[pe_selct];
    generate 
        for (i=0;i<NUM_COL;i=i+1) begin: Collector

            async_fifo_with_prefill #(
                .DATA_WIDTH(DATA_WIDTH),
                .FIFO_DEPTH(FIFO_DEPTH)
            ) fifo_inst (
                .wr_clk(pe_clk),
                .wr_rstn(rstn),
                .wr_en(data_valid),
                .wr_data(data_in[i]),

                .rd_clk(clk),
                .rd_rstn(rstn),
                .rd_en(data_valid_sync),
                .rd_data(rd_data[i])
            );
        end 
    endgenerate

    
endmodule