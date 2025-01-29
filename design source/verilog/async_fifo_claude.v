module async_fifo_v2 #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH),
    parameter PRE_FILL_LEVEL = FIFO_DEPTH/2
) (
    // Write domain
    input  wire                  wr_clk,
    input  wire                  wr_rstn,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,
    output reg                   pre_fill_done,
    
    // Read domain
    input  wire                  rd_clk,
    input  wire                  rd_rstn,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty,
    output wire                  pre_fill_done_sync
);

    // Internal signals for pointers
    reg [ADDR_WIDTH:0]   wr_ptr_bin;
    reg [ADDR_WIDTH:0]   rd_ptr_bin;
    wire [ADDR_WIDTH:0]  wr_ptr_gray;
    wire [ADDR_WIDTH:0]  rd_ptr_gray;
    reg [ADDR_WIDTH:0]   wr_ptr_gray_sync [1:0];
    reg [ADDR_WIDTH:0]   rd_ptr_gray_sync [1:0];

    // Counters for FIFO usage tracking
    reg [ADDR_WIDTH:0]   write_count;
    reg [ADDR_WIDTH:0]   read_count;
    reg [ADDR_WIDTH:0]   read_count_gray;
    reg [ADDR_WIDTH:0]   read_count_sync [1:0];
    reg [ADDR_WIDTH:0]   fifo_used;
    reg [1:0]           pre_fill_done_sync_reg;

    // Dual-port RAM
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Binary to Gray conversion for pointers
    assign wr_ptr_gray = wr_ptr_bin ^ (wr_ptr_bin >> 1);
    assign rd_ptr_gray = rd_ptr_bin ^ (rd_ptr_bin >> 1);

    // Write counter and pointer logic
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wr_ptr_bin <= 0;
            write_count <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_bin <= wr_ptr_bin + 1'b1;
            write_count <= write_count + 1'b1;
        end
    end

    // Read counter and pointer logic
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rd_ptr_bin <= 0;
            read_count <= 0;
            read_count_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin <= rd_ptr_bin + 1'b1;
            read_count <= read_count + 1'b1;
            read_count_gray <= (read_count + 1'b1) ^ ((read_count + 1'b1) >> 1);
        end
    end

    // Synchronize read count to write domain
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            read_count_sync[0] <= 0;
            read_count_sync[1] <= 0;
        end else begin
            read_count_sync[0] <= read_count_gray;
            read_count_sync[1] <= read_count_sync[0];
        end
    end

    // Gray code to binary conversion function
    function [ADDR_WIDTH:0] gray2bin;
        input [ADDR_WIDTH:0] gray;
        reg [ADDR_WIDTH:0] bin;
        integer i;
        begin
            bin = gray;
            for (i = 1; i <= ADDR_WIDTH; i = i + 1)
                bin = bin ^ (bin >> i);
            gray2bin = bin;
        end
    endfunction

    // FIFO usage tracking and pre-fill detection
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            fifo_used <= 0;
            pre_fill_done <= 0;
        end else begin
            // Calculate usage based on write count and synchronized read count
            fifo_used <= write_count - gray2bin(read_count_sync[1]);

            // Update pre-fill status
            if (fifo_used >= PRE_FILL_LEVEL)
                pre_fill_done <= 1;
            else if (fifo_used < PRE_FILL_LEVEL)
                pre_fill_done <= 0;
        end
    end

    // Synchronize pre_fill_done to read clock domain
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            pre_fill_done_sync_reg <= 2'b00;
        end else begin
            pre_fill_done_sync_reg <= {pre_fill_done_sync_reg[0], pre_fill_done};
        end
    end
    assign pre_fill_done_sync = pre_fill_done_sync_reg[1];

    // Pointer synchronization
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

    // Memory write operation
    always @(posedge wr_clk) begin
        if (wr_en && !full)
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
    end

    // Memory read operation
    assign rd_data = mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    // Flag generation
    wire [ADDR_WIDTH:0] wr_ptr_gray_sync_rd;
    wire [ADDR_WIDTH:0] rd_ptr_gray_sync_wr;
    
    assign rd_ptr_gray_sync_wr = rd_ptr_gray_sync[1];
    assign wr_ptr_gray_sync_rd = wr_ptr_gray_sync[1];

    assign full = (wr_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1] != 
                  rd_ptr_gray_sync_wr[ADDR_WIDTH:ADDR_WIDTH-1]) &&
                 (wr_ptr_gray[ADDR_WIDTH-2:0] == 
                  rd_ptr_gray_sync_wr[ADDR_WIDTH-2:0]);

    assign empty = (wr_ptr_gray_sync_rd == rd_ptr_gray);

endmodule
