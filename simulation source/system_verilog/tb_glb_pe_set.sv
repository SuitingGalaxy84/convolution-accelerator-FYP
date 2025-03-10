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
    
    parameter KERNEL_SIZE = 3;

    reg clk, pe_clk;

    initial begin
        clk = 1;
        forever #(CLK_PERIOD/2) clk = ~clk;
        
    end 
    initial begin
        pe_clk = 0;
        forever #(PE_CLK_PERIOD/2) pe_clk = ~pe_clk;
    end 

    reg rstn, flush, start;
    reg [DATA_WIDTH-1:0] data_in;
    reg [7:0] kernel_size;
    wire rstn_busy;

    always_ff @(posedge clk or negedge rstn) begin: generate_data_in
        if(~rstn) begin
            data_in <= 0;
        end else begin
            if(flush && !rstn_busy) begin
                data_in <= data_in + 1;
            end else begin
                data_in <= 0;
            end
            end
    end
    
    //start simulation
    initial begin
        kernel_size = KERNEL_SIZE; rstn = 1; flush = 0; start = 0;
        #50 rstn = 0;
        #50 rstn = 1;
        #100 flush = 1;
        #100 $stop;

    end
    
    //instantiate interfaces
    BUS_CTRL#(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) UniV_BUS_CTRL_IF();
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_IITR_insts[NUM_COL-1:0]() ;
    PE_ITR#(.DATA_WIDTH(DATA_WIDTH)) PE_OITR_insts[NUM_COL-1:0]() ;
    
    //instantiate PE writer
    GLB_BUF #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL)) glb_buffer(
        .bus_clk(clk),
        .rstn(rstn),
        .flush(flush),
        .start(start),
        .data_in(data_in),
        .kernel_size(kernel_size),
        .UniV_BUS_CTRL_IF(UniV_BUS_CTRL_IF),
        .rstn_busy(rstn_busy)
    );

    //instantiate PE set
    glb_PE_SET #(.DATA_WIDTH(DATA_WIDTH), .NUM_COL(NUM_COL), .NUM_ROW(NUM_ROW)) glb_PE_SET_inst(
        .clk(clk),
        .pe_clk(pe_clk),
        .rstn(rstn),
        .flush(flush),

        .external(external),
        .kernel_size(kernel_size),
        .rst_busy(rst_busy),
        .flush_busy(flush_busy),

        .PE_IITR_insts(PE_IITR_insts),
        .PE_OITR_insts(PE_OITR_insts),
        .UniV_BUS_CTRL_IF(UniV_BUS_CTRL_IF)
    );

    

endmodule