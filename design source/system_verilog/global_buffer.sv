`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2024 05:47:50 PM
// Design Name: GLB_BUF
// Module Name: Global Buffer
// Project Name: COnvolution Accelerator for PyTorch Deep Learning Framework
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
`include "interface.sv"

module Global_BUF#(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 8,
    parameter NUM_ROW = 8,
    parameter BUFFER_SIZE = 512, 
    parameter DATA_TYPES = 3
)(
    input bus_clk,
    input rstn,
    
    
    input load_ifmap, 
    input load_fltr,
    input load_psum,
    
    
    input flush_tag,
    input flush_kernel,
    input start,
    
    input [$clog2(BUFFER_SIZE)-1:0] addr_in,
    input [2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2:0] data_in, // <data, X_ID, Y_ID, DATA_TYPES>
                                                                      
    input [7:0] kernel_size,

    BUS_CTRL.Test_XBUS_CTRL UniV_BUS_CTRL_IF,
    output ram_rst_busy,
    output reg ram_load_busy,
    output full
);
/*
    defualt data types definition
*/
    parameter IDLE = 3'b000;
    parameter IFMAP_DATA = 3'b001;// DATA_WIDTH
    parameter FLTR_DATA = 3'b010; // DATA_WIDTH
    parameter PSUM_DATA = 3'b011; // 2*DATA_WIDTH

/*
    defualt data types definition
*/
  

/*
    instantiate state signals 
*/
    wire rstb_busy_ifmap, rsta_busy_ifmap;
    wire rsta_busy_fltr, rstb_busy_fltr;
    assign ram_rst_busy = rstb_busy_ifmap | rsta_busy_ifmap | rsta_busy_fltr | rstb_busy_fltr;

/*
    instantiate state signals 
*/

/*
    instantiate ram reading address
*/
    reg [$clog2(BUFFER_SIZE)-1:0] read_addr;
    reg [$clog2(BUFFER_SIZE)-1:0] fltr_addr;
    reg [$clog2(BUFFER_SIZE)-1:0] psum_addr;
/*
    instantiate ram reading address
*/

/*
    decode input data
*/
    wire [$clog2(DATA_TYPES):0] data_type_in;
    //wire [$clog2(NUM_ROW):0] y_id;
    //wire [$clog2(NUM_COL):0] x_id;
    //wire [2*DATA_WIDTH-1:0] data;
    //assign data_type = data_in[$clog2(DATA_TYPES):0]; // extended by 1 bit
    //assign y_id = data_in[$clog2(NUM_ROW)+$clog2(DATA_TYPES)+1:$clog2(DATA_TYPES)+1]; // extended by one bit
    //assign x_id = data_in[$clog2(NUM_COL)+$clog2(NUM_ROW)+$clog(DATA_TYPES)+2:$clog2(NUM_ROW)+$clog2(DATA_TYPES)+2]; //extended by one bit
    //assign data = data_in[2*DATA_WIDTH+$clog2(NUM_COL)+$clog2(NUM_ROW)+$clog(DATA_TYPES)+2:$clog2(NUM_COL)+$clog2(NUM_ROW)+$clog(DATA_TYPES)+3]
/*
    decode input data
*/

/*
    control and status signals for the global buffer 
*/
    reg [$clog2(BUFFER_SIZE)-1:0] fmap_area; // area of ifmap
    reg [$clog2(BUFFER_SIZE)-1:0] fltr_area; // area of filter
/*
    control and status signals for the global buffer 
*/



/*
    ram writing state machine
*/
    reg [2:0] buffer_write_state;
    reg [2:0] buffer_wirte_next_state;

    always_comb@(*) begin
        case(data_type_in)
            IDLE: buffer_write_next_state = 3'b000;
            IFMAP_DATA: buffer_write_next_state = 3'b100;
            FLTR_DATA: buffer_write_next_state = 3'b010;
            PSUM_DATA: buffer_write_next_state = 3'b001;
            defualt: buffer_write_next_state = 3'b000;
        endcase
    end 
    always_ff@() begin
        if(~rstn) begin
            buffer_write_state <= 0;
        end else begin
            buffer_write_state <= buffer_write_next_state;
        end 
    end 
/*
    ram_writing state machine
*/

/*
    configurate the circuit: X_TAG
*/
    reg [15:0] data_counter;
    reg [$clog2(NUM_COL):0] X_TAG; //extended by 1 bit

    always_ff @(posedge bus_clk or negedge rstn) begin: X_TAG_GEN
        if(~rstn) begin
            X_TAG <= 0;
        end else if(flush_tag && X_TAG < kernel_size) begin
            X_TAG <= X_TAG + 1;
        end else begin
            X_TAG <= 0;
        end       
    end 
    assign UniV_BUS_CTRL_IF.X_TAG = X_TAG;

/*
    configurate the circuit: X_TAG
*/
    
/*
    decode the output data
*/
    wire [$clog2(DATA_TYPES):0] data_type_out;
    wire [2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2:0] ifmap_out;
    wire [2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2:0] fltr_out;
    wire [2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2:0] psum_out;
    assign y_id = ifmap_out[$clog2(NUM_ROW)+$clog2(DATA_TYPES)+1:$clog2(DATA_TYPES)+1]; // extended by one bit
    assign x_id = ifmap_out[$clog2(NUM_COL)+$clog2(NUM_ROW)+$clog(DATA_TYPES)+2:$clog2(NUM_ROW)+$clog2(DATA_TYPES)+2]; //extended by one bit
    assign UniV_BUS_CTRL_IF.X_ID = x_id;
    assign UniV_BUS_CTRL_IF.X_ID = x_id;
    assign UniV_BUS_CTRL_IF.ifmap_data_G2B = ifmap_out[2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2: DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 3]
    assign UniV_BUS_CTRL_IF.fltr_data_G2B = fltr_out[2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2: DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 3]
    assign UniV_BUS_CTRL_IF.fltr_data_G2B = psum_out[[2*DATA_WIDTH + $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 2: $clog2(NUM_COL) + $clog2(NUM_ROW)+ $clog2(DATA_TYPES) + 3]]
/*
    decode the output data
*/

/*
    state_definition
*/
    assign full = (data_counter == BUFFER_SIZE) ? 1'b1: 1'b0;
    
    
       
    
    always_ff @(posedge bus_clk or negedge rstn) begin: READ_ADDR_GEN
        if(~rstn) begin
            read_addr <= 0;
        end else begin
            if(start) begin
                read_addr <= read_addr + 1;
            end else begin
                read_addr <= read_addr;
            end
        end  
    end 
    
    always_ff @(posedge bus_clk or negedge rstn) begin: FLTR_ADDR_GEN
        if(~rstn) begin
            fltr_addr <= 0;
        end else begin
            if(flush_kernel) begin
                fltr_addr <= fltr_addr + 1;
            end else begin
                fltr_addr <= fltr_addr;
            end    
        end        
    end 
    
    always_ff@(posedge bus_clk or negedge rstn) begin: PSUM_ADDR_GEN
        if(~rstn) begin
            psum_addr <= 0;
        end else begin
            if(start) begin
                psum_addr <= psum_addr + 1;
            end else begin
                psum_addr <= psum_addr;
            end 
        end
    end 
    
    always_ff@(posedge bus_clk or negedge rstn) begin: get_data_count
        if(~rstn) begin
            data_counter <= 16'b0;
            ram_load_busy <= 0;
        end else begin
            if(load_ifmap) begin
                ram_load_busy <= 1;
                data_counter <= data_counter + 1;
            end else begin
                data_counter <= data_counter;
                ram_load_busy <= 0;
            end
        end 
    end 

    //instantiate global buffer (true dual port RAM)
        buffer_glb Glb_Buffer_ifmap(
            .addra(addr_in),
            .clka(bus_clk),
            .dina(data_in),
            .wea(load_ifmap),
            .douta(),
            .ena(1'b1),
            .rsta(~rstn),
            .rsta_busy(rsta_busy_ifmap),
        

            .addrb(read_addr),
            .clkb(bus_clk),
            .dinb(1'b0),
            .web(1'b0),
            .doutb(data_out),
            .enb(start),
            .rstb_busy(rstb_busy_ifmap)
        );   
        
        buffer_glb_fltr Glb_Buffer_fltr(
            .addra(fltr_addr_in),
            .clka(bus_clk),
            .dina(fltr_data_in),
            .wea(load_fltr),
            .douta(),
            .ena(1'b1),
            .rsta(~rstn),
            .rsta_busy(rsta_busy_fltr),
            
            .addrb(fltr_addr),
            .clkb(bus_clk),
            .dinb(1'b0),
            .web(1'b0),
            .doutb(fltr_out),
            .enb(flush_kernel),
            .rstb_busy(rstb_busy_fltr)
        );
        
        buffer_glb_psum Glb_Buffer_psum(
            .addra(psum_addr_in),
            .clka(bus_clk),
            .dina(psum_data_in),
            .wea(load_psum),
            .douta(),
            .ena(1'b1),
            .rsta(~rstn),
            .rsta_busy(rsta_busy_psum),
            
            .addrb(psum_addr),
            .clkb(bus_clk),
            .dinb(1'b0),
            .web(1'b0),
            .doutb(psum_out),
            .enb(start),
            .rstb_busy(rstb_busy_psum)
        );
        
endmodule