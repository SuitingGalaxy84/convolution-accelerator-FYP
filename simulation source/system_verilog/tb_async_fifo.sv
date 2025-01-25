`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: async_fifo_test
// Module Name: ccd_pe_driver
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


module tb_async_fifo();
    
    localparam NUM_FIFO = 16;
    localparam DATA_WIDTH = 16;
    localparam CLK_PERIOD = 10;
    

    reg rd_en [NUM_FIFO-1:0];
    wire empty [NUM_FIFO-1:0];
    wire full [NUM_FIFO-1:0];
    wire [DATA_WIDTH-1:0] rd_data [NUM_FIFO-1:0];
    wire [DATA_WIDTH-1:0] wr_data [NUM_FIFO-1:0];

    //instantiate fifo reader
    genvar i;
    generate 
        for(i=0; i<NUM_FIFO; i=i+1) begin : async_fifo_reader_gen
            async_fifo_reader #(
                .DATA_WIDTH(DATA_WIDTH),
                .FIFO_DEPTH(NUM_FIFO)
            )(
                .rd_clk(rd_clk),
                .rd_rstn(rd_rstn),
                .rd_en(rd_en[i]),
                .empty(empty[i]),
                .rd_data(rd_data[])
            );
        end
    endgenerate

    //instantiate fifo
    genvar j;
    generate 
        for(j=0; j<NUM_FIFO; j=j+1) begin : async_fifo_gen
            async_fifo #(
                .DATA_WIDTH(DATA_WIDTH),
                .FIFO_DEPTH(NUM_FIFO)
            )(
                .wr_clk(wr_clk),
                .wr_rstn(wr_rstn),
                .wr_en(wr_en[j]),
                .full(full[j]),
                .wr_data(wr_data[j])

                .rd_clk(rd_clk),
                .rd_rstn(rd_rstn),
                .rd_en(rd_en[j]),
                .empty(empty[j]),
                .rd_data(rd_data[j])

            );
        end
    endgenerate


    //instantiate fifo writer
    async_fifo_writer #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(NUM_FIFO)
    )(
        .wr_clk(wr_clk),
        .wr_rstn(wr_rstn),
        .wr_en(wr_en), 
        .full(full),
        .wr_data(wr_data)
    );
    
    // Clock Generation

    reg wr_clk;
    reg rd_clk;
    
    initial begin
        wr_clk = 0;
        rd_clk = 0;
        forever #(CLK_PERIOD/2) wr_clk = ~wr_clk;
        forever #(CLK_PERIOD*NUM_FIFO/2) rd_clk = ~rd_clk;
    end 

    //start behavioural simulation
    initial begin
        wr_rstn = 1; rd_rstn = 1; wr_en = 0; rd_en = 0;
        #50 wr_rstn = 0; rd_rstn = 0;
        #50 wr_rstn = 1; rd_rstn = 1;
        #50 wr_en = 1; rd_en = 1;
        #300 $stop;
    end 


endmodule 