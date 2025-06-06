
// file: AXI_interface_clk_wiz_0_0.v
// 
// (c) Copyright 2008 - 2013 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// _____clk__140.00000______0.000______50.0_______96.640_____79.592
// __pe_clk__20.00000______0.000______50.0______138.478_____79.592
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________100.000____________0.010

`timescale 1ps/1ps

module AXI_interface_clk_wiz_0_0_clk_wiz 

 (// Clock in ports
  // Clock out ports
  output        clk,
  output        pe_clk,
  // Status and control signals
  input         reset,
  output        locked,
  input         clk_in1
 );
  // Input buffering
  //------------------------------------
wire clk_in1_AXI_interface_clk_wiz_0_0;
wire clk_in2_AXI_interface_clk_wiz_0_0;
  IBUF clkin1_ibuf
   (.O (clk_in1_AXI_interface_clk_wiz_0_0),
    .I (clk_in1));




  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        clk_AXI_interface_clk_wiz_0_0;
  wire        pe_clk_AXI_interface_clk_wiz_0_0;
  wire        clk_out3_AXI_interface_clk_wiz_0_0;
  wire        clk_out4_AXI_interface_clk_wiz_0_0;
  wire        clk_out5_AXI_interface_clk_wiz_0_0;
  wire        clk_out6_AXI_interface_clk_wiz_0_0;
  wire        clk_out7_AXI_interface_clk_wiz_0_0;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_AXI_interface_clk_wiz_0_0;
  wire        clkfboutb_unused;
    wire clkout0b_unused;
   wire clkout1b_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;
  wire        reset_high;

  
    PLLE4_ADV
  #(
    .COMPENSATION         ("AUTO"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT        (14),
    .CLKFBOUT_PHASE       (0.000),
    .CLKOUT0_DIVIDE       (10),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT1_DIVIDE       (70),
    .CLKOUT1_PHASE        (0.000),
    .CLKOUT1_DUTY_CYCLE   (0.500),
    .CLKIN_PERIOD         (10.000))
  
  plle4_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_AXI_interface_clk_wiz_0_0),
    .CLKOUT0             (clk_AXI_interface_clk_wiz_0_0),
    .CLKOUT0B            (clkout0b_unused),
    .CLKOUT1             (pe_clk_AXI_interface_clk_wiz_0_0),
    .CLKOUT1B            (clkout1b_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_AXI_interface_clk_wiz_0_0),
    .CLKIN               (clk_in1_AXI_interface_clk_wiz_0_0),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    .CLKOUTPHYEN         (1'b0),
    .CLKOUTPHY           (),
    // Other control and status signals
    .LOCKED              (locked_int),
    .PWRDWN              (1'b0),
    .RST                 (reset_high));
  assign reset_high = reset; 

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------






  BUFG clkout1_buf
   (.O   (clk),
    .I   (clk_AXI_interface_clk_wiz_0_0));


  BUFG clkout2_buf
   (.O   (pe_clk),
    .I   (pe_clk_AXI_interface_clk_wiz_0_0));



endmodule
