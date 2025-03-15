//TODO: design a benchmark for the PE set
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Testbench for Global Processing Element Set
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

module tb_glb_PE_set();
    parameter DATA_WIDTH=16;
    parameter NUM_COL =10;
    parameter NUM_ROW = 4;
    
    
    parameter CLK_PERIOD = 10;
    parameter PE_CLK_PERIOD = CLK_PERIOD * NUM_COL;
    
    parameter KERNEL_SIZE = 5;
    parameter BUFFER_SIZE = 512;
    
    
    reg clk, pe_clk, rstn;

    initial begin
        clk = 1;
        forever #(CLK_PERIOD/2) clk = ~clk;
        
    end 
    initial begin
        pe_clk = 0;
        forever #(PE_CLK_PERIOD/2) pe_clk = ~pe_clk;
    end 

    reg load_ifmap, load_fltr, load_psum;
    reg start;
    reg flush_kernel, flush_tag;
    reg [7:0] kernel_size;
    wire ram_rst_busy, tag_busy, kernel_busy;
    wire ram_load_busy;
    wire full;
    

    
    //start simulation
    initial begin
        kernel_size = KERNEL_SIZE; rstn = 1; start = 0; 
        load_ifmap=0; load_fltr=0;;load_psum=0;
        flush_kernel = 0; flush_tag = 0; // initialization
        #50 rstn = 0;
        #50 rstn = 1;
        wait(ram_rst_busy==1'b0); load_ifmap = 1; load_ifmap = 1;load_fltr = 1; load_psum=1;
        #500 load_ifmap = 0; load_fltr = 0; load_psum = 0;
        #20 flush_tag=1;
        #50 wait(tag_busy==1'b0); flush_tag=0; //tag config
        #20 flush_kernel=1;
        #50 wait(kernel_busy==1'b0); flush_kernel=0;
        #70 start = 1;
        #500 $stop;
    end
   
    
    //instantiate interfaces
    BUS_CTRL#(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) UniV_BUS_CTRL_IF();
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_IITR_insts[NUM_COL-1:0]() ;
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_OITR_insts[NUM_COL-1:0]() ;
    
    
    
    wire [DATA_WIDTH-1:0] data;
    wire [$clog2(NUM_COL):0] id; 
    wire [$clog2(BUFFER_SIZE)-1:0] addr;
    
    wire [DATA_WIDTH-1:0] fltr_data;
    wire [$clog2(BUFFER_SIZE)-1:0] fltr_addr;
   
    wire [2*DATA_WIDTH-1:0] psum_data;
    wire [$clog2(NUM_COL):0] psum_id;
    wire [$clog2(BUFFER_SIZE)-1:0] psum_addr;
    
    
    BUF_writer #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_ifmap(
        .clk(clk),
        .rstn(rstn),
        .load(load_ifmap),
        .data_out(data),
        .id_out(id),
        .addr_out(addr),
        .kernel_size(kernel_size)
    );
    
    BUF_writer #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_fltr(
        .clk(clk),
        .rstn(rstn),
        .load(load_fltr),
        .data_out(fltr_data),
        .id_out(),
        .addr_out(fltr_addr),
        .kernel_size(kernel_size)
    );
    
    BUF_writer #(.DATA_WIDTH(DATA_WIDTH*2), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) buf_writer_psum(
        .clk(clk),
        .rstn(rstn),
        .load(load_psum),
        .data_out(psum_data),
        .id_out(psum_id),
        .addr_out(psum_addr),
        .kernel_size(kernel_size)
    );
    
    
    
    //instantiate PE writer
    GLB_BUF #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .BUFFER_SIZE(BUFFER_SIZE)) glb_buffer(
        .bus_clk(clk),
        .rstn(rstn),
        
        .load_ifmap(load_ifmap), //load ifmap
        .load_fltr(load_fltr), // load fltr
        .load_psum(load_psum), // load psum
        
        .flush_tag(flush_tag), //flush: PE addr
        .flush_kernel(flush_kernel), // flush: kernel
        
        .addr_in(addr),
        .data_in({data, id}),
        
        .fltr_addr_in(fltr_addr),
        .fltr_data_in(fltr_data),
        
        .psum_addr_in(psum_addr),
        .psum_data_in({psum_data, psum_id}),
        
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