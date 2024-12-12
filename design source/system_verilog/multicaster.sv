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
    PE_IF.MC_port PE_IF,
    input PE_ITR_READY,
    input external
);
    wire [DATA_WIDTH-1:0] WeightBuff_OUT;
    CASTER_IF #(DATA_WIDTH, NUM_COL) ifmap_CASTER();
    CASTER_IF #(DATA_WIDTH, NUM_COL) fltr_CASTER();
    CASTER_IF #(2*DATA_WIDTH, NUM_COL) psum_CASTER();

    caster #(DATA_WIDTH, NUM_COL) ifmap_caster(clk, rstn, ifmap_CASTER.CASTER_port);
    caster #(DATA_WIDTH, NUM_COL) fltr_caster(clk, rstn, fltr_CASTER.CASTER_port);
    caster #(2*DATA_WIDTH, NUM_COL) psum_caster(clk, rstn, psum_CASTER.CASTER_port);
    
    
    


    /* Parsing Three Casters into One MultiCaster Begin */
        //transfer data from the BUS to the caster
        assign ifmap_CASTER.data_B2C = BUS_IF.ifmap_data_B2M;
        // assign fltr_CASTER.data_B2C = BUS_IF.fltr_data_B2M;
        assign psum_CASTER.data_B2C = BUS_IF.psum_data_B2M;
   

        //transfer data from the caster to the bus
        assign BUS_IF.ifmap_data_M2B = ifmap_CASTER.data_C2B;
        assign BUS_IF.fltr_data_M2B = fltr_CASTER.data_C2B;
        assign BUS_IF.psum_data_M2B = psum_CASTER.data_C2B;
        
        //transfer data from the PE to the caster
        assign ifmap_CASTER.data_P2C = PE_IF.ifmap_data_P2M;
        assign fltr_CASTER.data_P2C = PE_IF.fltr_data_P2M;
        assign psum_CASTER.data_P2C = PE_IF.psum_data_P2M;

        //transfer data from the caster to PE
        assign PE_IF.ifmap_data_M2P = ifmap_CASTER.data_C2P;
        assign PE_IF.fltr_data_M2P = WeightBuff_OUT; //fltr_CASTER.data_C2P;
        assign PE_IF.psum_data_M2P = psum_CASTER.data_C2P;

        assign PE_IF.PE_EN = ifmap_CASTER.PE_EN & 
                             fltr_CASTER.PE_EN & 
                             psum_CASTER.PE_EN; // PE_EN signal enables the PE from the CASTER to perform the calculation

        assign PE_IF.READY = ifmap_CASTER.PE_READY & fltr_CASTER.PE_READY & psum_CASTER.PE_READY;

        assign ifmap_CASTER.PE_VALID = PE_IF.VALID;
        assign fltr_CASTER.PE_VALID = PE_IF.VALID;
        assign psum_CASTER.PE_VALID = PE_IF.VALID;

         //assign BUS_IF.ifmap_data_M2P = ifmap_CASTER.data_C2P;
         //assign BUS_IF.fltr_data_M2P = fltr_CASTER.data_C2P;
         //assign BUS_IF.psum_data_M2P = psum_CASTER.data_C2P;

         //assign ifmap_CASTER.data_B2C = BUS_IF.ifmap_data_P2M;
         //assign fltr_CASTER.data_B2C = BUS_IF.fltr_data_P2M;
         //assign psum_CASTER.data_B2C = BUS_IF.psum_data_P2M;
         //Allocate the CASTER_EN signal to the corresponding CASTER
        
        assign ifmap_CASTER.CASTER_EN = BUS_IF.CASTER_EN; // The BUS want to enable the ifmap_CASTER
        assign fltr_CASTER.CASTER_EN = BUS_IF.CASTER_EN; // The BUS want to enable the fltr_CASTER
        assign psum_CASTER.CASTER_EN = BUS_IF.CASTER_EN; // The BUS want to enable the psum_CASTER

         //READY (Output) signal notifies the BUS->BUFFER that the PE is ready to accept data ()
        assign ifmap_CASTER.CASTER_READY = BUS_IF.READY & Buff_READY;
        assign fltr_CASTER.CASTER_READY = BUS_IF.READY & Buff_READY;
        assign psum_CASTER.CASTER_READY = BUS_IF.READY & Buff_READY;
        
        // VALID (Output) signal notifies the BUS that the calculation is done
        assign BUS_IF.VALID = ifmap_CASTER.CASTER_VALID & 
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
        
        reg [$clog2(NUM_COL)-1:0] id;
        always_ff @(posedge clk or negedge rstn) begin : GET_ID // facilitate the PE matching
            if(~rstn) begin
                id <= 0;
            end else begin
                id <= BUS_IF.ID;
            end 
        end

        reg [$clog2(NUM_COL)-1:0] tag;
        always_ff @(posedge clk or negedge rstn) begin : STORE_TAG
            if(~rstn) begin
                tag <= 0;
            end else begin
                if(BUS_IF.flush) begin
                    tag <= BUS_IF.TAG;
                end else begin
                    tag <= tag;
                end
            end 
        end 
        
        reg [7:0] kernel_size;
        always_ff @(posedge clk or negedge rstn) begin: STORE_KERNEL_SIZE
            if(~rstn) begin
                kernel_size <= 0;
            end else begin
                if(BUS_IF.flush) begin
                    kernel_size <= BUS_IF.kernel_size;
                end else begin
                    kernel_size <= kernel_size;
                end
            end
        end  
        
        wire flush_BUSY;
        assign BUS_IF.flush_BUSY = flush_BUSY;
        
        wire Buff_READY;
        assign Buff_READY = ~flush_BUSY;
        wire Buff_rden;
        assign Buff_rden = (external ? BUS_IF.READY : PE_ITR_READY) && Buff_READY;
       
        WeightBuff #(
            .DATA_WIDTH(DATA_WIDTH),
            .BUFFER_DEPTH(16)
        ) WeightBuff(
            .clk(clk),
            .rstn(rstn),
            .flush(BUS_IF.flush),
            .kernel_size(kernel_size),
            .data_in(BUS_IF.fltr_data_B2M),
            .data_out(WeightBuff_OUT),//fltr_CASTER.data_B2C),
            .pseudo_out(),
            .flush_BUSY(flush_BUSY),
            .read_VALID(read_VALID),
            .en(Buff_rden) // include:
        );

        assign ifmap_CASTER.TAG = tag;
        assign fltr_CASTER.TAG = tag;
        assign psum_CASTER.TAG = tag;
        
        assign ifmap_CASTER.ID = id;
        assign fltr_CASTER.ID =  id;
        assign psum_CASTER.ID =  id;
        
    /* Parsing Three Casters into One MultiCaster End */
        
        assign PE_IF.kernel_size = kernel_size;




endmodule // MultiCaster