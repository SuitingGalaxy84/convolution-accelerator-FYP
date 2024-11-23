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


module match #(
    parameter WIDTH
)(
    input wire [WIDTH-1:0] lock,
    input wire [WIDTH-1:0] key,
    output wire match
)

assign match = (xor(lock, key) == 0) ? 1'b1 : 1'b0;

endmodule
