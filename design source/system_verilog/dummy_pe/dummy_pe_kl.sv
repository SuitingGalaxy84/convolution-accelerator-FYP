`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: PE Key-Lock Checker 
// Module Name: SV_DummyPE_KL
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
/*
    a LOCK-KEY scheme is created. Every PE is assgined with a unique ROW-COL tag at the initialization. The PE
    can be activated only when the corresponding ROW-COL tag is provided. This facilitates an efficient control
    of the PE array.
 */
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SV_DummyPE_KL #(
    parameter BUS_WIDTH
) (
    input wire clk,
    input wire rst,
    input wire set,
    input logic struct packed{
        logic kl_type; // 0: lock, 1: key
        logic [BUS_WIDTH-1:0] kl_data;
    } KL_DATA,
    output wire KL_VALID
);

    

    wire [BUS_WIDTH-1:0] PE_LOCK;
    reg [BUS_WIDTH-1:0] PE_KEY;


    always_ff @(posedge clk or negedge rst) begin
        if(~rst) begin
            PE_KEY <= 0;
        end else begin
            PE_KEY <= KL_DATA.kl_data
        end
    end


    csr #(
        .WIDTH(BUS_WIDTH)
    ) csr_col_lock (
        .clk(clk),
        .rstn(~rst),
        .set(set),
        .csr_in(KL_DATA.kl_type ? 0 : KL_DATA.kl_data),
        .csr_out(PE_LOCK)
    );
    
    match #(
        .WIDTH(ROW_BUS_WIDTH+COL_BUS_WIDTH)
    ) KL_match (
        .lock(PE_LOCK),
        .key(KL_DATA.kl_type ? PE_KEY : PE_KEY ^ PE_LOCK),
        .match_out(KL_VALID) // FIXME: Create a calculation-control interface, question: what should be the purpose of this signal?
    );


endmodule