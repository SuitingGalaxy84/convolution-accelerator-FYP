`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Row_Bus Control
// Module Name: X_glb_PE
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


module X_BusCtrl #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4,
    parameter NUM_ROW = 4
    )(
        input wire clk,
        input wire rstn,
        input flush,
        output rst_busy,

        BUS_IF#(DATA_WIDTH) UniV_XBUS_IF, // a master interfaces for all the EPs
        BUS_CTRL#(DATA_WIDTH) UniV_BUS_CTRL,

    );
    reg [$clog2(NUM_ROW)-1:0] Y_TAG;
    reg [$clog2(NUM_ROW)-1:0] Y_ID;

    always_ff @(posedge clk) begin : STORE_Y_TAG
        if(flush) begin
            Y_TAG <= UniV_BUS_CTRL.Y_TAG;
        end else begin
            Y_TAG <= Y_TAG;
        end
    end 

    always_ff @(posedge clk or negedge rstn) begin : GET_ID
        if(~rstn) begin
            Y_ID <= 0;
            X_ID <= 0;
        end else begin
            Y_ID <= UniV_BUS_CTRL.Y_ID;
            X_ID <= UniV_BUS_CTRL.X_ID;
        end 
    end 

    wire [DATA_WIDTH-1:0] ifmap_data;
    wire [DATA_WIDTH-1:0] fltr_data;    
    wire [2*DATA_WIDTH-1:0] psum_data;

    assign ifmap_data = (Y_TAG == Y_ID) ? UniV_BUS_CTRL.ifmap_data_G2B : 0;
    assign fltr_data = (Y_TAG == Y_ID) ? UniV_BUS_CTRL.fltr_data_G2B : 0;
    assign psum_data = (Y_TAG == Y_ID) ? UniV_BUS_CTRLpsum_data_G2B : 0;

    assign UniV_XBUS_IF.ifmap_data_B2M = ifmap_data;
    assign UniV_XBUS_IF.fltr_data_B2M = fltr_data;
    assign UniV_XBUS_IF.psum_data_B2M = psum_data;


    
    
    
endmodule