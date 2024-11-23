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


module DummyPEConfig #(
    parameters BUS_WIDTH
) (
    input wire clk,
    input wire rst,
    input wire set,
    logic struct packed{
        input logic kl_type; // 0: lock, 1: key
        input logic [BUS_WIDTH-1:0] kl_data;
        output logic match;
    } KL;
);

    

    wire [BUS_WIDTH-1:0] PE_LOCK;
    reg [BUS_WIDTH-1:0] PE_KEY;


    always_ff @(posedge clk or negedge rst) begin
        if(~rst) begin
            PE_KEY <= 0;
        end else begin
            PE_KEY <= KL.kl_data
        end
    end


    csr #(
        .WIDTH(BUS_WIDTH)
    ) csr_col_lock (
        .clk(clk),
        .rstn(~rst),
        .set(set),
        .csr_in(KL.kl_type ? 0 : KL.kl_data),
        .csr_out(PE_LOCK)
    );
    
    match #(
        .WIDTH(ROW_BUS_WIDTH+COL_BUS_WIDTH)
    ) KL_match (
        .lock(PE_LOCK),
        .key(KL.kl_type ? PE_KEY : PE_KEY ^ PE_LOCK),
        .match_out(KL.match) // FIXME: Create a calculation-control interface, question: what should be the purpose of this signal?
    );


endmodule