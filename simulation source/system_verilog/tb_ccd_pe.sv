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

    localparam CLK_PERIOD = 10;
    localparam DATA_WIDTH = 16;
    localparam NUM_COL = 3;
    localparam NUM_ROW = 1;

    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF();
    BUS_CTRL #(DATA_WIDTH, NUM_ROW, NUM_COL) UniV_BUS_CTRL_IF();
    PE_ITR #(DATA_WIDTH) PE_ITR_inst1();
    PE_ITR #(DATA_WIDTH) PE_ITR_inst2();    

    
    reg [7:0] kernel_size;
    reg [$clog2(NUM_COL)-1:0] X_ID;
    reg [$clog2(NUM_COL)-1:0] X_TAG;
    
    reg [$clog2(NUM_ROW)-1:0] Y_ID;
    reg [$clog2(NUM_ROW)-1:0] Y_TAG;
    
    reg external;
    reg flush;
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
        .X_TAG(X_TAG),
        .Y_ID(Y_ID),
        .Y_TAG(Y_TAG),
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

    wire tag_locks;
    wire [NUM_COL-1:0] tag_lock;
    genvar i;

    tagAlloc #(
        .NUM_COL(NUM_COL), 
        .DATA_WIDTH(DATA_WIDTH)
    ) tagAlloc(
        .clk(clk),
        .rstn(rstn),
        .flush(UniV_BUS_CTRL_IF.flush),
        .tag_in(),
        .tag_out(),
        .tag_lock(tag_locks)
    )
    
    generate
        for(i=0; i<NUM_COL; i=i+1) begin : glb_PE

            assign tag_locks = &tag_lock[i];
            glb_PE #(
                .DATA_WIDTH(DATA_WIDTH),
                .NUM_COL(NUM_COL)
            ) glb_PE(
                .clk(clk),
                .rstn(rstn),
                .external(external),
                .tag_lock(tag_lock[i])
                .BUS_IF(UniV_XBUS_IF),
                .PE_IITR(PE_ITR_inst1),
                .PE_OITR(PE_ITR_inst2)
            );
        end
    endgenerate
    
    initial begin
    external=1; rstn = 1;
    #30 rstn = 0;
    #300 $stop;
    end  
endmodule 