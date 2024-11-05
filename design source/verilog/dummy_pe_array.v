`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: 
// Module Name: blk_mem_rd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DummyPEArray #(
    parameter DELAY_CYCLES = 10,          // 默认延迟周期
    parameter PE_WIDTH = 4
) (
    input wire clk,                       // 时钟信号
    input wire rst,                       // 复位信号
    input wire [PE_WIDTH-1:0] in_signal_1_0_0,     // 初始输入信号1，位置(0,0) ifmap
    input wire [PE_WIDTH-1:0] in_signal_2_0_0,     // 初始输入信号2，位置(0,0) psum

    input wire [PE_WIDTH-1:0] in_signal_1_1_0,     
    input wire [PE_WIDTH-1:0] in_signal_2_1_0,

    input wire [PE_WIDTH-1:0] in_signal_1_2_0,    
    input wire [PE_WIDTH-1:0] in_signal_2_2_0,

    output wire [PE_WIDTH-1:0] out_signal_1_0_0,
    output wire [PE_WIDTH-1:0] out_signal_2_0_0
);

    /*
        feature map interconnection (ifmap)
    */
    wire [PE_WIDTH-1:0] ifmap_conn_IN_00;
    wire [PE_WIDTH-1:0] ifmap_conn_IN_01;
    wire [PE_WIDTH-1:0] ifmap_conn_IN_02;

    wire [PE_WIDTH-1:0] ifmap_conn_IN_10;
    wire [PE_WIDTH-1:0] ifmap_conn_00_11;
    wire [PE_WIDTH-1:0] ifmap_conn_01_12;
    wire [PE_WIDTH-1:0] ifmap_conn_02_OUT;

    wire [PE_WIDTH-1:0] ifmap_conn_IN_20;
    wire [PE_WIDTH-1:0] ifmap_conn_10_21;
    wire [PE_WIDTH-1:0] ifmap_conn_11_22;
    wire [PE_WIDTH-1:0] ifmap_conn_12_OUT;

    wire [PE_WIDTH-1:0] ifmap_conn_20_OUT;
    wire [PE_WIDTH-1:0] ifmap_conn_21_OUT;
    wire [PE_WIDTH-1:0] ifmap_conn_22_OUT;

    /*
        partial sum interconnection (psum)
    */
    wire [PE_WIDTH-1:0] psum_conn_00_10;
    wire [PE_WIDTH-1:0] psum_conn_01_11;
    wire [PE_WIDTH-1:0] psum_conn_02_12;

    wire [PE_WIDTH-1:0] psum_conn_10_20;
    wire [PE_WIDTH-1:0] psum_conn_11_21;
    wire [PE_WIDTH-1:0] psum_conn_12_22;

    wire [PE_WIDTH-1:0] psum_conn_20_OUT;
    wire [PE_WIDTH-1:0] psum_conn_21_OUT;
    wire [PE_WIDTH-1:0] psum_conn_22_OUT;

    // Instance of delayer for each PE

    // PE (0,0)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_0_0 (
        .clk(clk),
        .rst(rst),
        .in_signals({in_signal_1_0_0, in_signal_2_0_0}),
        .out_signals({ifmap_conn_00_11, psum_conn_00_10})
    );

    // PE (0,1)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_0_1 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_01, psum_conn_01_11}),
        .out_signals({ifmap_conn_01_12, psum_conn_01_11})
    );

    // PE (0,2)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_0_2 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_02, psum_conn_02_12}),
        .out_signals({ifmap_conn_02_OUT, psum_conn_02_12})
    );

    // PE (1,0)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_1_0 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_10_21, psum_conn_10_20}),
        .out_signals({ifmap_conn_11_22, psum_conn_11_21})
    );

    // PE (1,1)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_1_1 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_00_11, psum_conn_11_22}),
        .out_signals({ifmap_conn_12_OUT, psum_conn_12_22})
    );

    // PE (1,2)
    signal_delayer #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) delayer_1_2 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_02_OUT, psum_conn_22_OUT}),
        .out_signals({ifmap_conn_22_OUT, psum_conn_22_OUT})
    );

endmodule