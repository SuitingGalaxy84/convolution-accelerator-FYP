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


module tb_async_fifo_prefill();
    
    parameter NUM_FIFO = 4;
    parameter DATA_WIDTH = 16;
    parameter WR_CLK_PERIOD = 10;
    parameter RD_CLK_PERIOD = WR_CLK_PERIOD * NUM_FIFO;
    parameter FIFO_DEPTH = 32;

    wire rd_en [NUM_FIFO-1:0];
    wire empty [NUM_FIFO-1:0];
    wire full [NUM_FIFO-1:0];
    wire [DATA_WIDTH-1:0] rd_data [NUM_FIFO-1:0];
    wire [DATA_WIDTH-1:0] wr_data [NUM_FIFO-1:0];
    reg writer_en;
    reg reader_en;
    reg wr_clk;
    reg rd_clk;
    reg wr_rstn;
    reg rd_rstn;
    wire wr_en [NUM_FIFO-1:0];
    
    initial begin
        wr_clk = 0;
        
        forever #(CLK_PERIOD/2) wr_clk = ~wr_clk;
        
    end 
    initial begin
        rd_clk = 0;
        forever #(CLK_PERIOD) rd_clk = ~rd_clk;
    end 

    //start behavioural simulation
    initial begin
        wr_rstn = 1; rd_rstn = 1; writer_en = 0; reader_en = 0;
        #50 wr_rstn = 0; rd_rstn = 0;
        #50 wr_rstn = 1; rd_rstn = 1; 
        #50 writer_en = 1;
        #50 reader_en = 1;
        #300 $stop;
    end 


    //instantiate fifo reader
    async_fifo_reader #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_FIFO(NUM_FIFO)
    )async_fifo_reader(
        .rd_clk(rd_clk),
        .rd_rstn(rd_rstn),
        .reader_en(reader_en),
        .empty(empty),
        .rd_data(rd_data),
        .rd_en(rd_en)
    );



    //instantiate fifo
    genvar j;
    generate 
        for(j=0; j<NUM_FIFO; j=j+1) begin : async_fifo_gen
            async_fifo #(
                .DATA_WIDTH(DATA_WIDTH),
                .FIFO_DEPTH(FIFO_DEPTH)
            )aync_fifo_inst(
                .wr_clk(wr_clk),
                .wr_rstn(wr_rstn),
                .wr_en(wr_en[j]),
                .full(full[j]),
                .wr_data(wr_data[j]),

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
        .NUM_FIFO(NUM_FIFO)
    )aync_fifo_writer(
        .wr_clk(wr_clk),
        .wr_rstn(wr_rstn),
        .writer_en(writer_en),
        .wr_en(wr_en), 
        .full(full),
        .wr_data(wr_data)
    );
    
    // Clock Generation



endmodule 