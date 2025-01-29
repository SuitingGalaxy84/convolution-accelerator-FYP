module async_fifo_reader #(
    parameter DATA_WIDTH = 16,
    parameter NUM_FIFO = 4
)(
    input rd_clk,
    input rd_rstn,
    input reader_en,
    input empty [NUM_FIFO-1:0],
    input [DATA_WIDTH-1:0] rd_data [NUM_FIFO-1:0],
    output reg rd_en [NUM_FIFO-1:0]
);
    localparam MAX_NUM = 2^(DATA_WIDTH) - 1;
    localparam MIN_NUM = 1;
    reg [DATA_WIDTH-1:0] data [NUM_FIFO-1:0];
    
    
    reg [$clog2(NUM_FIFO)-1:0] fifo_ptr;
    // FIFO pointer generation
    always_ff @(posedge rd_clk or negedge rd_rstn) begin : fifo_ptr_auto_gen
        if(~rd_rstn) begin
            fifo_ptr <= 0;
        end else if(~empty[fifo_ptr] && reader_en) begin
            fifo_ptr <= (fifo_ptr == NUM_FIFO-1) ? 0 : fifo_ptr + 1;
        end
    end
    
    integer i;
    always_ff@(posedge rd_clk or negedge rd_rstn) begin
        if(~rd_rstn) begin
            for(i=0;i<NUM_FIFO;i=i+1) begin
                rd_en[i] <= 0;
            end 
        end else if (reader_en) begin
            for(i=0;i<NUM_FIFO;i=i+1) begin
                rd_en[i] = 1;
//                if(i!=fifo_ptr) begin
//                    rd_en[i] <= 0;
//                end else begin
//                    rd_en[i] <= 1;
//                end
            end 
        end 
    end 
    integer j;
    always_ff@(posedge rd_clk or negedge rd_rstn) begin : read_data_from_fifo
        if(~rd_rstn) begin
            for(j=0;j<NUM_FIFO;j=j+1) begin
                data[j] <= 0;
            end 
        end else if(~empty[fifo_ptr]&&rd_en[fifo_ptr]) begin
            data[fifo_ptr] <= rd_data[fifo_ptr]; 
        end
    end 

endmodule
