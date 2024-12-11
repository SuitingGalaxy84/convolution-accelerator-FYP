`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Configurable PE Array
// Module Name: pe_array_CONFIG
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

module pe_array_CONFIG #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 3,
    parameter NUM_ROW = 3
    )(
        input wire clk,
        input wire rstn
    );

    BUS_IF #(DATA_WIDTH) UniV_XBUS_IF [NUM_ROW-1:0] ();
    BUS_CTRL #(DATA_WIDTH, NUM_ROW, NUM_COL) UniV_BUS_CTRL ();
    PE_ITR #(DATA_WIDTH) PE_IITR [NUM_ROW-1:0][NUM_COL-1:0] ();
    PE_ITR #(DATA_WIDTH) PE_OITR [NUM_ROW-1:0][NUM_COL-1:0] ();

    

  
    
    genvar m;
    generate // instantiating row bus control and interfaces
        for(m=0; m<NUM_ROW; m=m+1) begin : row_interface
              X_BusCtrl #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_COL(NUM_COL),
            .NUM_ROW(NUM_ROW)
            ) X_BusCtrl(
                .clk(clk),
                .rstn(rstn),
                .flush(flush),
                .rst_busy(rst_busy),
                .UniV_XBUS_IF(UniV_XBUS_IF[m]),
                .UniV_BUS_CTRL(UniV_BUS_CTRL)
            );
        end 

    endgenerate
    
    genvar i, j;
    generate // instantiate Global PE Array
        for(i=0; i<NUM_ROW; i=i+1) begin : row_gen
            for(j=0; j<NUM_COL; j=j+1) begin : col_gen
                glb_PE #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .NUM_COL(NUM_COL)
                ) glb_PE_inst(
                    .clk(clk),
                    .rstn(rstn),
                    .external(external),
                    .BUS_IF(UniV_XBUS_IF[i]),
                    .PE_IITR(PE_IITR[i][j]),
                    .PE_OITR(PE_OITR[i][j])
                );

            end 
        end 

    endgenerate

    genvar k, l;
    generate 
        for(k=0; k<NUM_ROW-1; k=k+1) begin : data_conn
            for(l=0; l<NUM_COL-1; l=l+1) begin
                assign PE_IITR[k+1][l+1].ifmap_data_P2P = PE_OITR[k][l].ifmap_data_P2P;
                assign PE_IITR[k][l+1].fltr_data_P2P = PE_OITR[k][l].fltr_data_P2P;
                assign PE_IITR[k+1][l].psum_data_P2P = PE_OITR[k][l].psum_data_P2P; 
            end 
        end
         
    endgenerate
    
    genvar s, t;
    generate
        for(s=0; s<NUM_ROW-1; s=s+1) begin : handshake
            for(t=0; t<NUM_COL-1; t=t+1) begin
                assign PE_IITR[s+1][t+1].READY = PE_OITR[s][t].VALID;
                assign PE_IITR[s][t+1].READY = PE_OITR[s][t].VALID;
                assign PE_IITR[s+1][t].READY = PE_OITR[s][t].VALID;
            end    
        end 
   
   
    endgenerate













endmodule