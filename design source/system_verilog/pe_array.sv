`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Row Bus
// Module Name: xbus
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

module xbus(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4,
    parameter NUM_ROW = 4
    )(
        input wire clk,
        input wire rstn,
        BUS_CTRL #(DATA_WIDTH, NUM_COL, NUM_ROW) UniV_BUS_CTRL
    );

    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF [NUM_ROW-1:0];
    PE_ITR #(DATA_WIDTH) PE_IITR [NUM_ROW-1:0][NUM_COL-1:0];
    PE_ITR #(DATA_WIDTH) PE_OITR [NUM_ROW-1:0][NUM_COL-1:0];

    

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
        .UniV_BUS_CTRL(UniV_BUS_CTRL)
    )
    
    genvar i, j;
    generate
        for(i=0; i<NUM_ROW; i=i+1) begin : row_interface

            for(j=0; j<NUM_COL; j=j+1) begin : col_interface
            end 
        end 

    endgenerate
    genvar i, j;
    generate // instantiate Global PE Array
        for(i=0; i<NUM_ROW; i=i+1) begin : row_gen
            for(j=0; j<NUM_COL; j=j+1) begin : col_gen
                glb_PE #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .NUM_COL(NUM_COL)
                ) glb_PE_inst(
                    .clk(clk),
                    .rstn(rstn),
                    .external(external),
                    .BUS_IF(UniV_XBUS_IF[i]),
                    .PE_ITR(PE_IITR[i][j]),
                    .PE_ITR(PE_OITR[i][j])
                )

            end 
        end 

    endgenerate

endmodule