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

module tb_ccd_pe();

    localparam CLK_PERIOD = 10;
    localparam DATA_WIDTH = 16;
    localparam NUM_COL = 3;
    localparam NUM_ROW = 1;

    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF();
    BUS_CTRL #(DATA_WIDTH, NUM_ROW, NUM_COL) UniV_BUS_CTRL_IF();

    

    // instantiate ccd_pe_driver
    ccd_pe_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COLq(NUM_COL),
        .CLK_PERIOD(CLK_PERIOD)
    )(
        .rstn(rstn),
        .pe_clk(pe_clk),
        .clk(clk),
        .X_ID(X_ID),
        .X_TAG(X_TAG),
        .Y_ID(Y_ID),
        .Y_TAG(Y_TAG),
        .X_BUS_CTR(UniV_BUS_CTRL_IF)
    )
    
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
        .UniV_XBUS_IF(UniV_XBUS_IF),
        .UniV_BUS_CTRL(UniV_BUS_CTRL_IF)
    );


    genvar i;
    generate
        for(i=0; i<NUM_COL; i=i+1) begin : glb_PE
            glb_PE #(
                .DATA_WIDTH(DATA_WIDTH),
                .NUM_COL(NUM_COL)
            ) glb_PE(
                .clk(clk),
                .rstn(rstn),
                .external(external),
                .BUS_IF(UniV_XBUS_IF),
                .PE_ITR(PE_IITR[i]),
                .PE_ITR(PE_OITR[i])
            );
        end
    endgenerate
    
endmodule 