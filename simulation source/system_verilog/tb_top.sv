//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: TOP testbench
// Module Name: tb_top
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

module tb_top#(
    parameter DATA_WIDTH = 32,
    parameter NUM_COL = 7,
    parameter NUM_ROW = 7, 
    parameter BUFFER_SIZE = 512,
    parameter CLK_PERIOD = 10, // 100MHz
    parameter PE_CLK_PERIOD = CLK_PERIOD * NUM_COL
)();

    reg clk, pe_clk, rstn;
    reg [7:0] kernel_size;
    reg load_done; 
    wire [DATA_WIDTH-1:0] ofmap_out;


    top#(.DATA_WIDTH(DATA_WIDTH), 
        .NUM_COL(NUM_COL),
        .NUM_ROW(NUM_ROW),
        .BUFFER_SIZE(BUFFER_SIZE))
    dut(
        .clk(clk),
        .pe_clk(pe_clk),
        .rstn(rstn),
        .kernel_size(kernel_size),
        .load_done(load_done),
        .ofmap_out(ofmap_out),
    );
endmodule
