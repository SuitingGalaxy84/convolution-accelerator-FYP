`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Control Unit for PE Array 
// Module Name: PEA_control
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

module PEA_control#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512
)
(
    input clk,
    input rstn,
    //control signals
    output reg load_ifmap,
    output reg load_fltr, 
    output reg load_psum,
    input reg load_done,

    output reg start, 
    output reg flush_tag, 
    output reg flush_kernel, 
    
    //status signals
    input ram_rst_busy, 
    input tag_busy, 
    input [NUM_ROW-1:0] kernel_busy,
    input [NUM_ROW-1:0] ram_load_busy, 
    input [NUM_ROW-1:0] full
);

/*
    define states
    IDEL: control signal all zero & all status signal zero
    RSTED: control signal all zero & ram_rst_busy = 1
    LOAD_IFMAP: FIXME need a load_ifmap_done signal
    LOAD_FLTR: FIXME need a load_fltr_done signal
    LOAD_PSUM: FIXME need a load_psum_done signal
*/
    parameter IDEL = 4'b0000;
    parameter FLUSH_TAG = 4'b0101;
    parameter LOAD_IFMAP = 4'b0010;
    parameter LOAD_FLTR = 4'b0011;
    parameter LOAD_PSUM =4'b0100;
    parameter FLUSH_KERNEL = 4'b0110;
    parameter COMPUTE = 4'b0111;
    parameter DONE = 4'b1000;

    reg [3:0] state, next_state;
    always_ff@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            state <= IDEL;
        end
        else if (ram_rst_busy==0) begin
            state <= next_state;
        end else begin
            state <= IDEL;
        end
    end

    always_comb@(*) begin
        case(state)
            IDEL: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 0;
                next_state = flush_tag ? FLUSH_TAG : IDEL;
            end
            FLUSH_TAG: begin
                start = 0;
                flush_tag = 1;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 0;
                next_state = tag_busy ? FLUSH_TAG : LOAD_IFMAP;
            end 
            LOAD_IFMAP: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 1;
                load_fltr = 0;
                load_psum = 0;
                next_state = load_done ? LOAD_FLTR : LOAD_IFMAP;
            end 
            LOAD_FLTR: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 1;
                load_psum = 0;
                next_state = load_done ? LOAD_PSUM : LOAD_FLTR;
            end 
            LOAD_PSUM: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 1;
                next_state = load_done ? FLUSH_KERNEL : LOAD_PSUM;
            end 
            FLUSH_KERNEL: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 1;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 0;
                next_state = kernel_busy ? FLUSH_KERNEL : COMPUTE;
            end 
            COMPUTE: begin
                start = 1;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 0;
                next_state = COMPUTE; //FIXME
            end 
            DONE: begin
                start = 0;
                flush_tag = 0;
                flush_kernel = 0;
                load_ifmap = 0;
                load_fltr = 0;
                load_psum = 0;
                next_state = IDEL;
            end
        endcase
    end


endmodule 