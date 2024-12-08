`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global PE Loop 
// Module Name: interface
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

module tb_glb_PE_Loop #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4,
    parameter CLK_PERIOD = 10
    )();
    reg clk;
    reg rstn;
    reg [$clog2(NUM_COL)-1:0] ID;
    reg [$clog2(NUM_COL)-1:0] TAG;
    reg READY;
    reg en;
    reg [7:0] kernel_size;
    
    BUS_IF#(DATA_WIDTH) BUS_IF_inst();
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_1();
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_2();
    
    SV_glb_PE_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .CLK_PERIOD(CLK_PERIOD)
        ) SV_glb_PE_driver_inst(
            .clk(clk),
            .rstn(rstn),
            .BUS_IF(BUS_IF_inst),
            .ID(ID),
            .TAG(TAG),
            .READY(READY),
            .EN(en),
            .kernel_size(kernel_size)
        );
    
    
    glb_PE #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL)
        ) glb_PE_inst_1 (
            .clk(clk),
            .rstn(rstn),
            .BUS_IF(BUS_IF_inst),
            .PE_IITR(PE_ITR_inst_1),
            .PE_OITR(PE_ITR_inst_2)
        );
    
    assign PE_ITR_inst_2.READY = PE_ITR_inst_1.VALID;
    
    glb_PE #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL)
        ) glb_PE_inst_2 (
            .clk(clk),
            .rstn(rstn),
           .PE_IITR(PE_ITR_inst_1),
           .PE_OITR(PE_ITR_inst_2)
        );

endmodule