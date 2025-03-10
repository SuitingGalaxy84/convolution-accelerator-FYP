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
    parameter NUM_COL = 8
)(
    input bus_clk,
    input rstn,
    input flush, 
    input start,
    input [DATA_WIDTH-1:0] addr_in,
    input [DATA_WIDTH-1:0] data_in,
    input [7:0] kernel_size,
    input [DATA_WIDTH-1:0] addr_out,    
    BUS_CTRL.Test_XBUS_CTRL UniV_BUS_CTRL_IF,
    output rstn_busy

);
    wire rstb_busy, rsta_busy;
    assign rstn_busy = rstb_busy | rsta_busy;

    reg [$clog2(NUM_COL):0] pe_x_id; //extended by 1 bit 
    // tag generator for data
    always_ff @(posedge bus_clk or negedge rstn) begin: tag_gen
        if(~rstn) begin
            pe_x_id <= 0;
        end else if (start) begin
            if(pe_x_id <= kernel_size) begin
                pe_x_id <= pe_x_id + 1;
            end else begin
                pe_x_id <= 1;
            end
        end else begin
            pe_x_id <= 0;
        end 
    end 
    assign UniV_BUS_CTRL_IF.X_ID = pe_x_id;

    //instantiate global buffer (true dual port RAM)
        buffer_glb Glb_Buffer_ifmap(
            .addra(addr_in),
            .clka(clka),
            .dina(data_in),
            .wea(flush),
            .douta(),
            .ena(1'b1),
            .rsta(!rstn),
            .rsta_busy(rsta_busy),
        

            .addrb(addrb),
            .clkb(clkb),
            .dinb(16'b0),
            .web(1'b0),
            .doutb(UniV_BUS_CTRL_IF.ifmap_data_G2B),
            .enb(start),
            .rstb_busy(rstb_busy)
        );   
endmodule