`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global Buffer
// Module Name: glb_Buff
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

module glb_Buff #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4,
    parameter NUM_ROW = 4
)(
    input wire clk,
    input wire rstn,
    GLB_BUFF.BUFF_port UniV_GLB_BUFF_IF
)
endmodule 