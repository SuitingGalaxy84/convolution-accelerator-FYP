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
    reg flush;
    
    BUS_IF#(DATA_WIDTH) BUS_IF_inst_1();
    BUS_IF#(DATA_WIDTH) BUS_IF_inst_2();
    
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_1();
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_2();
    
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_3();
    PE_ITR#(DATA_WIDTH) PE_ITR_inst_4();
    
    SV_glb_PE_driver #(
        .DATA_WIDTH(2*DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .CLK_PERIOD(CLK_PERIOD)
        ) SV_glb_PE_driver_inst(
            .clk(clk),
            .rstn(rstn),
            .BUS_IF(BUS_IF_inst_1),
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
            .external(1),
            .BUS_IF(BUS_IF_inst_1),
            .PE_IITR(PE_ITR_inst_1),
            .PE_OITR(PE_ITR_inst_2)
        );
    
    assign PE_ITR_inst_3.READY = PE_ITR_inst_2.VALID;
    assign BUS_IF_inst_2.kernel_size = kernel_size;
    assign BUS_IF_inst_1.flush = flush;
    assign PE_ITR_inst_3.ifmap_data_P2P = PE_ITR_inst_2.ifmap_data_P2P;
    assign PE_ITR_inst_3.fltr_data_P2P = PE_ITR_inst_2.fltr_data_P2P;
    assign PE_ITR_inst_3.psum_data_P2P = PE_ITR_inst_2.psum_data_P2P;
    
    glb_PE #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL)
        ) glb_PE_inst_2 (
            .clk(clk),
            .rstn(rstn),
            .external(0),
            .BUS_IF(BUS_IF_inst_2),
            .PE_IITR(PE_ITR_inst_3),
            .PE_OITR(PE_ITR_inst_4)
        );
        
    initial begin
        rstn = 1; READY = 0; TAG = 3; ID = 1; en = 0; kernel_size = 3; flush = 0;
        #30 rstn = 0; 
        #30 rstn = 1;
        #30 en = 1;
        #30 ID = 3; 
        #30 flush = 1;READY = 1;
        #10 flush = 0;
        #250 $stop;
    end 
endmodule