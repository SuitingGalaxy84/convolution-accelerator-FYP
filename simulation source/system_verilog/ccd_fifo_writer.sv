module async_fifo_writer #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 16,
    parameter NUM_FIFO = 16
)(
    input wire                                   wr_clk,
    input wire                                   wr_rstn,
    input wire                                   wr_en,
    input wire [NUM_FIFO-1:0]                   full,
    output reg [NUM_FIFO-1:0][DATA_WIDTH-1:0]   wr_data
);
    localparam MAX_NUM = 2^(DATA_WIDTH) - 1;
    localparam MIN_NUM = 1;
    reg [$clog2(NUM_FIFO):0] fifo_ptr;
    
    // Counter for generating incremental data
    reg [DATA_WIDTH-1:0] data_counter;

    // FIFO pointer generation
    always @(posedge wr_clk or negedge wr_rstn) begin : fifo_ptr_auto_gen
        if(~wr_rstn) begin
            fifo_ptr <= 0;
        end else if(~full[fifo_ptr] && wr_en) begin
            fifo_ptr <= (fifo_ptr == NUM_FIFO-1) ? 0 : fifo_ptr + 1;
        end
    end

    // Data counter generation
    always @(posedge wr_clk or negedge wr_rstn) begin : data_counter_gen
        if(~wr_rstn) begin
            data_counter <= MIN_NUM;
        end else if(wr_en && ~full[fifo_ptr]) begin
            if(data_counter == MAX_NUM)
                data_counter <= MIN_NUM;
            else
                data_counter <= data_counter + 1;
        end
    end

    // Write data generation for all FIFOs
    always @(posedge wr_clk or negedge wr_rstn) begin : write_data_gen
        integer i;
        if(~wr_rstn) begin
            for(i = 0; i < NUM_FIFO; i++) begin
                wr_data[i] <= 0;
            end
        end else if(wr_en && ~full[fifo_ptr]) begin
            wr_data[fifo_ptr] <= data_counter;
        end
    end


endmodule
