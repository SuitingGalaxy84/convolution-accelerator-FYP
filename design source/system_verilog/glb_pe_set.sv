`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: Global PE Set
// Module Name: glb_pe_set
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

module glb_PE_SET#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 8,
    parameter NUM_ROW = 10
)(
    input clk, 
    input pe_clk,
    input rstn, 
    input flush_tag,
    input flush_kernel, 
    
    input external,
    input [7:0] kernel_size,
    output rst_busy,
    output tag_busy,
    output kernel_busy,

    PE_ITR.IN_port PE_IITR_insts [NUM_COL-1:0],
    PE_ITR.OUT_port PE_OITR_insts [NUM_COL-1:0],
    BUS_CTRL.X_BUS_CTRL UniV_BUS_CTRL_IF    
);
    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF();
    assign kernel_busy = UniV_XBUS_IF.kernel_busy;
    
    
    X_BusCtrl #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) X_BusCtrl_inst(
        .clk(clk),
        .rstn(rstn),
        .flush_tag(flush_tag),
        .flush_kernel(flush_kernel),
        .kernel_size(kernel_size),
        .UniV_XBUS_IF(UniV_XBUS_IF),
        .UniV_BUS_CTRL(UniV_BUS_CTRL_IF)
    );

    wire [NUM_COL-1:0] tag_locks;
    wire [NUM_COL-1:0] [$clog2(NUM_COL):0] tag_out; // extended by 1 bit

    tagAlloc #(.NUM_COL(NUM_COL)) tagAlloc_inst(
        .clk(clk),
        .rstn(rstn),
        .flush_tag(flush_tag),
        .kernel_size(kernel_size),
        .tag_in(UniV_BUS_CTRL_IF.X_TAG),
        .tag_out(tag_out),
        .tag_locks(tag_locks),
        .tag_busy(tag_busy)
    );



    genvar i;
    generate
        for(i=0; i<NUM_COL; i=i+1) begin: PE_ITR_insts
        glb_PE #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL)) glb_PE_inst(
                    .clk(clk),
                    .pe_clk(pe_clk),
                    .rstn(rstn),
                    .external(external),
                    .tag(tag_out[i]),
                    .tag_lock(tag_locks[i]),
                    .UniV_XBUS_IF(UniV_XBUS_IF),
                    .PE_IITR(PE_IITR_insts[i]),
                    .PE_OITR(PE_OITR_insts[i])
                );
            end
    endgenerate
endmodule 
