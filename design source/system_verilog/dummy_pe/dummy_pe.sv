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

module SV_DummyPE #(
    parameter DELAY_CYCLES = 10, // Default delay in clock cycles
    parameter PE_WIDTH = 16
    parameter ROW_BUS_WIDTH = 2,
    parameter COL_BUS_WIDTH = 2
) (
    input wire clk,               // Clock signal
    input wire rst,               // Reset signal (active high), reset the calculation block 
    input wire flush,             // Flush signal (active high), reset the configuration block

    input wire struct packed {         // Input signal structure
        logic [PE_WIDTH-1:0] in_signal_1;
        logic [PE_WIDTH-1:0] in_signal_2;
    } in_signals,

    output struct packed {        // Output signal structure
        logic [PE_WIDTH-1:0] out_signal_1;
        logic [PE_WIDTH-1:0] out_signal_2;
    } out_signals,



    /*
    a LOCK-KEY scheme is created. Every PE is assgined with a unique ROW-COL tag at the initialization. The PE
    can be activated only when the corresponding ROW-COL tag is provided. This facilitates an efficient control
    of the PE array.
    */
    
    input wire struct packed {   // Control signal structure
        logic [ROW_BUS_WIDTH-1:0] row_value;
        logic [COL_BUS_WIDTH-1:0] col_value;
        logic kl_type; // 0: lock, 1: key
    } PE_KEY_LOCK


);

/* PE Configuration block begin */

    wire match; //
    DummyPEConfig #(
        .BUS_WIDTH(ROW_BUS_WIDTH+COL_BUS_WIDTH)
    ) PE_config (
        .clk(clk),
        .rst(rst),
        .set(flush),

        .KL{
            .kl_type(PE_KEY_LOCK.kl_type),
            .kl_data({PE_KEY_LOCK.row_value, PE_KEY_LOCK.col_value}),
            .match(match)
        }
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