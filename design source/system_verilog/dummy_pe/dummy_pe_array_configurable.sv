`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Electronic Science and Technology of China
// Engineer: Sun Yucheng
// 
// Create Date: XX
// Design Name: Configurable Dummy PE Array
// Module Name: SV_DummyPEArray_CONFIG
// Project Name: A Convolution Accelerator for PyTorch Deep Learning Framework
// Target Devices: 
// Tool Versions: 
// Description: 
/*
    This is a configurable Dummy PE Array module. You can genrate a Dummy PE array of any size by changing the parameters.
    PE_WIDTH: Data width of the PE  
    NUM_ROWS: Number of rows in the array
    NUM_COLS: Number of columns in the array
    DELAY_CYCLES: Number of cycles the PE takes to compute the output
*/
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SV_DummyPEArray_CONFIG #(
    parameter DELAY_CYCLES = 10,
    parameter PE_WIDTH = 16,
    parameter NUM_ROWS = 3, // N
    parameter NUM_COLS = 3  // M
    ) (
    input wire clk,
    input wire rst,

    /* Data Path IO definition begin */
        // Separate packed and unpacked arrays
        input wire [PE_WIDTH-1:0] ifmap_COL_IN [NUM_ROWS],  // Column-wise input
        input wire [PE_WIDTH-1:0] ifmap_ROW_IN [NUM_COLS-1], // Row-wise input
        input wire [NUM_ROWS-2:0] ifmap_SEL, //select ifmap: From either GLOBAL BUFFER or PE output


        output wire [PE_WIDTH-1:0] ifmap_COL_OUT [NUM_ROWS],
        output wire [PE_WIDTH-1:0] ifmap_ROW_OUT [NUM_COLS-1],

        output wire [PE_WIDTH-1:0] psum_OUT [NUM_COLS]  // OUTPUT number: N
        
    /* Data Path IO definition end */
    
);





/* Control Bus Definition Begin */

    //PE control tag definition
    parameter ROW_BUS_WIDTH = $clog2(NUM_ROWS);
    parameter COL_BUS_WIDTH = $clog2(NUM_COLS);

    wire [ROW_BUS_WIDTH-1:0] row_bus;
    wire [COL_BUS_WIDTH-1:0] col_bus;
    wire [ROW_BUS_WIDTH+COL_BUS_WIDTH-2:0] control_bus = {row_bus, col_bus};

/* Control Bus Definition End */



/* Data Path Definition Begin */

    //intermediate wires definition
    wire [PE_WIDTH-1:0] ifmap_conn_in [0:NUM_ROWS-1][0:NUM_COLS-1];
    wire [PE_WIDTH-1:0] ifmap_conn_out [0:NUM_ROWS-1][0:NUM_COLS-1];
    wire [PE_WIDTH-1:0] psum_conn [0:NUM_ROWS-1][0:NUM_COLS-1];

/* Data Path Definition End */


/* Data Path Interconnect Begin */
    genvar k;
    generate
        //MAPPING INPUT AND OUTPUT TO INTERCONNECTION
        for(k=0; k < NUM_ROWS; k=k+1) begin
            //assign ifmap_conn_in[k][0] = ifmap_COL_IN[k];     //FIX this line of code is merged to the if-else block below
            assign ifmap_conn_out[k][NUM_COLS-1] = ifmap_COL_OUT[k];

            //MAPPING OUTPUT TO INPUT TERMINAL: if ifmap_SEL is 1, then output ifmap is redirected to input
            if(k < NUM_ROWS-1) begin
                assign ifmap_conn_in[k+1][0] =  ifmap_SEL[k] ? ifmap_conn_out[k][NUM_COLS-1] : ifmap_COL_IN[k+1];
            end
            else begin
                assign ifmap_conn_in[k][0] = ifmap_COL_IN[k];  //TODO: PACKAGE this IF-ELSE BLOCK
            end

        end
        for(k=0;k < NUM_COLS-1; k=k+1) begin
            assign ifmap_conn_in[0][k+1] = ifmap_ROW_IN[k];
            assign ifmap_conn_out[NUM_ROWS-1][k] = ifmap_ROW_OUT[k];
        end
        for(k=0;k < NUM_COLS;k=k+1) begin
            assign psum_OUT[k] = psum_conn[NUM_ROWS-1][k];
        end

        for(k=0; k < NUM_ROWS-1; k=k+1) begin
            assign ifmap_conn_in[k+1][0] =  ifmap_SEL[k] ? ifmap_conn_out[k][NUM_COLS-1] : ifmap_COL_IN[k+1];
        end
    endgenerate

    genvar p, q;
    generate
        //INTERCONNECT conn_in and conn_out
        for(p=0;p<NUM_ROWS-1;p=p+1) begin
            for(q=0;q<NUM_COLS-1;q=q+1) begin
                assign ifmap_conn_in[p+1][q+1] = ifmap_conn_out[p][q];
            end
        end

    endgenerate


/* Data Path Interconnect End */
    
/* PE Instantiation Begin */

    genvar ROW, COL;
    generate
        //generate SV_DummyPE
        for(ROW=0;ROW<NUM_ROWS;ROW=ROW+1) begin

            for(COL=0;COL<NUM_COLS;COL=COL+1) begin
                
                SV_DummyPE #(
            .DELAY_CYCLES(DELAY_CYCLES),
            .PE_WIDTH(PE_WIDTH),   
            .ROW_BUS_WIDTH(ROW_BUS_WIDTH),
            .COL_BUS_WIDTH(COL_BUS_WIDTH)
        ) SV_DummyPE_inst (
            .clk(clk),
            .rst(rst), 
            .in_signals(
                {
                    ifmap_conn_in [ROW][COL],
                    (ROW==0) ? {PE_WIDTH{1'b0}} : psum_conn [ROW-1][COL]
                }
            ),
            .out_signals(
                {
                    ifmap_conn_out [ROW][COL],
                    psum_conn [ROW][COL]
                }
            ),
            
            .PE_KEY_LOCK(
                {
                    row_bus,
                    col_bus,
                    kl_type // FIXME: facilitate kl_type
                }
            )


        );
            end
        end 
    endgenerate

/* PE Instantiation End */

endmodule

