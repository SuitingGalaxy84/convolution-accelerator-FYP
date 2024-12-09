`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Global Bbuffer
// Module Name: glb_Buffer
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: PYNQ Z1
// Tool Versions: Vivado 20XX.XX
// Description: Processing Element for Convolution Accelerator
/*
    
*/
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "interface.sv"

module glb_Buffer #(
    parameter DATA_WIDTH=16,
    parameter GLB_DEPTH = 1024
)(
    input clk,
    input kernel_size,
    input 
);
    GLB_IF.GLB_port #(DATA_WIDTH, GLB_DEPTH) GLB_IFA(); //ifmap interface
    GLB_IF.GLB_port #(DATA_WIDTH, GLB_DEPTH) GLB_IFB(); // opsum interface

    global_buffer global_buffer_inst(
        .clka(clk),
        .addra(GLB_IFA.ADDR),
        .dina(GLB_IFA.DIN),
        .wea(GLB_IFA.WEN),
        .douta(GLB_IFA.DOUT),
        .rsta(GLB_IFA.RST),
        .ena(GLB_IFA.EN),

        .clkb(clk),
        .addrb(GLB_IFB.ADDR),
        .dinb(GLB_IFB.DIN),
        .web(GLB_IFB.WEN),
        .doutb(GLB_IFB.DOUT),
        .rstb(GLB_IFB.RST),
        .enb(GLB_IFB.EN)
    );
    
    


endmodule