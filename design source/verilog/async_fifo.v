module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
) (
    // Write domain
    input  wire                  wr_clk,
    input  wire                  wr_rstn,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,
    
    // Read domain
    input  wire                  rd_clk,
    input  wire                  rd_rstn,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty
);

    // Internal signals
    reg [$clog2(FIFO_DEPTH):0]   wr_ptr_bin;
    reg [$clog2(FIFO_DEPTH):0]   rd_ptr_bin;
    wire [$clog2(FIFO_DEPTH):0]  wr_ptr_gray;
    wire [$clog2(FIFO_DEPTH):0]  rd_ptr_gray;
    reg [$clog2(FIFO_DEPTH):0]   wr_ptr_gray_sync [1:0];
    reg [$clog2(FIFO_DEPTH):0]   rd_ptr_gray_sync [1:0];

    // Dual-port RAM instantiation
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Binary to Gray code conversion
    assign wr_ptr_gray = wr_ptr_bin ^ (wr_ptr_bin >> 1);
    assign rd_ptr_gray = rd_ptr_bin ^ (rd_ptr_bin >> 1);

    // Synchronization of pointers
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            rd_ptr_gray_sync[0] <= 0;
            rd_ptr_gray_sync[1] <= 0;
        end else begin
            rd_ptr_gray_sync[0] <= rd_ptr_gray;
            rd_ptr_gray_sync[1] <= rd_ptr_gray_sync[0];
        end
    end

    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            wr_ptr_gray_sync[0] <= 0;
            wr_ptr_gray_sync[1] <= 0;
        end else begin
            wr_ptr_gray_sync[0] <= wr_ptr_gray;
            wr_ptr_gray_sync[1] <= wr_ptr_gray_sync[0];
        end
    end

    // Write pointer logic
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wr_ptr_bin <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_bin <= wr_ptr_bin + 1;
        end
    end

    // Read pointer logic
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rd_ptr_bin <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin <= rd_ptr_bin + 1;
        end
    end

    // Memory write operation
    always @(posedge wr_clk) begin
        if (wr_en && !full) begin
            mem[wr_ptr_bin[$clog2(FIFO_DEPTH)-1:0]] <= wr_data;
        end
    end

    // Memory read operation
    assign rd_data = mem[rd_ptr_bin[$clog2(FIFO_DEPTH)-1:0]];

    // Full and Empty flag generation
    wire [$clog2(FIFO_DEPTH):0] wr_ptr_gray_sync_rd;
    wire [$clog2(FIFO_DEPTH):0] rd_ptr_gray_sync_wr;
    
    assign rd_ptr_gray_sync_wr = rd_ptr_gray_sync[1];
    assign wr_ptr_gray_sync_rd = wr_ptr_gray_sync[1];

    assign full = (wr_ptr_gray[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1] != rd_ptr_gray_sync_wr[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1]) &&
                 (wr_ptr_gray[$clog2(FIFO_DEPTH)-2:0] == rd_ptr_gray_sync_wr[$clog2(FIFO_DEPTH)-2:0]);

    assign empty = (wr_ptr_gray_sync_rd == rd_ptr_gray);

endmodule
