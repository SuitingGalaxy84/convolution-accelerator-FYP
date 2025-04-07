`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Processing Element Set with buffer
// Module Name: PE
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

// Processing Element (PE) Module

module BUF_PE_set#(
    parameter DATA_WIDTH=16,
    parameter NUM_COL =10,
    parameter NUM_ROW = 4,
    parameter BUFFER_SIZE = 512
)(
    input clk,
    input pe_clk,
    input rstn,
    
    input load_ifmap,
    input load_fltr,
    input load_psum,
    
    input flush_kernel, 
    input flush_tag, 
    input [$clog2(NUM_ROW):0] y_tag, //extended by 1 bit
    output y_tag_lock,
   
    input [7:0] kernel_size,
    
    input start, 
   
    output ram_rst_busy,
    output tag_busy, 
    output kernel_busy,
    output ram_load_busy,
    output full,

    YBUS_IF.PEA_port YBUS_IF,
    PE_ITR.IN_port PE_IITR_insts [NUM_COL-1:0],
    PE_ITR.OUT_port PE_OITR_insts [NUM_COL-1:0]
);

    
    

    wire [$clog2(NUM_ROW):0] tag;
    tagBuff #(.NUM_COL(NUM_ROW)) tagBuff_inst(
        .clk(clk),
        .rstn(rstn),
        .flush_tag(flush_tag),
        .tag_in(y_tag),
        .tag_out(tag),
        .tag_lock(tag_lock)
    );

    
 //instantiate interfaces
    BUS_CTRL#(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) UniV_BUS_CTRL_IF();
//    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_IITR_insts[NUM_COL-1:0]() ;
//    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_OITR_insts[NUM_COL-1:0]() ;
    
    
    
    // wire [DATA_WIDTH-1:0] data;
    // wire [$clog2(NUM_COL):0] id; 
    // wire [$clog2(BUFFER_SIZE)-1:0] addr;
    
    // wire [DATA_WIDTH-1:0] fltr_data;
    // wire [$clog2(BUFFER_SIZE)-1:0] fltr_addr;
   
    // wire [2*DATA_WIDTH-1:0] psum_data;
    // wire [$clog2(NUM_COL):0] psum_id;
    // wire [$clog2(BUFFER_SIZE)-1:0] psum_addr;
    
    
    // BUF_writer #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_ifmap(
    //     .clk(clk),
    //     .rstn(rstn),
    //     .load(load_ifmap),
    //     .data_out(data),
    //     .id_out(id),
    //     .addr_out(addr),
    //     .kernel_size(kernel_size)
    // );
    
    // BUF_writer #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_fltr(
    //     .clk(clk),
    //     .rstn(rstn),
    //     .load(load_fltr),
    //     .data_out(fltr_data),
    //     .id_out(),
    //     .addr_out(fltr_addr),
    //     .kernel_size(kernel_size)
    // );
    
    // BUF_writer #(.DATA_WIDTH(DATA_WIDTH*2), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_psum(
    //     .clk(clk),
    //     .rstn(rstn),
    //     .load(load_psum),
    //     .data_out(psum_data),
    //     .id_out(psum_id),
    //     .addr_out(psum_addr),
    //     .kernel_size(kernel_size)
    // );
    
    
    
    //instantiate PE writer
    GLB_BUF #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) glb_buffer(
        .bus_clk(clk),
        .rstn(rstn),
        
        .load_ifmap(load_ifmap), //load ifmap
        .load_fltr(load_fltr), // load fltr
        .load_psum(load_psum), // load psum
        
        .flush_tag(flush_tag), //flush: PE addr
        .flush_kernel(flush_kernel), // flush: kernel
        
        .addr_in(YBUS_IF.ifmap_addr),
        .data_in(YBUS_IF.ifmap_data),
        
        .fltr_addr_in(YBUS_IF.fltr_addr),
        .fltr_data_in(YBUS_IF.fltr_data),
        
        .psum_addr_in(YBUS_IF.psum_addr),
        .psum_data_in(YBUS_IF.psum_data),
        
        .kernel_size(kernel_size),
        
        
        
        .UniV_BUS_CTRL_IF(UniV_BUS_CTRL_IF),
        .ram_rst_busy(ram_rst_busy),
        .ram_load_busy(ram_load_busy),
        .full(full),
        
        .start(start)
    );

    //instantiate PE set
    glb_PE_SET #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) glb_PE_SET_inst(
        .clk(clk),
        .pe_clk(pe_clk),
        .rstn(rstn),
        .flush_tag(flush_tag),
        .flush_kernel(flush_kernel),
        
        .kernel_size(kernel_size),
        .rst_busy(rst_busy),
        .tag_busy(tag_busy),
        .kernel_busy(kernel_busy),

        .PE_IITR_insts(PE_IITR_insts),
        .PE_OITR_insts(PE_OITR_insts),
        .UniV_BUS_CTRL_IF(UniV_BUS_CTRL_IF)
    );

endmodule