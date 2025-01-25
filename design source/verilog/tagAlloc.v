`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: tag allocator
// Module Name: tagAlloc
// Project Name: Convolution Accelerator for PyTorch Deep Learning Framework
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

module tagAlloc #(
    parameter NUM_COL    = 8    // Depth of the shift register   
)(
    input  wire                     clk,    
    input  wire                     rstn,    
    input  wire                     flush,  
    input  wire [$clog2(NUM_COL):0]    tag_in, //extended by 1 bit
    input wire [NUM_COL-1:0] tag_locks,
    input wire [7:0] kernel_size,
    output wire [NUM_COL-1:0][$clog2(NUM_COL):0] tag_out, //extended by 1 bit
    output reg flush_busy
);

    // Register array to store the shifting data
    reg [$clog2(NUM_COL):0] tag_reg [NUM_COL-1:0];//extended by 1 bit
    wire [NUM_COL-1:0] lock_mask;
    wire [NUM_COL-1:0] masked_locks;
    assign lock_mask = ~((1'b1 << kernel_size) - 1'b1);
    assign masked_locks = (tag_locks & ~lock_mask) | lock_mask;
    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            flush_busy <= 0;
        end else begin
            flush_busy <= flush ? (&masked_locks ? 1'b0 : 1'b1) : 1'b0;
        end 
    end 
    
    genvar j;
    generate
    for(j=0;j<NUM_COL;j=j+1) begin
        assign tag_out[j] = masked_locks[j] ? 0 : tag_reg[j];
    end 
    endgenerate 
    integer i;
    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            for(i=0; i<NUM_COL; i=i+1) begin
                tag_reg[i] <= 0;
            end
        end else begin 
            for(i=0; i<NUM_COL-1; i=i+1) begin
                tag_reg[i+1] <= masked_locks[i] ? tag_reg[i] : 0;
            end 
        end 
    end 

    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            tag_reg[0] <= 0;
        end else if(flush) begin
            tag_reg[0] <= tag_in;
        end else begin
            tag_reg[0] <= tag_reg[0];
        end
    end 
    
endmodule
