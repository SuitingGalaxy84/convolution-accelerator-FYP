//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: TOP
// Module Name: TOP Parser
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

module top#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7,
    parameter BUFFER_SIZE = 512
)(
    input clk,
    input pe_clk,
    input rstn,
    input [7:0] kernel_size,
    input load_done,
    output [2*DATA_WIDTH-1:0] ofmap_out
);

    conv_operator#(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .BUFFER_SIZE(BUFFER_SIZE)
    ) conv_operator_inst(
        .clk(clk),
        .rstn(rstn),
        .pe_clk(pe_clk),
        .kernel_size(kernel_size),
        .ofmap_out(ofmap_out),
        .load_done(load_done)
    );

endmodule