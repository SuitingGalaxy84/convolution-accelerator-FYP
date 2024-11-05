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

module DummyPE #(
    parameter DELAY_CYCLES = 10 // Default delay in clock cycles
) (
    input wire clk,               // Clock signal
    input wire rstn,               // Reset signal (active high)
    input wire [3:0] in_signal_1, // 4-bit Input signal to be delayed
    input wire [3:0] in_signal_2,
   //input wire [3:0] in_signal_3,
    output reg [3:0] out_signal_1, // 4-bit Delayed output signal
    output reg [3:0] out_signal_2,
    //output reg [3:0] out_signal_3
);

    // Internal shift registers for 4-bit delay
    reg [3:0] shift_reg_1 [DELAY_CYCLES-1:0];
    reg [3:0] shift_reg_2 [DELAY_CYCLES-1:0];
    //reg [3:0] shift_reg_3 [DELAY_CYCLES-1:0];

    // Shift register logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            integer i;
            for (i = 0; i < DELAY_CYCLES; i = i + 1) begin
                shift_reg_1[i] <= 4'b0;
                shift_reg_2[i] <= 4'b0;
                //shift_reg_3[i] <= 4'b0;
            end
            out_signal_1 <= 4'b0;
            out_signal_2 <= 4'b0;
            //out_signal_3 <= 4'b0;
        end else begin
            // Shift left by 1, input at LSB
            shift_reg_1[0] <= in_signal_1;
            shift_reg_2[0] <= in_signal_2;
            //shift_reg_3[0] <= in_signal_3;

            // Propagate the shift register values
            integer j;
            for (j = 1; j < DELAY_CYCLES; j = j + 1) begin
                shift_reg_1[j] <= shift_reg_1[j-1];
                shift_reg_2[j] <= shift_reg_2[j-1];
                //shift_reg_3[j] <= shift_reg_3[j-1];
            end

            // Output the delayed signal
            out_signal_1 <= shift_reg_1[DELAY_CYCLES-1];
            out_signal_2 <= shift_reg_2[DELAY_CYCLES-1];
            //out_signal_3 <= shift_reg_3[DELAY_CYCLES-1];
        end
    end

endmodule