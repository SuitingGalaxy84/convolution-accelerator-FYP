module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter PRE_FILL_LEVEL = FIFO_DEPTH/2
) (
    // Write domain
    input  wire                  wr_clk,
    input  wire                  wr_rstn,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,
    output reg                   pre_fill_done,    // Status only
    
    // Read domain
    input  wire                  rd_clk,
    input  wire                  rd_rstn,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty,
    output wire                  pre_fill_done_sync // Status only
);

    // Internal signals
    reg [$clog2(FIFO_DEPTH):0]   wr_ptr_bin;
    reg [$clog2(FIFO_DEPTH):0]   rd_ptr_bin;
    wire [$clog2(FIFO_DEPTH):0]  wr_ptr_gray;
    wire [$clog2(FIFO_DEPTH):0]  rd_ptr_gray;
    reg [$clog2(FIFO_DEPTH):0]   wr_ptr_gray_sync [1:0];
    reg [$clog2(FIFO_DEPTH):0]   rd_ptr_gray_sync [1:0];

    // FIFO usage counter for pre-fill detection
    reg [$clog2(FIFO_DEPTH):0]   fifo_used;
    reg [1:0]                    pre_fill_done_sync_reg;

    // Dual-port RAM
    reg [DATA_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

    // Binary to Gray conversion
    assign wr_ptr_gray = wr_ptr_bin ^ (wr_ptr_bin >> 1);
    assign rd_ptr_gray = rd_ptr_bin ^ (rd_ptr_bin >> 1);

    // FIFO usage tracking and pre-fill detection
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            fifo_used <= 0;
            pre_fill_done <= 0;
        end else begin
            // Update FIFO usage
            case ({wr_en & ~full, rd_en & ~empty})
                2'b10: fifo_used <= fifo_used + 1;
                2'b01: fifo_used <= fifo_used - 1;
                default: fifo_used <= fifo_used;
            endcase

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

    // Original pointer synchronization
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

    // Write pointer logic - unchanged
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wr_ptr_bin <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_bin <= wr_ptr_bin + 1;
        end
    end

    // Read pointer logic - no pre-fill dependency
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rd_ptr_bin <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin <= rd_ptr_bin + 1;
        end
    end

    // Memory write operation
    integer j;
    always @(posedge wr_clk or negedge wr_rstn) begin
        if(~wr_rstn) begin
            for(j=0;j<FIFO_DEPTH;j=j+1) begin
                mem[j] <= 0;
            end
        end else if (wr_en && !full) begin
            mem[wr_ptr_bin[$clog2(FIFO_DEPTH)-1:0]] <= wr_data;
        end
    end

    // Memory read operation
    assign rd_data = mem[rd_ptr_bin[$clog2(FIFO_DEPTH)-1:0]];

    // Flag generation
    wire [$clog2(FIFO_DEPTH):0] wr_ptr_gray_sync_rd;
    wire [$clog2(FIFO_DEPTH):0] rd_ptr_gray_sync_wr;
    
    assign rd_ptr_gray_sync_wr = rd_ptr_gray_sync[1];
    assign wr_ptr_gray_sync_rd = wr_ptr_gray_sync[1];

    assign full = (wr_ptr_gray[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1] != 
                  rd_ptr_gray_sync_wr[$clog2(FIFO_DEPTH):$clog2(FIFO_DEPTH)-1]) &&
                 (wr_ptr_gray[$clog2(FIFO_DEPTH)-2:0] == 
                  rd_ptr_gray_sync_wr[$clog2(FIFO_DEPTH)-2:0]);

    assign empty = (wr_ptr_gray_sync_rd == rd_ptr_gray);

    // Assertions for verification
    // synthesis translate_off
    // property valid_pre_fill_level;
    //     @(posedge wr_clk) disable iff(!wr_rstn)
    //     PRE_FILL_LEVEL > 0 && PRE_FILL_LEVEL <= FIFO_DEPTH;
    // endproperty
    
    // assert property(valid_pre_fill_level)
    // else $error("Pre-fill level must be between 1 and FIFO_DEPTH");

    // property valid_fifo_usage;
    //     @(posedge wr_clk) disable iff(!wr_rstn)
    //     fifo_used <= FIFO_DEPTH;
    // endproperty
    
    // assert property(valid_fifo_usage)
    // else $error("FIFO usage counter overflow detected");
    // // synthesis translate_on

endmodule
