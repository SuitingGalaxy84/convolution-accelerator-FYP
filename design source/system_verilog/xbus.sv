`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Colunm-wise PE-bus
// Module Name: xbus
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: Processing Element for Convolution Accelerator
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

module xbus #(
    parameter NUM_COL = 4,
    parameter DATA_WIDTH = 16
)(
    input clk,
    input rstn
);
    
    
    genvar i;
    generate
    for(i=0;i<NUM_COL;i++) begin: PE_Xbus
        
        glb_PE #(DATA_WIDTH, NUM_COL) glb_PE (
            .clk(clk),
            .rstn(rstn),
            
        );
    end

    endgenerate
endmodule