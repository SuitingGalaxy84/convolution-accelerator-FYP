`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: weight buffer
// Module Name: WeightBuff
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

module WeightBuff #(
        parameter DATA_WIDTH = 16,
        parameter BUFFER_DEPTH = 16
)(
    input clk,
    input rstn,
    input flush_kernel, //write enable 
    input [7:0] kernel_size,
    input [DATA_WIDTH-1:0] data_in,
    output [DATA_WIDTH-1:0] data_out,
    output [DATA_WIDTH-1:0] pseudo_out,
    output kernel_busy,
    output reg un_configed,
    output read_VALID,
    input en   
);

    reg [DATA_WIDTH-1:0] weight_buff [BUFFER_DEPTH-1:0];

    reg [7:0] wr_ptr;
    reg [7:0] rd_ptr;

    reg [7:0] next_wr_ptr;
    reg [7:0] next_rd_ptr;

    


    localparam FLUSH_IDLE = 1'b0;
    localparam FLUSH_OP = 1'b1;

    localparam READ_IDEL = 1'b0;
    localparam READ_OP = 1'b1;
    
    reg read_current_state;
    reg read_next_state;
    
    reg write_current_state;
    reg write_next_state;
    
    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            un_configed <= 1;
        end else begin
            if(flush_kernel) begin
                un_configed <= 0;
            end else begin
                un_configed <= un_configed;
            end 
        end 
    end 

    assign kernel_busy = write_current_state;
    assign read_VALID = read_current_state;

    assign pseudo_out = weight_buff[BUFFER_DEPTH-1];
    

    assign data_out = read_VALID ? weight_buff[rd_ptr] : 0;
    
    always @(*) begin //write_state_transition
        case(write_current_state)
            FLUSH_IDLE: begin
                write_next_state = flush_kernel&&un_configed ? FLUSH_OP : FLUSH_IDLE;
                next_wr_ptr = 0;
            end 
            FLUSH_OP: begin
                next_wr_ptr = wr_ptr+1;
                write_next_state = (wr_ptr==kernel_size) ? FLUSH_IDLE : FLUSH_OP;
            end
        endcase
    end 

    always @(*) begin // read_state_transition
        case(read_current_state)
            READ_IDEL: begin
                read_next_state = en ? READ_OP : 0;
                next_rd_ptr = 0;
            end 
            READ_OP: begin
                next_rd_ptr = rd_ptr+1;
                read_next_state = (rd_ptr==kernel_size) ? READ_IDEL : READ_OP;
            end
        endcase
    end  



    always @(posedge clk or negedge rstn) begin // read
        if(~rstn) begin
            rd_ptr <= 0;
            read_current_state <= 0;
        end else begin
            rd_ptr <= next_rd_ptr;
            read_current_state <= read_next_state;
        end 
    end

    integer i;
    always @(posedge clk or negedge rstn) begin // write
        if(~rstn) begin
            wr_ptr <= 0;
            write_current_state <= 0;
            for (i = 0; i < BUFFER_DEPTH; i = i + 1) begin
                weight_buff[i] <= 0;
            end
        end else begin
            wr_ptr <= next_wr_ptr;
            write_current_state <= write_next_state;
            if(write_current_state == FLUSH_OP) begin
                weight_buff[wr_ptr-1] <= data_in;
            end
        end 
    end 

endmodule 

