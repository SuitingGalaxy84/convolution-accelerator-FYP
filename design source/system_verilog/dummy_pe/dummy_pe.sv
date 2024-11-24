`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Dummy PE
// Module Name: SV_DummyPE
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: 
/*
    This is a dummy PE whose output is the input signal delayed by a fixed number of clock cycles. Not a functional
    PE due to the lack of computation block. This is used to demonstrate the PE array configuration and control.
*/
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SV_DummyPE #(
    parameter DELAY_CYCLES = 10, // Default delay in clock cycles
    parameter PE_WIDTH = 16
    parameter ROW_BUS_WIDTH = 2,
    parameter COL_BUS_WIDTH = 2
) (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal (active high), reset the calculation block 
    input wire flush,             // Flush signal (active high), reset the configuration block

    input struct packed {         // Input signal structure
        logic [PE_WIDTH-1:0] in_signal_1;
        logic [PE_WIDTH-1:0] in_signal_2;
    } in_signals,

    output struct packed {        // Output signal structure
        logic [PE_WIDTH-1:0] out_signal_1;
        logic [PE_WIDTH-1:0] out_signal_2;
    } out_signals,


    
    input wire struct packed {   // Control signal structure
        logic [ROW_BUS_WIDTH-1:0] row_value;
        logic [COL_BUS_WIDTH-1:0] col_value;
        logic kl_type; // 0: lock, 1: key
    } PE_KEY_LOCK


);

/* PE Configuration block begin */

    wire KL_VALID; // FIXME: KL_VALID should be used to enable the PE calculation block
    SV_DummyPE_KL #(
        .BUS_WIDTH(ROW_BUS_WIDTH+COL_BUS_WIDTH)
    ) SV_DummyPE_KL (
        .clk(clk),
        .rst(rst),
        .set(flush),
        .KL_DATA{
            .kl_type(PE_KEY_LOCK.kl_type),
            .kl_data({PE_KEY_LOCK.row_value, PE_KEY_LOCK.col_value}),
        },
        .KL_VALID(KL_VALID)
    );


/* PE Configuration block end */
    


/* PE Calculation block begin */

    reg [PE_WIDTH-1:0] shift_reg_1 [DELAY_CYCLES-1:0];
    reg [PE_WIDTH-1:0] shift_reg_2 [DELAY_CYCLES-1:0];

    // Shift register logic
    always_ff @(posedge clk or posedge rst) begin
	integer i, j;
        if (rst) begin
            for (i = 0; i < DELAY_CYCLES; i = i + 1) begin
                shift_reg_1[i] <= 4'b0;
                shift_reg_2[i] <= 4'b0;
            end
            out_signals.out_signal_1 <= 4'b0;
            out_signals.out_signal_2 <= 4'b0;
        end else begin
            // Shift left by 1, input at LSB
            shift_reg_1[0] <= in_signals.in_signal_1;
            shift_reg_2[0] <= in_signals.in_signal_2;
            

            // Propagate the shift register values
            for (j = 1; j < DELAY_CYCLES; j = j + 1) begin
                shift_reg_1[j] <= shift_reg_1[j-1];
                shift_reg_2[j] <= shift_reg_2[j-1];
            end

            // Output the delayed signal with +1 adjustment
            out_signals.out_signal_1 <= shift_reg_1[DELAY_CYCLES-1]; //+ 1;
            out_signals.out_signal_2 <= shift_reg_2[DELAY_CYCLES-1]; //+ 1;
        end
    end
/* PE Calculation block end */

endmodule