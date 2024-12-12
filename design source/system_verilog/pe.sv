`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Processing Element
// Module Name: PE
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

// Processing Element (PE) Module
module SV_PE #(
    parameter DATA_WIDTH = 16
)(
    input logic rstn,
    input logic clk,
    input logic external,
    PE_IF.PE_port PE_IF,
    // input mult_seln,
    // input acc_seln// PE control interface
    PE_ITR.IN_port PE_IITR,
    PE_ITR.OUT_port PE_OITR
);

    wire [DATA_WIDTH-1:0] ifmap_data;
    wire [DATA_WIDTH-1:0] fltr_data;
    wire [2*DATA_WIDTH-1:0] ipsum_data;
    wire [2*DATA_WIDTH-1:0] opsum_data;
    wire READY; 
    
    assign READY = external ? PE_IF.READY : PE_IITR.READY;
    assign ifmap_data = external ? PE_IF.ifmap_data_M2P : PE_IITR.ifmap_data_P2P;
    assign fltr_data = PE_IF.fltr_data_M2P;//external ? PE_IF.fltr_data_M2P : PE_IITR.fltr_data_P2P;
    assign ipsum_data = ipsum_seln ? 0 : (external ? PE_IF.psum_data_M2P : PE_IITR.psum_data_P2P);
    
    shifter #(
        .DATA_WIDTH(2*DATA_WIDTH),
        .SHIFT_DEPTH(2)
        ) shifter_PSUM (
            .clk(clk),
            .rstn(rstn),
            .serial_in(opsum_data),
            .serial_out(),
            .output_depth(0),
            .depth_output(PE_OITR.psum_data_P2P)
        );
        
    shifter #(
        .DATA_WIDTH(DATA_WIDTH),
        .SHIFT_DEPTH(8)
        ) shifter_IFMAP (
            .clk(clk),
            .rstn(rstn),
            .serial_in(ifmap_data),
            .serial_out(),
            .output_depth(PE_IF.kernel_size+1),
            .depth_output(PE_OITR.ifmap_data_P2P)
        );
        
    shifter #(
        .DATA_WIDTH(DATA_WIDTH),
        .SHIFT_DEPTH(8)
        ) shifter_FLTR (
            .clk(clk),
            .rstn(rstn),
            .serial_in(fltr_data),
            .serial_out(),
            .output_depth(PE_IF.kernel_size+1),
            .depth_output(PE_OITR.fltr_data_P2P)
        );


    // Local signals for the PE datapath
    wire [2*DATA_WIDTH-1:0] MULT_result;
    reg [2*DATA_WIDTH-1:0] pip_reg_1, pip_reg_2;
    wire [2*DATA_WIDTH-1:0] MAC_result;

    // local control signals
    wire mult_seln;
    wire acc_seln;
    wire opsum_seln;
    wire ipsum_seln;
    wire hold_psum;
    
    // Multiplier instantiation
//    Multiplier_2 #(
//        .DATA_WIDTH(DATA_WIDTH)
//    ) mul_1 (
//        .clk(clk),
//        .rstn(rstn),
//        .en(PE_IF.PE_EN),
//        .a(PE_IF.ifmap_data_M2P),
//        .b(PE_IF.fltr_data_M2P),
//        .result(MULT_result)
//    );
    wire mult_en;
    assign mult_en = ~opsum_seln;
    mult_gen_0 mult_gen_0(
        .CLK(clk),
        .A(ifmap_data),
        .B(fltr_data),
        .P(MULT_result),
        .SCLR(mult_en)
    );

    // MAC operation
    assign MAC_result = pip_reg_2 + (mult_seln ? ipsum_data : MULT_result);
    
    assign PE_IF.psum_data_P2M = opsum_seln ? {2*DATA_WIDTH{1'b0}} : MAC_result;
    assign opsum_data = opsum_seln ? {2*DATA_WIDTH{1'b0}} : MAC_result;

    assign PE_IF.VALID = ~opsum_seln;
    assign PE_OITR.VALID = ~opsum_seln;

    // Pipeline registers for the accumulator
    always_ff @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            pip_reg_2 <= 0;
            pip_reg_1 <= 0;
        end else begin
            if(~opsum_seln) begin
                pip_reg_2 <= {2*DATA_WIDTH{1'b0}};
                pip_reg_1 <= {2*DATA_WIDTH{1'b0}};
            end else begin
                //pip_reg_2 <= acc_seln ? {2*DATA_WIDTH{1'b0}} : pip_reg_1;
                pip_reg_2 <= acc_seln || hold_psum ? pip_reg_1 : MAC_result;
                pip_reg_1 <= MAC_result;
            end 
           
        end
    end

    SV_PE_ctrl PE_ctrl (
        .clk(clk),
        .READY(READY),
        .rstn(rstn),
        .mult_seln(mult_seln),
        .acc_seln(acc_seln),
        .ipsum_seln(ipsum_seln),
        .opsum_seln(opsum_seln),
        .kernel_size(PE_IF.kernel_size),
        .hold_psum(hold_psum)
    );



endmodule