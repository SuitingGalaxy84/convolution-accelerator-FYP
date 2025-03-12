`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: GLB_BUF_READER
// Module Name: Global Buffer Writer
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

module BUF_reader#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 8,
    parameter BUFFER_SIZE = 512
)(
    input clk,
    input rstn,
    input start,
    output [$clog2(BUFFER_SIZE)-1:0] addr
);
    always_ff@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            addr <= 0;
        end else begin
            if(start) begin
                addr <= addr + 1;
            end else begin
                addr <= addr;
            end 
        end 
    end 

endmodule 
