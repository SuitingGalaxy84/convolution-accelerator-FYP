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
    input wire pe_clk,
    input wire rstn,
    input wire external,
    input wire [$clog2(NUM_COL):0] tag, // extended by 1 bit 
    output wire tag_lock, //tag lock: notify the controller the tag is stored 
    BUS_IF.MCASTER_port UniV_XBUS_IF,
    PE_ITR.IN_port PE_IITR,
    PE_ITR.OUT_port PE_OITR
);

    PE_IF #(DATA_WIDTH) PE_BUFFER();
    PE_IF #(DATA_WIDTH) MC_BUFFER();

    SV_CCD_Buffer #(DATA_WIDTH, 16) CCD_BUFFER (
        .rstn(rstn),
        .bus_clk(clk),
        .pe_clk(pe_clk),
        .overflow(),
        .empty(),
        .buffer_busy(),
        .buffer_busy_sync(),
        .MC_BUFFER(MC_BUFFER),
        .PE_BUFFER(PE_BUFFER)
    );


    PE_IF #(DATA_WIDTH) PE_IF();
    // Parsing the PE and the Multicaster
    SV_PE #(DATA_WIDTH) PE(
        .rstn(rstn),
        .clk(pe_clk),
        .external(external),
        .PE_IF(PE_BUFFER),
        .PE_IITR(PE_IITR),
        .PE_OITR(PE_OITR)
    );

    MultiCaster #(DATA_WIDTH, NUM_COL) MC(
        .clk(clk),
        .rstn(rstn),
        .tag_in(tag),
        .BUS_IF(UniV_XBUS_IF),
        .PE_IF(MC_BUFFER),
        .PE_ITR_READY(PE_IITR.READY),
        .external(external),
        .tag_lock(tag_lock)
    );

endmodule