`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global PE interconnected on a Row Bus
// Module Name: X_glb_PE
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

module X_glb_PE #(
    parameter DATA_WIDTH=16,
    parameter NUM_COL = 4
    )();

    // instantiate interfaces
    PE_ITR#(DATA_WIDTH) PE_IITR[NUM_COL]();
    PE_ITR#(DATA_WIDTH) PE_OITR[NUM_COL]();
    BUS_IF#(DATA_WIDTH) BUS_IF[NUM_COL]();

    genvar i;
    generate // instantiate PE

        for(i=0; i<NUM_COL; i=i+1) begin: PE_instantiation
            glb_PE #(
                .DATA_WIDTH(DATA_WIDTH),
                .NUM_COL(NUM_COL)
            ) glb_PE (
                .clk(clk),
                .rstn(rstn),
                .external(external),
                .BUS_IF(BUS_IF),
                .PE_IITR(PE_IITR[i]),
                .PE_OITR(PE_OITR[i])
            )
        end
    endgenerate

    genvar i;
    generate // connect interfaces

        for(i=0; i<NUM_COL-1; i=i+1) begin: Connect_interface


            assign BUS_IF[i+1].kernel_size = BUS_IF[i].kernel_size;

        end 

    endgenerate

endmodule