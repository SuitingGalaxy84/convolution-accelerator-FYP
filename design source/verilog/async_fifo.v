module AsyncFIFO #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input wire wr_clk,  // Write clock
    input wire rd_clk,  // Read clock
    input wire rst_n,   // Active-low reset
    input wire wr_en,   // Write enable
    input wire rd_en,   // Read enable
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

    // Internal memory
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

    // Write and read pointers
    reg [$clog2(FIFO_DEPTH):0] wr_ptr = 0;
    reg [$clog2(FIFO_DEPTH):0] rd_ptr = 0;

    // Gray code pointers for synchronization
    reg [$clog2(FIFO_DEPTH):0] wr_ptr_gray = 0;
    reg [$clog2(FIFO_DEPTH):0] rd_ptr_gray = 0;
    reg [$clog2(FIFO_DEPTH):0] wr_ptr_gray_sync1 = 0;
    reg [$clog2(FIFO_DEPTH):0] wr_ptr_gray_sync2 = 0;
    reg [$clog2(FIFO_DEPTH):0] rd_ptr_gray_sync1 = 0;
    reg [$clog2(FIFO_DEPTH):0] rd_ptr_gray_sync2 = 0;

    // Write logic
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr[$clog2(FIFO_DEPTH)-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
            wr_ptr_gray <= (wr_ptr + 1) ^ ((wr_ptr + 1) >> 1);
        end else if (wr_en && full) begin
            $display("FIFO full");
        end else begin
            wr_ptr <= wr_ptr;
            wr_ptr_gray <= wr_ptr_gray;
        end
    end

    // Read logic
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            rd_ptr_gray <= 0;
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr[$clog2(FIFO_DEPTH)-1:0]];
            rd_ptr <= rd_ptr + 1;
            rd_ptr_gray <= (rd_ptr + 1) ^ ((rd_ptr + 1) >> 1);
        end
    end

    // Synchronize write pointer to read clock domain
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // Synchronize read pointer to write clock domain
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // Full and empty flag logic
    wire [$clog2(FIFO_DEPTH):0] wr_ptr_bin = wr_ptr_gray_sync2 ^ (wr_ptr_gray_sync2 >> 1);
    wire [$clog2(FIFO_DEPTH):0] rd_ptr_bin = rd_ptr_gray_sync2 ^ (rd_ptr_gray_sync2 >> 1);

    assign full = (wr_ptr[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1] == ~rd_ptr_bin[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1]) &&
                  (wr_ptr[$clog2(FIFO_DEPTH)-2:0] == rd_ptr_bin[$clog2(FIFO_DEPTH)-2:0]);

    assign empty = (wr_ptr_gray_sync2 == rd_ptr_gray);

endmodule
