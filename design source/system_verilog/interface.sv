`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Interface header
// Module Name: interface
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

`ifndef INTERFACE_SV
`define INTERFACE_SV

    interface CASTER_IF #(
            parameter DATA_WIDTH = 16,
            parameter NUM_COL = 4
        )();
        // Interface signals
        logic [DATA_WIDTH-1:0] data_B2C;  // Data from BUS to CASTER
        logic [DATA_WIDTH-1:0] data_C2B;  // Data from CASTER to BUS
    
        logic [DATA_WIDTH-1:0] data_C2P;  // Data from CASTER to PE
        logic [DATA_WIDTH-1:0] data_P2C;  // Data from PE to CASTER
    
        logic [$clog2(NUM_COL)-1:0] ID;  // Column index
        logic [$clog2(NUM_COL)-1:0] TAG;  // Column tag
    
    
        logic PE_READY;                   // Indicates PE is ready to accept data
        logic PE_VALID;                   // Indicates PE is valid to send data
    
        logic CASTER_READY;               // Indicates CASTER is ready
        logic CASTER_VALID;               // Indicates CASTER is valid
    
        logic PE_EN;                      // Enable signal for PE
        logic CASTER_EN;                  // Enable signal for CASTER
    
    
        // CASTER modport: Used for the CASTER logic to interact with the BUS
        modport CASTER_port(
            input data_B2C,
            output data_C2B,
            input data_P2C,
            output data_C2P,
            input ID,
            input TAG,
            output PE_READY,
            input PE_VALID,
            
            
            input CASTER_READY,
            output CASTER_VALID,
            input CASTER_EN,
            output PE_EN     
        );
    endinterface // caster interface
    
    interface BUS_IF #(
            parameter DATA_WIDTH = 16,
            parameter NUM_COL = 4
        )();
        logic [$clog2(NUM_COL)-1:0] ID;  // Column index
        logic [$clog2(NUM_COL)-1:0] TAG;  // Column tag
    
        logic [DATA_WIDTH-1:0] ifmap_data_B2M;  // IFMAP from BUS to MultiCaster
        logic [DATA_WIDTH-1:0] fltr_data_B2M;  // Filter from BUS to MultiCaster
        logic [2*DATA_WIDTH-1:0] psum_data_B2M;  // Partial sum from BUS to MultiCaster
    
        logic [DATA_WIDTH-1:0] ifmap_data_M2B;  // IFMAP from MultiCaster to BUS
        logic [DATA_WIDTH-1:0] fltr_data_M2B;  // Filter from MultiCaster to BUS
        logic [2*DATA_WIDTH-1:0] psum_data_M2B;  // Partial sum from MultiCaster to BUS
    
        //logic [DATA_WIDTH-1:0] ifmap_data_M2P;  // IFMAP from BUS to PE
        //logic [DATA_WIDTH-1:0] fltr_data_M2P;  // Filter from BUS to PE
        //logic [2*DATA_WIDTH-1:0] psum_data_M2P;  // Partial sum from BUS to PE
    
        //logic [DATA_WIDTH-1:0] ifmap_data_P2M;  // IFMAP from PE to BUS
        //logic [DATA_WIDTH-1:0] fltr_data_P2M;  // Filter from PE to BUS
        //logic [2*DATA_WIDTH-1:0] psum_data_P2M;  // Partial sum from PE to BUS
    
    
    
    
        logic CASTER_EN;  // Enable signal for CASTER from BUS
        logic READY;  // Indicates CASTER is ready
        logic VALID;
        logic [7:0] kernel_size;
        //logic [2:0] PE_EN;
        //logic PE_READY;
        //logic PE_VALID;
    
    
    
    
        
    
        // Interface signals

        modport BUS_port(

            output ifmap_data_B2M,
            input ifmap_data_M2B,

            output fltr_data_B2M,
            input fltr_data_M2B,

            output psum_data_B2M,
            input psum_data_M2B,


            output CASTER_EN,
            output READY,
            input VALID,

            input ID,
            input TAG,
            
            output kernel_size
        );


        modport MCASTER_port(
            input ifmap_data_B2M,
            output ifmap_data_M2B,
    
            input fltr_data_B2M,
            output fltr_data_M2B,
    
            input psum_data_B2M,
            output psum_data_M2B,

            input CASTER_EN,
            input READY,
            output VALID,
    
    
            //output PE_EN,
            //input PE_READY,
            //input PE_VALID,
    
            input ID,
            input TAG,
            
            input kernel_size
        );
    endinterface // bus interface

    interface PE_IF#(
        parameter DATA_WIDTH = 16
         )();
        //data from multicaster to PE
        logic [DATA_WIDTH-1:0] ifmap_data_M2P;
        logic [DATA_WIDTH-1:0] fltr_data_M2P;
        logic [2*DATA_WIDTH-1:0] psum_data_M2P;

        //data from PE to mutlticaster
        logic [DATA_WIDTH-1:0] ifmap_data_P2M;
        logic [DATA_WIDTH-1:0] fltr_data_P2M;
        logic [2*DATA_WIDTH-1:0] psum_data_P2M;

        //PE enable signal
        logic PE_EN;

        //PE READY and VALID signals
        logic READY;
        logic VALID;
        logic [7:0] kernel_size;


        //PE modport
        modport PE_port(
            input ifmap_data_M2P,
            input fltr_data_M2P,
            input psum_data_M2P,
            output ifmap_data_P2M,
            output fltr_data_P2M,
            output psum_data_P2M,
            input PE_EN,
            input READY,
            output VALID,
            input kernel_size
        );

        //MultiCaster modport
        modport MC_port(
            output ifmap_data_M2P,
            output fltr_data_M2P,
            output psum_data_M2P,
            input ifmap_data_P2M,
            input fltr_data_P2M,
            input psum_data_P2M,
            output PE_EN,
            output READY,
            input VALID,
            output kernel_size
        );
    endinterface // pe interface
    
    interface PE_ITR #(
        parameter DATA_WIDTH = 16
        )();
        logic [DATA_WIDTH-1:0] ifmap_data_P2P;
        logic [DATA_WIDTH-1:0] fltr_data_P2P;
        logic [2*DATA_WIDTH-1:0] psum_data_P2P;
        logic READY;
        logic VALID;

        modport IN_port(
            input ifmap_data_P2P,
            input fltr_data_P2P,
            input psum_data_P2P,
            output READY,
            input VALID
        );

        modport OUT_port(
            output ifmap_data_P2P,
            output fltr_data_P2P,
            output psum_data_P2P,
            input READY,
            output VALID
        );
    endinterface // pe interconnect

    interface BUS_ITR #(
        parameter DATA_WIDTH = 16
        )();
        logic [DATA_WIDTH-1:0] ifmap_data;
        logic [DATA_WIDTH-1:0] fltr_data;
        logic [2*DATA_WIDTH-1:0] psum_data;

        modport IN(
            input ifmap_data,
            input fltr_data,
            input psum_data
        );

        modport OUT(
            output ifmap_data,
            output fltr_data,
            output psum_data
        );
    endinterface // bus interconnect

    interface GLB_IF #(
        parameter DATA_WIDTH = 16,
        parameter GLB_DEPTH = 1024
        )();
        logic [$clog2(GLB_DEPTH)-1:0] ADDR;
        logic [DATA_WIDTH-1:0] DATA_IN;
        logic [DATA_WIDTH-1:0] DATA_OUT;
        logic RST;
        logic WEN;
        logic RST_BUSY;
        logic EN;

        modport GLB_port(
            input ADDR,
            input DATA_IN,
            output DATA_OUT,
            input RST,
            input WEN,
            output RST_BUSY,
            input EN
        );
    endinterface

    interface FIFO_IF #(
        parameter DATA_WIDTH = 8,
        parameter FIFO_DEPTH = 16
        )();
            logic wr_clk;
            logic rd_clk;
            logic rst;
            logic wr_en;
            logic rd_en;
            logic [DATA_WIDTH-1:0] wr_data;
            logic [DATA_WIDTH-1:0] rd_data;
            logic full;
            logic empty;

            modport FIFO_port(
                input wr_clk,
                input rd_clk,
                input rst,
                input wr_en,
                input rd_en,
                output wr_data,
                input rd_data,
                output full,
                output empty
            );
    endinterface

`endif


