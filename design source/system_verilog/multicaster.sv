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
    input wire pe_clk,
    input wire rstn,
    input wire [$clog2(NUM_COL):0] tag_in, // extended by 1 bit
    input wire ccd_rden,
    BUS_IF.MCASTER_port BUS_IF,
    PE_IF.MC_port PE_IF,
    input PE_ITR_READY,
    output tag_lock,
    output external
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

        assign PE_IF.PE_EN = ifmap_CASTER.PE_EN & fltr_CASTER.PE_EN & psum_CASTER.PE_EN; // PE_EN writes the data to the buffer
        

        assign PE_IF.READY = ifmap_CASTER.PE_READY & fltr_CASTER.PE_READY & psum_CASTER.PE_READY; // PE_READY starts the PE calculation

        assign ifmap_CASTER.PE_VALID = PE_IF.VALID;
        assign fltr_CASTER.PE_VALID = PE_IF.VALID;
        assign psum_CASTER.PE_VALID = PE_IF.VALID;



         //Weight Buffer and Tag Buffer notify the CASTER that the PE is okay to receive ifmap data
        assign ifmap_CASTER.CASTER_READY = Fltr_READY && Tag_READY;
        assign fltr_CASTER.CASTER_READY =  Fltr_READY && Tag_READY;
        assign psum_CASTER.CASTER_READY = Fltr_READY && Tag_READY;
        
        // VALID (Output) signal notifies the BUS that the calculation is done
        assign BUS_IF.VALID = ifmap_CASTER.CASTER_VALID & 
                                      fltr_CASTER.CASTER_VALID & 
                                       psum_CASTER.CASTER_VALID; // VALID (Output) signal notifies the BUS that the calculation is done
    
        
        wire [$clog2(NUM_COL):0] id; // extended by 1 bit 
        assign id = BUS_IF.ID;
        wire [$clog2(NUM_COL):0] tag;    // extended by 1 bit
        
        tagBuff #(
            .NUM_COL(NUM_COL)
        ) tagBuff_inst(
            .clk(clk),
            .rstn(rstn),
            .flush_tag(BUS_IF.flush_tag),
            .tag_in(tag_in),
            .tag_out(tag),
            .tag_lock(tag_lock)
        );

        
        reg [7:0] kernel_size;
        always_ff @(posedge clk or negedge rstn) begin: STORE_KERNEL_SIZE
            if(~rstn) begin
                kernel_size <= 0;
            end else begin
                if(BUS_IF.flush_kernel) begin
                    kernel_size <= BUS_IF.kernel_size;
                end else begin
                    kernel_size <= kernel_size;
                end
            end
        end  
        
        wire kernel_busy, un_configed;
        assign BUS_IF.kernel_busy = kernel_busy;
        
        wire Fltr_READY;
        assign Fltr_READY = ~kernel_busy && (~un_configed);
        wire Tag_READY;
        assign Tag_READY = tag_lock;
       
       
        reg external;
        always_ff@(posedge clk or negedge rstn) begin
            if(~rstn) begin
                external <= 1;
            end else begin
                if(PE_IF.PE_EN) begin
                    external <= 1;
                end else if (PE_ITR_READY) begin
                    external <= 0;
                end else begin
                    external <= external;
                end 
            end 
        end 
        wire Buff_rden; 
        assign Buff_rden = (Fltr_READY && Fltr_READY)&& (external ? ccd_rden : PE_ITR_READY); // read kernel weight from the weight buffer
       /*
            Fltr_READY: Weight Buffer is correctly loaded
            Tag_READY: Tag Buffer is correctly loaded
            
            PE_ITR_READY: PE is available for another calculation (Recieving data from another PE)
            ccd_rden: PE is enabled by the external data
       */
        WeightBuff #(
            .DATA_WIDTH(DATA_WIDTH),
            .BUFFER_DEPTH(16)
        ) WeightBuff(
            .clk(clk),
            .pe_clk(pe_clk),
            .rstn(rstn),
            .flush_kernel(BUS_IF.flush_kernel),
            .kernel_size(kernel_size),
            .data_in(BUS_IF.fltr_data_B2M),
            .data_out(WeightBuff_OUT),//fltr_CASTER.data_B2C),
            .pseudo_out(),
            .kernel_busy(kernel_busy),
            .un_configed(un_configed),
            .rd_en(Buff_rden) // include:
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