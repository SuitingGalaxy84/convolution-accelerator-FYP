`timescale 1ns / 1ps

module tb_SV_PE;

    // Parameters
    localparam DATA_WIDTH = 16;
    localparam CLK_PERIOD = 10;
    localparam KERNEL_SIZE = 9;
    

    // Inputs
    reg rstn;
    wire clk;
    reg en;


    // Interface instance
    PE_IF #(DATA_WIDTH) PE_IF_inst();

    // Instantiate the Unit Under Test (UUT)
    SV_PE #(
        .DATA_WIDTH(DATA_WIDTH)
    ) uut (
        .rstn(rstn),
        .clk(clk),
        .PE_IF(PE_IF_inst)
    );

    SV_PE_driver #(
        .DATA_WIDTH(DATA_WIDTH),
        .CLK_PERIOD(CLK_PERIOD),
        .KERNEL_SIZE(KERNEL_SIZE)
    ) driver (
        .rstn(rstn),
        .clk(clk),
        .PE_IF(PE_IF_inst),
        .PE_EN(en)
    );
    // Initial reset and stimulus
    initial begin
        // Initialize Inputs
        /*
            测试用例 - 测试控制信号和时�?? - 获得时序特征
            输入数据：PE_IF.ifmap_data_M2P = 1, PE_IF.fltr_data_M2P = 2, PE_IF.psum_data_M2P = 3
        clk      <rclk>      <rclk>      <rclk>   
        input1   <DATA#1>    <DATA#2>    <...>
        input2   <DATA#1>    <DATA#2>    <...>
        mult     <xxx>       <xxx>       <DATA#1>
        mult_slen
        output   <xxx>       <xxx>
        */
        rstn = 1; en = 0;
        #50 rstn = 0;
        #50 rstn = 1;
        #50 en = 1;
        #300 rstn = 0;
        $stop; // Stop the simulation
    end

    // Monitor outputs
//    initial begin
//        $monitor("Time=%0t, rstn=%b, mult_seln=%b, acc_seln=%b, ifmap_data_M2P=%h, fltr_data_M2P=%h, psum_data_M2P=%h, psum_data_P2M=%h, PE_EN=%b, PE_READY=%b, PE_VALID=%b",
//                 $time, rstn, mult_seln, acc_seln, PE_IF_inst.ifmap_data_M2P, PE_IF_inst.fltr_data_M2P, PE_IF_inst.psum_data_M2P, PE_IF_inst.psum_data_P2M, PE_IF_inst.PE_EN, PE_IF_inst.PE_READY, PE_IF_inst.PE_VALID);
//    end

endmodule
