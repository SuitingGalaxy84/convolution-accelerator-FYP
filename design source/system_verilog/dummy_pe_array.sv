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

    // ifmap 输入信号
    input wire [0:PE_WIDTH-1] ifmap_conn_IN_00,     
    input wire [0:PE_WIDTH-1] ifmap_conn_IN_01,     
    input wire [0:PE_WIDTH-1] ifmap_conn_IN_02,     
    input wire [0:PE_WIDTH-1] ifmap_conn_IN_10,
    input wire [0:PE_WIDTH-1] ifmap_conn_IN_20,

    // ifmap 输出信号
    output wire [0:PE_WIDTH-1] ifmap_conn_02_OUT,  
    output wire [0:PE_WIDTH-1] ifmap_conn_12_OUT,  
    output wire [0:PE_WIDTH-1] ifmap_conn_20_OUT,
    output wire [0:PE_WIDTH-1] ifmap_conn_21_OUT,
    output wire [0:PE_WIDTH-1] ifmap_conn_22_OUT,

    // psum 输出信号
    output wire [0:PE_WIDTH-1] psum_conn_20_OUT,
    output wire [0:PE_WIDTH-1] psum_conn_21_OUT,
    output wire [0:PE_WIDTH-1] psum_conn_22_OUT
);

    /*
        中间连接线定义
    */
    // ifmap 信号连接
    wire [0:PE_WIDTH-1] ifmap_conn_00_11;
    wire [0:PE_WIDTH-1] ifmap_conn_01_12;
    wire [0:PE_WIDTH-1] ifmap_conn_10_21;
    wire [0:PE_WIDTH-1] ifmap_conn_11_22;

    // psum 信号连接
    wire [0:PE_WIDTH-1] psum_conn_00_10;
    wire [0:PE_WIDTH-1] psum_conn_01_11;
    wire [0:PE_WIDTH-1] psum_conn_02_12;
    wire [0:PE_WIDTH-1] psum_conn_10_20;
    wire [0:PE_WIDTH-1] psum_conn_11_21;
    wire [0:PE_WIDTH-1] psum_conn_12_22;

    // 实例化每个 PE（Processing Element）

    // PE (0,0)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_0_0 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_00, {PE_WIDTH{1'b0}}}), // 没有 psum 输入，接地
        .out_signals({ifmap_conn_00_11, psum_conn_00_10})
    );

    // PE (0,1)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_0_1 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_01, {PE_WIDTH{1'b0}}}), // 没有 psum 输入，接地
        .out_signals({ifmap_conn_01_12, psum_conn_01_11})
    );

    // PE (0,2)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_0_2 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_02, {PE_WIDTH{1'b0}}}), // 没有 psum 输入，接地
        .out_signals({ifmap_conn_02_OUT, psum_conn_02_12})
    );

    // PE (1,0)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_1_0 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_10, psum_conn_00_10}),
        .out_signals({ifmap_conn_10_21, psum_conn_10_20})
    );

    // PE (1,1)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_1_1 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_00_11, psum_conn_01_11}),
        .out_signals({ifmap_conn_11_22, psum_conn_11_21})
    );

    // PE (1,2)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_1_2 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_01_12, psum_conn_02_12}),
        .out_signals({ifmap_conn_12_OUT, psum_conn_12_22})
    );

    // PE (2,0)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_2_0 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_IN_20, psum_conn_10_20}),
        .out_signals({ifmap_conn_20_OUT, psum_conn_20_OUT})
    );

    // PE (2,1)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_2_1 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_10_21, psum_conn_11_21}),
        .out_signals({ifmap_conn_21_OUT, psum_conn_21_OUT})
    );

    // PE (2,2)
    SV_DummyPE #(.DELAY_CYCLES(DELAY_CYCLES), .PE_WIDTH(PE_WIDTH)) SV_DummyPE_2_2 (
        .clk(clk),
        .rst(rst),
        .in_signals({ifmap_conn_11_22, psum_conn_12_22}),
        .out_signals({ifmap_conn_22_OUT, psum_conn_22_OUT})
    );

endmodule