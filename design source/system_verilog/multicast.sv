`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE Key-Lock Checker 
// Module Name: SV_DummyPE_KL
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
/*
    a LOCK-KEY scheme is created. Every PE is assgined with a unique ROW-COL tag at the initialization. The PE
    can be activated only when the corresponding ROW-COL tag is provided. This facilitates an efficient control
    of the PE array.
 */
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "interface.sv"

module MultiCaster#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input clk,
    input rstn,
    input tag,
    BUS_CASTER_X.CASTER CASTER
);




endmodule