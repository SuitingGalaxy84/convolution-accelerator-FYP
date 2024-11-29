// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Nov 29 16:35:14 2024
// Host        : ThisIsALaptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               h:/Desktop/FYP/vivado_sim/convolution-accelerator-FYP/convolution-accelerator-FYP.gen/sources_1/ip/global_buffer/global_buffer_stub.v
// Design      : global_buffer
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sbva484-1-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *)
module global_buffer(clka, rsta, wea, addra, dina, douta, clkb, rstb, web, 
  addrb, dinb, doutb, rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,wea[0:0],addra[9:0],dina[15:0],douta[15:0],clkb,rstb,web[0:0],addrb[9:0],dinb[15:0],doutb[15:0],rsta_busy,rstb_busy" */;
  input clka;
  input rsta;
  input [0:0]wea;
  input [9:0]addra;
  input [15:0]dina;
  output [15:0]douta;
  input clkb;
  input rstb;
  input [0:0]web;
  input [9:0]addrb;
  input [15:0]dinb;
  output [15:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule
