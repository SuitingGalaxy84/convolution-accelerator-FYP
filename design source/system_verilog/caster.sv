`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE Data Caster
// Module Name: caster
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
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

module caster#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input wire clk,
    input wire rstn,
    CASTER_IF.CASTER_port CASTER_IF
    );

    assign CASTER_IF.PE_READY = CASTER_IF.CASTER_READY;
    assign CASTER_IF.CASTER_VALID = CASTER_IF.PE_VALID;

    always_comb begin: PE_to_BUS//facilitate the data output from PE to bus
        case ({CASTER_IF.PE_VALID, (CASTER_IF.TAG == CASTER_IF.ID ? 1'b1 : 1'b0)})
            2'b11 : begin 
                CASTER_IF.data_C2B = CASTER_IF.data_P2C;
            end 
            default: begin 
                CASTER_IF.data_C2B = 0;
            end 
        endcase
    end

    always_comb begin : BUS_to_PE//facilitate the data input from bus to PE
        case ({CASTER_IF.CASTER_READY, (CASTER_IF.TAG == CASTER_IF.ID ? 1'b1 : 1'b0)})
            /*
                CASTER_IF.CASTER_READY: Weight Buff and Tag Buff are correctly loaded
                CASTER_IF.TAG == CASTER_IF.ID: Data ID matches PE TAG
            */
            2'b11 : begin 
                CASTER_IF.PE_EN = 1'b1;
                CASTER_IF.data_C2P = CASTER_IF.data_B2C;
            end 
            default: begin 
                CASTER_IF.PE_EN = 1'b0;
                CASTER_IF.data_C2P = 0;
            end
        endcase
    end

endmodule