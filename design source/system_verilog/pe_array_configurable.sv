`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Configurable PE Array
// Module Name: pe_array_CONFIG
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

module pe_array_configurable #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512
)(
    input clk,
    input pe_clk,
    input rstn,

    input [NUM_ROW-1:0] load_ifmap,
    input [NUM_ROW-1:0] load_fltr,
    input [NUM_ROW-1:0] load_psum,
    
    input [NUM_ROW-1:0] flush_tag,
    input [NUM_ROW-1:0] flush_kernel,

    input [7:0] kernel_size,


    input [NUM_ROW-1:0] start,
    
    
    output [NUM_ROW-1:0] ram_rst_busy,
    output [NUM_ROW-1:0] tag_busy,
    output [NUM_ROW-1:0] kernel_busy,
    output [NUM_ROW-1:0] ram_load_busy,
    output [NUM_ROW-1:0] full
);

    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_IITR_insts[NUM_ROW-1:0][NUM_COL-1:0]();
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_OITR_insts[NUM_ROW-1:0][NUM_COL-1:0]();
    
    
    
    genvar i;
    generate
        for(i=0;i<NUM_ROW;i=i+1) begin: generate_buffer_pe_set
            BUF_PE_set #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW), .BUFFER_SIZE(BUFFER_SIZE)) BUF_PE_set(
            .clk(clk),
            .pe_clk(pe_clk),
            .rstn(rstn), 
            
            .load_ifmap(load_ifmap[i]),
            .load_fltr(load_fltr[i]),
            .load_psum(load_psum[i]),
            
            .flush_kernel(flush_kernel[i]),
            .flush_tag(flush_tag[i]),
            .kernel_size(kernel_size),

            .start(start[i]),
            
            .ram_rst_busy(ram_rst_busy[i]),
            .tag_busy(tag_busy[i]),
            .kernel_busy(kernel_busy[i]),
            .ram_load_busy(ram_load_busy[i]),
            .full(full[i]),
            
            .PE_IITR_insts(PE_IITR_insts[i]),
            .PE_OITR_insts(PE_OITR_insts[i])
        );
        end 
    endgenerate
    

    genvar x, y;
    generate
    for(y=0;y<NUM_ROW;y=y+1) begin
        for(x=0;x<NUM_COL;x=x+1) begin
            if(y<NUM_ROW-1&&x<NUM_COL-1) begin
                assign PE_IITR_insts[y+1][x+1].ifmap_data_P2P = PE_OITR_insts[y][x].ifmap_data_P2P; //diagnal connection of ifmaps
                assign PE_IITR_insts[y+1][x].psum_data_P2P = PE_OITR_insts[y][x].psum_data_P2P; // vertical connection of psum
            end
            if(y>0 && x > 0 ) begin 
                assign PE_IITR_insts[y][x].READY = (PE_OITR_insts[y-1][x].VALID && PE_OITR_insts[y-1][x-1].VALID);
            end else if(y>0 && x == 0) begin
                assign PE_IITR_insts[y][x].READY =  PE_OITR_insts[y-1][x].VALID;
            end          
        end 
    end 
    endgenerate 
        

    
    
endmodule