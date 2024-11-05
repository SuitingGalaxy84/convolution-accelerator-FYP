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

module DummyPEArray_tb;

    parameter DELAY_CYCLES = 2; // 默认延迟周期
    parameter PE_WIDTH = 4;       // 数据位宽

    reg clk;
    reg rst;

    // 输入信号
    reg [PE_WIDTH-1:0] ifmap_conn_IN_00;     
    reg [PE_WIDTH-1:0] ifmap_conn_IN_01;     
    reg [PE_WIDTH-1:0] ifmap_conn_IN_02;     
    reg [PE_WIDTH-1:0] ifmap_conn_IN_10;
    reg [PE_WIDTH-1:0] ifmap_conn_IN_20;

    // 输出信号
    wire [PE_WIDTH-1:0] ifmap_conn_02_OUT;  
    wire [PE_WIDTH-1:0] ifmap_conn_12_OUT;  
    wire [PE_WIDTH-1:0] ifmap_conn_20_OUT;
    wire [PE_WIDTH-1:0] ifmap_conn_21_OUT;
    wire [PE_WIDTH-1:0] ifmap_conn_22_OUT;

    wire [PE_WIDTH-1:0] psum_conn_20_OUT;
    wire [PE_WIDTH-1:0] psum_conn_21_OUT;
    wire [PE_WIDTH-1:0] psum_conn_22_OUT;

    // 实例化待测试模块
    DummyPEArray #(
        .DELAY_CYCLES(DELAY_CYCLES),
        .PE_WIDTH(PE_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .ifmap_conn_IN_00(ifmap_conn_IN_00),
        .ifmap_conn_IN_01(ifmap_conn_IN_01),
        .ifmap_conn_IN_02(ifmap_conn_IN_02),
        .ifmap_conn_IN_10(ifmap_conn_IN_10),
        .ifmap_conn_IN_20(ifmap_conn_IN_20),
        .ifmap_conn_02_OUT(ifmap_conn_02_OUT),
        .ifmap_conn_12_OUT(ifmap_conn_12_OUT),
        .ifmap_conn_20_OUT(ifmap_conn_20_OUT),
        .ifmap_conn_21_OUT(ifmap_conn_21_OUT),
        .ifmap_conn_22_OUT(ifmap_conn_22_OUT),
        .psum_conn_20_OUT(psum_conn_20_OUT),
        .psum_conn_21_OUT(psum_conn_21_OUT),
        .psum_conn_22_OUT(psum_conn_22_OUT)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 测试逻辑
    initial begin
        // 初始化信�?
        rst = 1;
        ifmap_conn_IN_00 = 0;
        ifmap_conn_IN_01 = 0;
        ifmap_conn_IN_02 = 0;
        ifmap_conn_IN_10 = 0;
        ifmap_conn_IN_20 = 0;

        // 释放复位，开始测�?
        #10;
        rst = 0;

        // 输入初始数据
        ifmap_conn_IN_00 = 4'b0001;
        ifmap_conn_IN_01 = 4'b0010;
        ifmap_conn_IN_02 = 4'b0011;
        ifmap_conn_IN_10 = 4'b0100;
        ifmap_conn_IN_20 = 4'b0101;

        // �?查数据如何流�?
        #50;
        ifmap_conn_IN_00 = 4'b0110;
        ifmap_conn_IN_01 = 4'b0111;
        ifmap_conn_IN_02 = 4'b1000;
        ifmap_conn_IN_10 = 4'b1001;
        ifmap_conn_IN_20 = 4'b1010;

        // 继续观察�?段时间以查看数据在网络中的传�?
        #10000;

        // 结束仿真
        $finish;
    end

    // 监控数据流动
    initial begin
        $monitor("Time = %t | ifmap_conn_02_OUT = %b | ifmap_conn_12_OUT = %b | ifmap_conn_20_OUT = %b | ifmap_conn_21_OUT = %b | ifmap_conn_22_OUT = %b | psum_conn_20_OUT = %b | psum_conn_21_OUT = %b | psum_conn_22_OUT = %b", 
                 $time, ifmap_conn_02_OUT, ifmap_conn_12_OUT, ifmap_conn_20_OUT, ifmap_conn_21_OUT, ifmap_conn_22_OUT, psum_conn_20_OUT, psum_conn_21_OUT, psum_conn_22_OUT);
    end

endmodule