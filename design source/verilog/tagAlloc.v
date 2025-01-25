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
    input  wire [$clog2(NUM_COL)-1:0]    tag_in, 
    input wire [NUM_COL-1:0] tag_locks,
    output wire [NUM_COL-1:0][$clog2(NUM_COL)-1:0] tag_out 
);

    // Register array to store the shifting data
    reg [$clog2(NUM_COL)-1:0] tag_reg [NUM_COL-1:0];
    
    
    genvar j;
    generate
    for(j=0;j<NUM_COL;j=j+1) begin
        assign tag_out[j] = tag_locks[j] ? 0 : tag_reg[j];
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
                tag_reg[i+1] <= tag_locks[i] ? tag_reg[i] : 0;
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
