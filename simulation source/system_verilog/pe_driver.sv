`include "interface.sv"

module SV_PE_driver#(
    parameter DATA_WIDTH = 16,
    parameter CLK_PERIOD = 10,
    parameter KERNEL_SIZE = 9
    )(
        input rstn,
        output reg clk,
        PE_IF.MC_port PE_IF,
        input PE_EN
    );

    parameter MAX_NUM = 2^(DATA_WIDTH) - 1;
    parameter MIN_NUM = 0;
    reg [DATA_WIDTH-1:0] ifmap_data_M2P;
    reg [DATA_WIDTH-1:0] fltr_data_M2P;
    reg [2*DATA_WIDTH-1:0] psum_data_M2P;

    assign PE_IF.ifmap_data_M2P = ifmap_data_M2P;
    assign PE_IF.fltr_data_M2P = fltr_data_M2P;
    assign PE_IF.psum_data_M2P = psum_data_M2P;
    assign PE_IF.PE_EN = PE_EN;
    assign PE_IF.kernel_size = KERNEL_SIZE;
    /*
        MC_port:
            output ifmap_data_M2P,
            output fltr_data_M2P,
            output psum_data_M2P,

            input ifmap_data_P2M,
            input fltr_data_P2M,
            input psum_data_P2M,

            output PE_EN,
            input PE_READY,
            input PE_VALID,
            output kernel_size
    */
    // Clock signal generation
    initial begin
        clk = 1;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end 
    always_ff @(posedge clk or negedge rstn) begin : Random_data_gen
        if (~rstn) begin
            ifmap_data_M2P <= 0;
            fltr_data_M2P <= 0;
            psum_data_M2P <= 0;
        end else begin
            ifmap_data_M2P <= $urandom_range(MIN_NUM, MAX_NUM);
            fltr_data_M2P <= $urandom_range(MIN_NUM, MAX_NUM);
            psum_data_M2P <= $urandom_range(MIN_NUM, MAX_NUM);
        end
    end 


endmodule