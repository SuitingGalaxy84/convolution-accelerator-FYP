`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE Key-Lock Checker 
// Module Name: SV_DummyPE_KL
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
/*
    a LOCK-KEY scheme is created. Every PE is assgined with a unique ROW-COL tag at the initialization. The PE
    can be activated only when the corresponding ROW-COL tag is provided. This facilitates an efficient control
    of the PE array.
 */
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "interface.sv"

module caster#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input wire clk,
    input wire rstn,
    input wire tag,
    output wire PE_en,
    BUS_CASTER_X.CASTER CASTER
    );

    reg [$clog2(NUM_COL)-1:0] caster_id; 
    always_ff @(posedge clk or negedge rstn) begin // facilitate the PE matching
        if(~rstn) begin
            caster_id <= 0;
        end else begin
            caster_id <= CASTER.col;
        end 
    end

    always_comb begin : //facilitate the data transfer between CASTER and PE
        case ({CASTER.PE_ready, CASTER.CASTER_en, (tag == caster_id ? 1'b1 : 1'b0)})
            3'b111 : begin 
                PE_en = 1'b1;
                CASTER.data_C2P = CASTER.data_B2C;
            end 
            default: begin 
                PE_en = 1'b0;
                CASTER.data_C2P = 0;
            end 
        endcase
        CASTER.CASTER_ready = PE_ready;
    end







endmodule