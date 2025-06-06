`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Row Bus Control
// Module Name: X_BusCtrl
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

module X_BusCtrl #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4,
    parameter NUM_ROW = 4
    )(
        input wire clk,
        input wire rstn,
        input flush_tag,
        input flush_kernel,
        
        input [7:0] kernel_size,
        BUS_IF.BUS_port UniV_XBUS_IF, // a master interfaces for all the EPs
        BUS_CTRL.X_BUS_CTRL UniV_BUS_CTRL
    );
    
    

    
    assign UniV_XBUS_IF.flush_tag = flush_tag;
    assign UniV_XBUS_IF.flush_kernel = flush_kernel;
    assign UniV_XBUS_IF.kernel_size = kernel_size;


//    always_ff @(posedge clk or negedge rstn) begin : GET_ID
//        if(~rstn) begin
//            Y_ID <= 0;
//        end else begin
//            Y_ID <= UniV_BUS_CTRL.Y_ID;
//        end
        
//    end 

    wire [DATA_WIDTH-1:0] ifmap_data;
    wire [DATA_WIDTH-1:0] fltr_data;    
    wire [2*DATA_WIDTH-1:0] psum_data;
    
    assign ifmap_data = UniV_BUS_CTRL.ifmap_data_G2B;
    assign fltr_data = UniV_BUS_CTRL.fltr_data_G2B;
    assign psum_data = UniV_BUS_CTRL.psum_data_G2B;

    assign UniV_XBUS_IF.ifmap_data_B2M = ifmap_data;
    assign UniV_XBUS_IF.fltr_data_B2M = fltr_data;
    assign UniV_XBUS_IF.psum_data_B2M = psum_data;
    assign UniV_XBUS_IF.ID = UniV_BUS_CTRL.X_ID;


    
    
    
endmodule