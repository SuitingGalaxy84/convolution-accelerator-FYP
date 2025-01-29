module async_fifo_writer #(
    parameter DATA_WIDTH = 16,
    parameter NUM_FIFO = 16
)(
    input wire                                   wr_clk,
    input wire                                   wr_rstn,
    input wire                                   writer_en,
    output reg                                   wr_en [NUM_FIFO-1:0],
    input wire                     full [NUM_FIFO-1:0],
    output reg [DATA_WIDTH-1:0]    wr_data [NUM_FIFO-1:0]
);
    localparam MAX_NUM = 2^(DATA_WIDTH) - 1;
    localparam MIN_NUM = 1;
    reg [$clog2(NUM_FIFO):0] fifo_ptr;
    
    // Counter for generating incremental data
    //reg [$clog2(NUM_FIFO)-1:0] data_counter;


    
    // FIFO pointer generation
    always_ff @(posedge wr_clk or negedge wr_rstn) begin : fifo_ptr_auto_gen
        if(~wr_rstn) begin
            fifo_ptr <= 0;
        end else if(~full[fifo_ptr] && writer_en) begin
            fifo_ptr <= (fifo_ptr == NUM_FIFO-1) ? 0 : fifo_ptr + 1;
 
        end
    end

    // Data counter generation

    
    // enabler
    integer j;
    always_ff @(posedge wr_clk or negedge wr_rstn) begin: wr_en_gen
        if(~wr_rstn) begin
            for(j=0;j<NUM_FIFO;j=j+1) begin
                wr_en[j] <= 0;
            end 
        end else if (writer_en) begin 
            for(j=0;j<NUM_FIFO;j=j+1) begin
                if(j!=fifo_ptr) begin
                    wr_en[j] <= 0;
                end else begin
                    wr_en[j] <= 1;
                end 
            end 
        end 
    end 
    
    // Write data generation for all FIFOs
    always @(posedge wr_clk or negedge wr_rstn) begin : write_data_gen
        integer i;
        if(~wr_rstn) begin
            for(i = 0; i < NUM_FIFO; i++) begin
                wr_data[i] <= 0;
            end
        end else if(writer_en && ~full[fifo_ptr]) begin
            wr_data[fifo_ptr] <= $urandom_range(MIN_NUM, MAX_NUM); 
            end
    end


endmodule
