`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2025 05:10:42 PM
// Design Name: 
// Module Name: tagBuff
// Project Name: 
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


module tagBuff #(
    parameter NUM_COL = 4
    )(
    input clk,
    input rstn,
    input flush,
    input [$clog2(NUM_COL)-1:0] tag_in,
    output [$clog2(NUM_COL)-1:0] tag_out,
    output tag_lock
    );
    
    reg [$clog2(NUM_COL)-1:0] tag;
    reg [$clog2(NUM_COL)-1:0] next_tag;
    reg lock;
    assign tag_out = tag_in;
    assign tag_lock = lock;
    reg next_lock;
 
    always@(*) begin
        if(~lock) begin
            if(flush && tag_in > tag) begin
                next_tag = tag_in;
                next_lock <= 1;
            end else begin
                next_tag = tag;
                next_lock = 0;
            end 
        end else begin
            next_lock = next_lock;
            next_tag = next_tag;
        end 
    end 
    
    always @(posedge clk or negedge rstn) begin
        if(~rstn) begin
            tag <= 0;
            lock <= 0;
        end else begin
            tag <= next_tag;
            lock <= next_lock;
        end 
    end 
endmodule
