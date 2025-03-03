`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: Cross Clock Domain Testbench
// Module Name: tb_ccd_pe
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

module tb_ccd_pe();

    parameter CLK_PERIOD = 10;
    parameter DATA_WIDTH = 16;
    parameter NUM_COL = 10;
    parameter NUM_ROW = 2;

    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF();
    BUS_CTRL #(DATA_WIDTH, NUM_COL, NUM_ROW) UniV_BUS_CTRL_IF();
    PE_ITR #(DATA_WIDTH) PE_ITR_inst1();
    PE_ITR #(DATA_WIDTH) PE_ITR_inst2();    

    
    reg [7:0] kernel_size;
    reg [$clog2(NUM_COL):0] X_ID; // extended by 1 bit 
     
    reg [$clog2(NUM_ROW):0] Y_ID; // extended by 1 bit
    reg [$clog2(NUM_ROW):0] Y_TAG; // extended by 1 bit 
    
    reg external;
    reg flush;
    wire flush_busy;
    wire rst_busy;
    reg rstn;
   
    
    // instantiate ccd_pe_driver
    ccd_pe_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .CLK_PERIOD(CLK_PERIOD)
    )ccd_pe_driver (
        .rstn(rstn),
        .pe_clk(pe_clk),
        .clk(clk),
        .X_ID(X_ID),
        .flush(flush),
        .Y_ID(Y_ID),
        .Y_TAG(Y_TAG),
        .kernel_size(kernel_size),
        .Test_XBUS_CTRL(UniV_BUS_CTRL_IF)
    );
    
    // instantiate glb_PE

    X_BusCtrl #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW)
    ) X_BusCtrl(
        .clk(clk),
        .rstn(rstn),
        .flush(flush),
        .rst_busy(rst_busy),
        .kernel_size(kernel_size),
        .UniV_XBUS_IF(UniV_XBUS_IF),
        .UniV_BUS_CTRL(UniV_BUS_CTRL_IF)
    );

    wire [NUM_COL-1:0] tag_locks;
    wire [NUM_COL-1:0][$clog2(NUM_COL):0] tag_out; // extended by 1 bit

    tagAlloc #(
        .NUM_COL(NUM_COL)
    ) tagAlloc(
        .clk(clk),
        .rstn(rstn),
        .flush(flush),
        .kernel_size(kernel_size),
        .tag_in(UniV_BUS_CTRL_IF.X_TAG),
        .tag_out(tag_out),
        .tag_locks(tag_locks),
        .flush_busy(flush_busy)
    );
    genvar i;
    generate
        for(i=0; i<NUM_COL; i=i+1) begin : glb_PE

            glb_PE #(
                .DATA_WIDTH(DATA_WIDTH),
                .NUM_COL(NUM_COL)
            ) glb_PE(
                .clk(clk),
                .pe_clk(pe_clk),
                .rstn(rstn),
                .external(external),
                .tag(tag_out[i]),
                .tag_lock(tag_locks[i]),
                .UniV_XBUS_IF(UniV_XBUS_IF),
                .PE_IITR(PE_ITR_inst1),
                .PE_OITR(PE_ITR_inst2)
            );
        end
    endgenerate
    
    initial begin
    external=1; rstn = 1;flush = 0;Y_ID = 0; Y_TAG = 1;kernel_size = 3;
    #30 rstn = 0;
    #30 rstn = 1;
    #10 flush=1;
    #100 flush = 0;
    #20 rstn = 0;
    #40 rstn = 1;
    #50 kernel_size = 7;
    #20 flush = 1;
    #300 $stop;
    end  
endmodule 