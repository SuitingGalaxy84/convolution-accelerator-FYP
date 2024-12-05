// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Thu Dec  5 03:33:26 2024
// Host        : ThisIsALaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               h:/Desktop/FYP/vivado_sim/convolution-accelerator-FYP/convolution-accelerator-FYP.gen/sources_1/ip/mult_gen_0/mult_gen_0_stub.v
// Design      : mult_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_17,Vivado 2021.1" *)
module mult_gen_0(CLK, A, B, SCLR, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[15:0],B[15:0],SCLR,P[31:0]" */;
  input CLK;
  input [15:0]A;
  input [15:0]B;
  input SCLR;
  output [31:0]P;
endmodule
