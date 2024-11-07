`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: 
// Module Name: blk_mem_rd
// Project Name: 
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

module DummyPEArray_CONFIG #(
    parameter DELAY_CYCLES = 10,
    parameter PE_WIDTH = 4,
    parameter NUM_ROWS = 3, // N
    parameter NUM_COLS = 3  // M
) (
    input wire clk,
    input wire rst,

    // Separate packed and unpacked arrays
    input wire [PE_WIDTH-1:0] ifmap_COL_IN [NUM_ROWS],  // Column-wise input
    input wire [PE_WIDTH-1:0] ifmap_ROW_IN [NUM_COLS-1], // Row-wise input

    output wire [PE_WIDTH-1:0] ifmap_COL_OUT [NUM_ROWS],
    output wire [PE_WIDTH-1:0] ifmap_ROW_OUT [NUM_COLS-1],

    output wire [PE_WIDTH-1:0] psum_OUT [NUM_COLS]  // OUTPUT number: N
);

//intermediate wires definition
wire [PE_WIDTH-1:0] ifmap_conn_in [0:NUM_ROWS-1][0:NUM_COLS-1];
wire [PE_WIDTH-1:0] ifmap_conn_out [0:NUM_ROWS-1][0:NUM_COLS-1];
wire [PE_WIDTH-1:0] psum_conn [0:NUM_ROWS-1][0:NUM_COLS-1];


genvar k;
generate
    //MAPPING INPUT AND OUTPUT TO INTERCONNECTION
    for(k=0; k < NUM_ROWS; k=k+1) begin
        assign ifmap_conn_in[k][0] = ifmap_COL_IN[k];
        assign ifmap_conn_out[k][NUM_COLS-1] = ifmap_COL_OUT[k];
    end
    for(k=0;k < NUM_COLS-1; k=k+1) begin
        assign ifmap_conn_in[0][k+1] = ifmap_ROW_IN[k];
        assign ifmap_conn_out[NUM_ROWS-1][k] = ifmap_ROW_OUT[k];
    end
    for(k=0;k < NUM_COLS;k=k+1) begin
        assign psum_OUT[k] = psum_conn[NUM_ROWS-1][k];
    end
endgenerate

genvar p, q;
generate
    //INTERCONNECT conn_in and conn_out
    for(p=0;p<NUM_ROWS-1;p=p+1) begin
        for(q=0;q<NUM_COLS-1;q=q+1) begin
            assign ifmap_conn_in[p+1][q+1] = ifmap_conn_out[p][q];
        end
    end

endgenerate

genvar ROW, COL;
generate
    //generate SV_DummyPE
    for(ROW=0;ROW<NUM_ROWS;ROW=ROW+1) begin

        for(COL=0;COL<NUM_COLS;COL=COL+1) begin
            SV_DummyPE #(
        .DELAY_CYCLES(DELAY_CYCLES),
        .PE_WIDTH(PE_WIDTH)
    ) SV_DummyPE_inst (
        .clk(clk),
        .rst(rst), 
        .in_signals(
            {
                ifmap_conn_in [ROW][COL],
                (ROW==0) ? {PE_WIDTH{1'b0}} : psum_conn [ROW-1][COL]
            }
        ),
        .out_signals(
            {
                ifmap_conn_out [ROW][COL],
                psum_conn [ROW][COL]
            }
        )

    );
        end
    end 
endgenerate

endmodule