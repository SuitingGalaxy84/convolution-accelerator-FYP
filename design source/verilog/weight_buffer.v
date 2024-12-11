`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: weight buffer
// Module Name: WeightBuff
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

module WeightBuff #(
        parameter DATA_WIDTH = 16,
        parameter BUFFER_DEPTH = 16
)(
    input clk,
    input rstn,
    input flush, //write enable 
    input en, //read enable
    input [7:0] kernel_size,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out,
    output [DATA_WIDTH-1:0] pseudo_out,
    output flush_READY,

    input PE_VALID
    output FLTR_READY
    
);

    reg [DATA_WIDTH-1:0] weight_buff [BUFFER_DEPTH-1:0];
    reg [7:0] wr_ptr;
    assign flush_READY = (wr_ptr==kernel_size-1) ? 1 : 0;

    localparam FLUSH_IDLE = 2'b00;
    localparam FLUSH_START = 2'b10;
    localparam FLUSH_READY = 2'b01;
    localparam FLUSH_RSET = 2'b11;

    
    wire [1:0] flush_ctrl = {flush, flush_READY};

    always @(posedge clk) begin //read
        if(flush_READY)
    end

    always @(posedge clk or negedge rstn) begin // write
        if(~rstn) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            for (int i = 0; i < BUFFER_DEPTH; i = i + 1) begin
                weight_buff[i] <= 0;
            end
        end else begin
            if(flush_ctrl==FLUSH_START || flush_ctrl==FLUSH_RSET) begin
                weight_buff[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end else if (flush_ctrl==FLUSH_READY || flush_ctrl==FLUSH_IDLE) begin
                for (int i = 0; i < BUFFER_DEPTH; i = i + 1) begin
                    weight_buff[i] <= weight_buff[i];
                end
                wr_ptr <= wr_ptr;
            end else begin
                weight_buff[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1;
            end 
        end 
    end 

endmodule 

