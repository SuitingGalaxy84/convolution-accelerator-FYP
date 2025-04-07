`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Configurable PE Array
// Module Name: pe_array_configurable
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

    input load_ifmap,
    input load_fltr,
    input load_psum,
    
    input flush_tag,
    input flush_kernel,

    input [7:0] kernel_size,

    input [NUM_ROW-1:0] start,
    
    
    output ram_rst_busy,
    output tag_busy,
    output kernel_busy,
    output  ram_load_busy,
    output full,
    output [2*DATA_WIDTH-1:0] opsum [NUM_COL-1:0],
    YBUS_IF.PEA_port YBUS_IF_insts
);

    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_IITR_insts[NUM_ROW-1:0][NUM_COL-1:0]();
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_OITR_insts[NUM_ROW-1:0][NUM_COL-1:0]();
    wire [NUM_ROW-1:0] tag_busy_;
    wire y_tag_busy;
    //assign tag_busy = (tag_busy_ == 0) ? (y_tag_busy ? 1 : 0) : 1; 
     
    wire [NUM_ROW-1:0] ram_rst_busy_;
    wire [NUM_ROW-1:0] kernel_busy_;
    wire [NUM_ROW-1:0] ram_load_busy_;
    wire [NUM_ROW-1:0] full_;
    assign ram_rst_busy = |ram_rst_busy_;
    assign kernel_busy = |kernel_busy_;
    assign ram_load_busy = |ram_load_busy_;
    assign full = |full_;
    assign tag_busy = y_tag_busy || |tag_busy_;
    
/*
    instantiate y-tag allocator
*/
    wire [$clog2(NUM_ROW):0] y_tag;
    wire [NUM_ROW-1:0] tag_locks;
    reg [$clog2(NUM_ROW):0] Y_TAG;
    always_ff@(posedge clk or negedge rstn) begin: Y_TAG_GEN
        if(~rstn) begin
            Y_TAG <= 0;
        end else if(flush_tag && Y_TAG < kernel_size) begin
            Y_TAG <= Y_TAG + 1;
        end else begin
            Y_TAG <= 0;
        end
    end 

    tagAlloc #(
        .NUM_COL(NUM_ROW)
    ) tagAlloc_inst(
        .clk(clk),
        .rstn(rstn),
        .flush_tag(flush_tag),
        .tag_in(tag_in),
        .tag_locks(tag_locks),
        .tag_busy(y_tag_busy),
        .kernel_size(kernel_size),
        .tag_out(y_tag)
    );
/*
    instantiate y-tag allocator
*/

    genvar i;
    generate
        for(i=0;i<NUM_ROW;i=i+1) begin: generate_buffer_pe_set
            BUF_PE_set #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW), .BUFFER_SIZE(BUFFER_SIZE)) BUF_PE_set(
            .clk(clk),
            .pe_clk(pe_clk),
            .rstn(rstn), 
            
            .load_ifmap(load_ifmap),
            .load_fltr(load_fltr),
            .load_psum(load_psum),
            
            .flush_kernel(flush_kernel),
            .flush_tag(flush_tag),
            .y_tag(y_tag),
            .y_tag_lock(tag_locks[i]),


            .kernel_size(kernel_size),

            .start(start[i]),
            
            .ram_rst_busy(ram_rst_busy_[i]),
            .tag_busy(tag_busy_[i]),
            .kernel_busy(kernel_busy_[i]),
            .ram_load_busy(ram_load_busy_[i]),
            .full(full_[i]),
            
            .YBUS_IF(YBUS_IF_insts),
            .PE_IITR_insts(PE_IITR_insts[i]),
            .PE_OITR_insts(PE_OITR_insts[i])
        );
        end 
        
        
    endgenerate
    

    genvar x, y;
    generate
    for(y=0;y<NUM_ROW;y=y+1) begin
        for(x=0;x<NUM_COL;x=x+1) begin
        
            assign PE_OITR_insts[y][x].READY = 1'b0;
            if(y<NUM_ROW-1&&x<NUM_COL-1) begin
                assign PE_IITR_insts[y+1][x+1].ifmap_data_P2P = PE_OITR_insts[y][x].ifmap_data_P2P; //diagnal connection of ifmaps
            end else if (y<NUM_ROW-1) begin
                assign PE_IITR_insts[y+1][x].psum_data_P2P = PE_OITR_insts[y][x].psum_data_P2P; // vertical connection of psum
            end else begin
                assign opsum[x] = PE_OITR_insts[y][x].psum_data_P2P;
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