`timescale 1ns / 1ps

module tb_SV_PE;

    // Parameters
    localparam DATA_WIDTH = 16;

    // Inputs
    logic rstn;
    logic clk;
    logic mult_seln;
    logic acc_seln;

    // Interface instance
    PE_IF #(DATA_WIDTH) PE_IF_inst();

    // Instantiate the Unit Under Test (UUT)
    SV_PE #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .rstn(rstn),
        .clk(clk),
        .PE_IF(PE_IF_inst),
        .mult_seln(mult_seln),
        .acc_seln(acc_seln)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Initial reset and stimulus
    initial begin
        // Initialize Inputs
        rstn = 0;
        mult_seln = 0;
        acc_seln = 0;
        PE_IF_inst.ifmap_data_M2P = 0;
        PE_IF_inst.fltr_data_M2P = 0;
        PE_IF_inst.psum_data_M2P = 0;
        PE_IF_inst.PE_EN = 0;

        // Apply Reset
        #20;
        rstn = 1;

        // Apply stimulus
        #10;
        PE_IF_inst.ifmap_data_M2P = 16'h0003;
        PE_IF_inst.fltr_data_M2P = 16'h0002;
        PE_IF_inst.psum_data_M2P = 32'h0000_0001;
        PE_IF_inst.PE_EN = 1;
        mult_seln = 1;
        acc_seln = 0;

        #10;
        mult_seln = 0;
        acc_seln = 1;

        #10;
        PE_IF_inst.ifmap_data_M2P = 16'h0004;
        PE_IF_inst.fltr_data_M2P = 16'h0003;
        PE_IF_inst.psum_data_M2P = 32'h0000_0002;
        mult_seln = 1;
        acc_seln = 0;

        #10;
        acc_seln = 1;

        #50;
        $stop; // Stop the simulation
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t, rstn=%b, mult_seln=%b, acc_seln=%b, ifmap_data_M2P=%h, fltr_data_M2P=%h, psum_data_M2P=%h, psum_data_P2M=%h, PE_EN=%b, PE_READY=%b, PE_VALID=%b",
                 $time, rstn, mult_seln, acc_seln, PE_IF_inst.ifmap_data_M2P, PE_IF_inst.fltr_data_M2P, PE_IF_inst.psum_data_M2P, PE_IF_inst.psum_data_P2M, PE_IF_inst.PE_EN, PE_IF_inst.PE_READY, PE_IF_inst.PE_VALID);
    end

endmodule
