module async_fifo_reader #(
    parameter DATA_WIDTH = 16,
    parameter FIFO_DEPTH = 16,
)(
    input rd_clk,
    input rd_rstn,
    input rd_en,
    input empty,
    input [DATA_WIDTH-1:0] rd_data
);
    localparam MAX_NUM = 2^(DATA_WIDTH) - 1;
    localparam MIN_NUM = 1;
    reg [DATA_WIDTH-1:0] data;
    always_ff@(posedge rd_clk or negedge rd_rstn) begin : read_data_from_fifo
        if(~rstn) begin
            data <= 0;
        end else if(~empty&&rd_en) begin
            data <= rd_data; 
        end else begin
            data <= {(DATA_WIDTH-1){1'b0}};
        end
    end 

endmodule
