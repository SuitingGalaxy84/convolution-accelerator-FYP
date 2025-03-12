`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: GLB_BUF
// Module Name: Global Buffer
// Project Name: COnvolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "interface.sv"

module GLB_BUF#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 8,
    parameter BUFFER_SIZE = 512
)(
    input bus_clk,
    input rstn,
    
    
    input load_ifmap, 
    input load_fltr,
    input flush_tag,
    input flush_kernel,
    input start,
    
    
    input [$clog2(BUFFER_SIZE)-1:0] addr_in,
    input [DATA_WIDTH + $clog2(NUM_COL):0] data_in,
    input [7:0] kernel_size,
    
    input [$clog2(BUFFER_SIZE)-1:0] fltr_addr_in,
    input [DATA_WIDTH-1:0] fltr_data_in,
    
    
    BUS_CTRL.Test_XBUS_CTRL UniV_BUS_CTRL_IF,
    output ram_rst_busy,
    output reg ram_load_busy,
    output full
);
    wire rstb_busy_ifmap, rsta_busy_ifmap;
    wire rsta_busy_fltr, rstb_busy_fltr;
    assign ram_rst_busy = rstb_busy_ifmap | rsta_busy_ifmap | rsta_busy_fltr | rstb_busy_fltr;



    reg [$clog2(BUFFER_SIZE)-1:0] read_addr;
    reg [$clog2(BUFFER_SIZE)-1:0] fltr_addr;
    // tag generator for data
    reg [15:0] data_counter;
    reg [$clog2(NUM_COL):0] X_TAG; //extended by 1 module AND2B1L
    
    wire [DATA_WIDTH + $clog2(NUM_COL):0] data_out;
    wire [DATA_WIDTH-1:0] fltr_out;
    
    
    assign UniV_BUS_CTRL_IF.X_ID = data_out [$clog2(NUM_COL):0];
    assign UniV_BUS_CTRL_IF.ifmap_data_G2B = data_out[DATA_WIDTH + $clog2(NUM_COL): $clog2(NUM_COL)+1];
    assign UniV_BUS_CTRL_IF.fltr_data_G2B = fltr_out;
    assign UniV_BUS_CTRL_IF.X_TAG = X_TAG;
    assign full = (data_counter == BUFFER_SIZE) ? 1'b1: 1'b0;
    
    
    always_ff @(posedge bus_clk or negedge rstn) begin: X_TAG_GEN
        if(~rstn) begin
            X_TAG <= 0;
        end else if(flush_tag && X_TAG < kernel_size) begin
            X_TAG <= X_TAG + 1;
        end else begin
            X_TAG <= 0;
        end       
    end    
    
    always_ff @(posedge bus_clk or negedge rstn) begin: READ_ADDR_GEN
        if(~rstn) begin
            read_addr <= 0;
        end else begin
            if(start) begin
                read_addr <= read_addr + 1;
            end else begin
                read_addr <= read_addr;
            end
        end  
    end 
    
    always_ff @(posedge bus_clk or negedge rstn) begin: FLTR_ADDR_GEN
        if(~rstn) begin
            fltr_addr <= 0;
        end else begin
            if(flush_kernel) begin
                fltr_addr <= fltr_addr + 1;
            end else begin
                fltr_addr <= fltr_addr;
            end    
        end        
    end 
    
    
    always_ff@(posedge bus_clk or negedge rstn) begin: get_data_count
        if(~rstn) begin
            data_counter <= 16'b0;
            ram_load_busy <= 0;
        end else begin
            if(load_ifmap) begin
                ram_load_busy <= 1;
                data_counter <= data_counter + 1;
            end else begin
                data_counter <= data_counter;
                ram_load_busy <= 0;
            end
        end 
    end 

    //instantiate global buffer (true dual port RAM)
        buffer_glb Glb_Buffer_ifmap(
            .addra(addr_in),
            .clka(bus_clk),
            .dina(data_in),
            .wea(load_ifmap),
            .douta(),
            .ena(1),
            .rsta(~rstn),
            .rsta_busy(rsta_busy_ifmap),
        

            .addrb(read_addr),
            .clkb(bus_clk),
            .dinb(0),
            .web(0),
            .doutb(data_out),
            .enb(start),
            .rstb_busy(rstb_busy_ifmap)
        );   
        
        buffer_glb_fltr Glb_Buffer_fltr(
            .addra(fltr_addr_in),
            .clka(bus_clk),
            .dina(fltr_data_in),
            .wea(load_fltr),
            .douta(),
            .ena(1),
            .rsta(~rstn),
            .rsta_busy(rsta_busy_fltr),
            
            .addrb(fltr_addr),
            .clkb(bus_clk),
            .dinb(0),
            .web(0),
            .doutb(fltr_out),
            .enb(flush_kernel),
            .rstb_busy(rstb_busy_fltr)
        );
endmodule