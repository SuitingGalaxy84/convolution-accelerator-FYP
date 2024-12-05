`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global Processing Element
// Module Name: glb_PE
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

 module tb_glb_PE #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4,
    parameter CLK_PERIOD = 10
)();
    reg [$clog2(NUM_COL)-1:0] ID;
    reg [$clog2(NUM_COL)-1:0] TAG;
    reg READY;
    reg clk;
    reg rstn;
    reg en;
    reg [7:0] kernel_size;
    
    BUS_IF#(DATA_WIDTH) BUS_IF_inst();
    
    SV_glb_PE_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .CLK_PERIOD(CLK_PERIOD)
    ) driver (
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
    ) glb_PE (
        .clk(clk),
        .rstn(rstn),
        .BUS_IF(BUS_IF_inst)
    );

    initial begin
        rstn = 1; READY = 0; TAG = 3; ID = 1; en = 0; kernel_size = 3;
        #50 rstn = 0;
        #50 rstn = 1;
        #50 en = 1;
        #100 ID = 3; READY = 1;
        #300 $stop;
       
        
    end 
endmodule