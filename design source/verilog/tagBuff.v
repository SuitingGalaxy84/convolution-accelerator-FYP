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
    reg tag_lock;
    assign tag_out = tag_in;
    
    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            tag <= 0;
            tag_lock <= 0;
        end else if(flush) begin
            if(tag_lock) begin
                tag <= tag;
            end else begin
                tag <= tag_in;
                tag_lock = 1;
            end 
        end else begin
            tag <= tag;
        end 
    end 
endmodule
