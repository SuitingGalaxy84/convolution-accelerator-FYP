`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE Data MultiCaster (Parsed)
// Module Name: multicaster
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

module MultiCaster #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input wire clk,
    input wire rstn,
    BUS_IF.MCASTER_port BUS_IF,
    PE_IF.MC_port PE_IF
);
    
    CASTER_IF #(DATA_WIDTH, NUM_COL) ifmap_CASTER();
    CASTER_IF #(DATA_WIDTH, NUM_COL) fltr_CASTER();
    CASTER_IF #(2*DATA_WIDTH, NUM_COL) psum_CASTER();

    caster #(DATA_WIDTH, NUM_COL) ifmap_caster(clk, rstn, ifmap_CASTER.CASTER_port);
    caster #(DATA_WIDTH, NUM_COL) fltr_caster(clk, rstn, fltr_CASTER.CASTER_port);
    caster #(2*DATA_WIDTH, NUM_COL) psum_caster(clk, rstn, psum_CASTER.CASTER_port);
    
    
    /* Parsing Three Casters into One MultiCaster Begin */
        //transfer data from the BUS to the caster
        assign BUS_IF.ifmap_data_B2M = ifmap_CASTER.data_B2C;
        assign BUS_IF.fltr_data_B2M = fltr_CASTER.data_B2C;
        assign BUS_IF.psum_data_B2M = psum_CASTER.data_B2C;

        //transfer data from the caster to the bus
        assign ifmap_CASTER.data_C2B = BUS_IF.ifmap_data_M2B;
        assign fltr_CASTER.data_C2B = BUS_IF.fltr_data_M2B;
        assign psum_CASTER.data_C2B = BUS_IF.psum_data_M2B;

        //transfer data from the PE to the caster
        assign ifmap_CASTER.data_P2C = PE_IF.ifmap_data_P2M;
        assign fltr_CASTER.data_P2C = PE_IF.fltr_data_P2M;
        assign psum_CASTER.data_P2C = PE_IF.psum_data_P2M;

        //transfer data from the caster to PE
        assign PE_IF.ifmap_data_M2P = ifmap_CASTER.data_C2P;
        assign PE_IF.fltr_data_M2P = fltr_CASTER.data_C2P;
        assign PE_IF.psum_data_M2P = psum_CASTER.data_C2P;

        assign PE_IF.PE_EN = ifmap_CASTER.PE_EN & 
                             fltr_CASTER.PE_EN & 
                             psum_CASTER.PE_EN; // PE_EN signal enables the PE from the CASTER to perform the calculation

        assign PE_IF.PE_READY = ifmap_CASTER.PE_READY;
        assign PE_IF.PE_READY = fltr_CASTER.PE_READY;
        assign PE_IF.PE_READY = psum_CASTER.PE_READY;

        assign PE_IF.PE_VALID = ifmap_CASTER.PE_VALID;
        assign PE_IF.PE_VALID = fltr_CASTER.PE_VALID;
        assign PE_IF.PE_VALID = psum_CASTER.PE_VALID;


         //assign BUS_IF.ifmap_data_M2P = ifmap_CASTER.data_C2P;
         //assign BUS_IF.fltr_data_M2P = fltr_CASTER.data_C2P;
         //assign BUS_IF.psum_data_M2P = psum_CASTER.data_C2P;

         //assign ifmap_CASTER.data_B2C = BUS_IF.ifmap_data_P2M;
         //assign fltr_CASTER.data_B2C = BUS_IF.fltr_data_P2M;
         //assign psum_CASTER.data_B2C = BUS_IF.psum_data_P2M;
         //Allocate the CASTER_EN signal to the corresponding CASTER
        
        assign ifmap_CASTER.CASTER_EN = BUS_IF.CASTER_EN[0]; // The BUS want to enable the ifmap_CASTER
        assign fltr_CASTER.CASTER_EN = BUS_IF.CASTER_EN[1]; // The BUS want to enable the fltr_CASTER
        assign psum_CASTER.CASTER_EN = BUS_IF.CASTER_EN[2]; // The BUS want to enable the psum_CASTER

         //READY (Output) signal notifies the BUS->BUFFER that the PE is ready to accept data ()
        assign BUS_IF.CASTER_READY = ifmap_CASTER.CASTER_READY & 
                                       fltr_CASTER.CASTER_READY & 
                                       psum_CASTER.CASTER_READY; 

        // VALID (Output) signal notifies the BUS that the calculation is done
        assign BUS_IF.CASTER_VALID = ifmap_CASTER.CASTER_VALID & 
                                      fltr_CASTER.CASTER_VALID & 
                                       psum_CASTER.CASTER_VALID; // VALID (Output) signal notifies the BUS that the calculation is done
    
        // PE_EN signal enables the PE from the CASTER to perform the calculation
        //assign BUS_IF.PE_EN = ifmap_CASTER.PE_EN & 
        //                       fltr_CASTER.PE_EN & 
        //                       psum_CASTER.PE_EN; // PE_EN signal enables the PE from the CASTER to perform the calculation
                               
        //assign ifmap_CASTER.PE_READY = BUS_IF.PE_READY;
        //assign fltr_CASTER.PE_READY = BUS_IF.PE_READY;
        //assign psum_CASTER.PE_READY = BUS_IF.PE_READY;
        
        //assign ifmap_CASTER.PE_VALID = BUS_IF.PE_VALID;
        //assign fltr_CASTER.PE_VALID = BUS_IF.PE_VALID;
        //assign psum_CASTER.PE_VALID = BUS_IF.PE_VALID;
                                
        assign ifmap_CASTER.TAG = BUS_IF.TAG;
        assign fltr_CASTER.TAG = BUS_IF.TAG;
        assign psum_CASTER.TAG = BUS_IF.TAG;
        
        assign ifmap_CASTER.ID = BUS_IF.ID;
        assign fltr_CASTER.ID =  BUS_IF.ID;
        assign psum_CASTER.ID =  BUS_IF.ID;
        
    /* Parsing Three Casters into One MultiCaster End */
        





endmodule // MultiCaster