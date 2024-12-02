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

module glb_PE #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4
)(
    input wire clk,
    input wire rstn,
    BUS_IF.MCASTER_port BUS_IF,

    //temorarily IOed Signals
    input wire mult_seln,
    input wire acc_seln
);


    PE_IF #(DATA_WIDTH) PE_IF();

    // Parsing the PE and the Multicaster
    SV_PE #(DATA_WIDTH) PE(
        .rstn(rstn),
        .clk(clk),
        .PE_IF(PE_IF),
        .mult_seln(mult_seln),
        .acc_seln(acc_seln)
    );

    MultiCaster #(DATA_WIDTH, NUM_COL) MC(
        .clk(clk),
        .rstn(rstn),
        .BUS_IF(BUS_IF),
        .PE_IF(PE_IF)
    );

endmodule