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


module csr #(
    parameter WIDTH
)(
    input wire clk,
    input wire rstn,
    input wire set,
    input wire [WIDTH-1:0] csr_in,
    output wire [WIDTH-1:0] csr_out 
);

    always(posedge clk or negedge rstn) begin
        if(~rstn) begin
            csr_out <= 0;
        end else if(set) begin
            csr_out <= csr_in;
        end else begin
            csr_out <= csr_out;
        end
    end 


endmodule