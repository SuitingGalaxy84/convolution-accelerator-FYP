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

    CASTER_IF.CASTER_port CASTER_port
    );

    reg [$clog2(NUM_COL)-1:0] caster_id; 
    always_ff @(posedge clk or negedge rstn) begin // facilitate the PE matching
        if(~rstn) begin
            caster_id <= 0;
        end else begin
            caster_id <= CASTER_port.ID;
        end 
    end

    always_comb begin: PE_to_BUS//facilitate hte data output from PE to bus
        case ({CASTER_port.PE_VALID, CASTER_port.CASTER_EN, (CASTER_port.TAG == caster_id ? 1'b1 : 1'b0)})
            3'b111 : begin 
                CASTER_port.data_C2B = CASTER_port.data_P2C;
            end 
            default: begin 
                CASTER_port.data_C2B = 0;
            end 
        endcase
        CASTER_port.CASTER_VALID = CASTER_port.PE_VALID; // notify the BUS that the PE has valid data
    end

    always_comb begin : BUS_to_PE//facilitate the data input from bus to PE
        case ({CASTER_port.PE_READY, CASTER_port.CASTER_EN, (CASTER_port.TAG == caster_id ? 1'b1 : 1'b0)})
            3'b111 : begin 
                CASTER_port.PE_EN = 1'b1;
                CASTER_port.data_C2P = CASTER_port.data_B2C;
            end 
            default: begin 
                CASTER_port.PE_EN = 1'b0;
                CASTER_port.data_C2P = 0;
            end
        endcase
        CASTER_port.CASTER_READY = CASTER_port.PE_READY; // notify the BUS that the PE is ready to accept data
    end







endmodule