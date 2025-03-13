`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: GLB_BUF
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


module BUF_writer#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 8,
    parameter BUFFER_SIZE = 512
)(
    input wire clk,
    input wire rstn,
    input wire load,
    input wire [7:0] kernel_size,
    output [DATA_WIDTH-1:0] data_out,
    output [$clog2(NUM_COL):0] id_out, //extended by 1 bit
    output [$clog2(BUFFER_SIZE)-1:0] addr_out
);

    parameter MAX_RANGE = 2**(DATA_WIDTH/2);
    parameter MIN_RANGE = 0;


    reg [DATA_WIDTH-1:0] data_out_reg;
    reg [$clog2(NUM_COL):0] id_out_reg;
    reg [$clog2(BUFFER_SIZE)-1:0] addr_out_reg;
    assign data_out = data_out_reg ;
    assign id_out = id_out_reg;
    assign addr_out = addr_out_reg;

    always_ff@(posedge clk or negedge rstn) begin // id is pre-written into the global buffer
        if(~rstn) begin
            id_out_reg <= 0;
        end else if(load) begin
            if(id_out_reg < kernel_size) begin
                id_out_reg <= id_out_reg + 1;
            end else begin
                id_out_reg <= 1;
            end 
        end else begin
            id_out_reg <= id_out_reg;
        end 
    end

    always_ff@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            data_out_reg <= 0;
            addr_out_reg <= 0;
        end
        else begin
            if(load) begin
                data_out_reg <= $urandom_range(MIN_RANGE, MAX_RANGE);
                addr_out_reg <= addr_out_reg + 1;
            end
            else begin
                data_out_reg <= 0;
                addr_out_reg <= 0;
            end
        end
    end

endmodule