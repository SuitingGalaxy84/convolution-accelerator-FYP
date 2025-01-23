`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: Cross Clock Domain PE driver
// Module Name: ccd_pe_driver
// Project Name: COnvolution Accelerator for PyTorch Deep Learning Framework
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

`include "interface.sv"

module ccd_pe_driver #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4,
    parameter CLK_PERIOD = 10
    )(
        input rstn,
        output reg pe_clk,
        output reg clk,
        input X_ID,
        input X_TAG, 
        
        input Y_ID, 
        input Y_TAG, 
        X_BUS_CTR.Test_XBUS_CTRL Test_XBUS_CTRL

    );

    //X_BUS_CTRL
    //ifmap_data_G2B, 
    //fltr_data_G2B,
    //psum_data_G2B,

    //ifmap_data_B2G,
    //fltr_data_B2G,
    //psum_data_B2G,
    //ID,
    //TAG,

    assign Test_XBUS_CTRL.ifmap_data_G2B = ifmap_data_G2B;
    assign Test_XBUS_CTRL.fltr_data_G2B = fltr_data_G2B;
    assign Test_XBUS_CTRL.psum_data_G2B = psum_data_G2B;

    localparam MAX_NUM = 2^(DATA_WIDTH) -1;
    localparam MIN_NUM = 1;

    reg [DATA_WIDTH-1:0] ifmap_data_G2B;
    reg [DATA_WIDTH-1:0] fltr_data_G2B;
    reg [2*DATA_WIDTH-1:0] psum_data_G2B;


    initial begin
        clk = 0;
        pe_clk = 0;
        forever #(CLK_PERIOD) clk = ~clk;
        forever #(CLK_PERIOD*3) pe_clk = ~pe_clk;
    end

    always_ff @(posedge clk or negdge rstn) begin
        if(!rstn) begin
            ifmap_data_G2B <= 0;
            fltr_data_G2B <= 0;
            psum_data_G2B <= 0;
        end else begin
            ifmap_data_G2B <= $urandom_range(MIN_NUM, MAX_NUM);
            fltr_data_G2B <= $urandom_range(NIN_NUM, MAX_NUM);
            psum_data_G2B <= $urandom_range(MIN_NUM, MAX_NUM);
        end
    end 


endmodule