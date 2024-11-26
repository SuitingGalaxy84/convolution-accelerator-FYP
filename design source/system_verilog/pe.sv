`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE
// Module Name: SV_PE
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: Processing Element for Convolution Accelerator
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

// Processing Element (PE) Module
module SV_PE #(
    parameter DATA_WIDTH = 16,
    parameter BUFFER_DEPTH = 3
)(
    input logic rstn,
    input logic clk,
    PE_DATA.PE DATA // PE data interface
    PE_CTRL.PE CTRL // PE control interface
);

    // Local signals for the PE datapath
    wire [2*DATA_WIDTH-1:0] MULT_result;
    reg [2*DATA_WIDTH-1:0] pip_reg_1, pip_reg_2;
    wire [2*DATA_WIDTH-1:0] MAC_result;

    // Multiplier instantiation
    Multiplier_2 #(
        .DATA_WIDTH(DATA_WIDTH)
    ) mul_1 (
        .clk(clk),
        .rst(~rstn),
        .a(DATA.ifmap),
        .b(DATA.fltr),
        .result(MULT_result)
    );

    // MAC operation
    assign MAC_result = (DATA.ipsum + (CTRL.mult_seln ? MULT_result : pip_reg_2));
    assign DATA.opsum = MAC_result;

    // Pipeline registers for the accumulator
    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            pip_reg_1 <= 0;
            pip_reg_2 <= 0;
        end else begin
            pip_reg_1 <= MAC_result;
            pip_reg_2 <= CTRL.acc_seln ? {2*DATA_WIDTH{1'b0}} : pip_reg_1;
        end
    end

endmodule