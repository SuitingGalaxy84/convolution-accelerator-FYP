module async_fifo_v2 #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH),
    parameter PRE_FILL_LEVEL = FIFO_DEPTH/2
)(
    // Write domain
    input  wire                  wr_clk,
    input  wire                  wr_rstn,
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,
    output wire                  almost_full,
    output reg                   pre_fill_done,
    output wire [ADDR_WIDTH:0]   wr_water_level,
    
    // Read domain
    input  wire                  rd_clk,
    input  wire                  rd_rstn,
    input  wire                  rd_en,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire                  empty,
    output wire                  almost_empty,
    output wire                  pre_fill_done_sync,
    output wire [ADDR_WIDTH:0]   rd_water_level
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Write domain registers
    reg [ADDR_WIDTH:0] wr_ptr_bin;
    reg [ADDR_WIDTH:0] wr_ptr_gray;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync [1:0];
    
    // Read domain registers
    reg [ADDR_WIDTH:0] rd_ptr_bin;
    reg [ADDR_WIDTH:0] rd_ptr_gray;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync [1:0];
    reg [1:0]          pre_fill_sync;

    // Synchronization of pointers
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn)
            rd_ptr_gray_sync <= '{default: '0};
        else begin
            rd_ptr_gray_sync[0] <= rd_ptr_gray;
            rd_ptr_gray_sync[1] <= rd_ptr_gray_sync[0];
        end
    end

    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            wr_ptr_gray_sync <= '{default: '0};
            pre_fill_sync <= 2'b00;
        end else begin
            wr_ptr_gray_sync[0] <= wr_ptr_gray;
            wr_ptr_gray_sync[1] <= wr_ptr_gray_sync[0];
            pre_fill_sync <= {pre_fill_sync[0], pre_fill_done};
        end
    end

    // Write pointer logic
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wr_ptr_bin <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            wr_ptr_bin <= wr_ptr_bin + 1'b1;
            wr_ptr_gray <= (wr_ptr_bin + 1'b1) ^ ((wr_ptr_bin + 1'b1) >> 1);
        end
    end

    // Read pointer logic
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rd_ptr_bin <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin <= rd_ptr_bin + 1'b1;
            rd_ptr_gray <= (rd_ptr_bin + 1'b1) ^ ((rd_ptr_bin + 1'b1) >> 1);
        end
    end

    // Memory write operation
    always @(posedge wr_clk) begin
        if (wr_en && !full)
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
    end

    // Memory read operation
    assign rd_data = mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    // Water level calculation
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

    // Write domain water level
    wire [ADDR_WIDTH:0] rd_ptr_bin_sync;
    assign rd_ptr_bin_sync = gray2bin(rd_ptr_gray_sync[1]);
    assign wr_water_level = wr_ptr_bin - rd_ptr_bin_sync;

    // Read domain water level
    wire [ADDR_WIDTH:0] wr_ptr_bin_sync;
    assign wr_ptr_bin_sync = gray2bin(wr_ptr_gray_sync[1]);
    assign rd_water_level = wr_ptr_bin_sync - rd_ptr_bin;

    // Pre-fill status
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn)
            pre_fill_done <= 1'b0;
        else if (wr_water_level >= PRE_FILL_LEVEL)
            pre_fill_done <= 1'b1;
        else if (wr_water_level < PRE_FILL_LEVEL)
            pre_fill_done <= 1'b0;
    end

    assign pre_fill_done_sync = pre_fill_sync[1];

    // Status flags
    assign full = (wr_ptr_gray[ADDR_WIDTH:ADDR_WIDTH-1] != rd_ptr_gray_sync[1][ADDR_WIDTH:ADDR_WIDTH-1]) &&
                 (wr_ptr_gray[ADDR_WIDTH-2:0] == rd_ptr_gray_sync[1][ADDR_WIDTH-2:0]);
                 
    assign empty = (wr_ptr_gray_sync[1] == rd_ptr_gray);

    assign almost_full = (wr_water_level >= FIFO_DEPTH-2);
    assign almost_empty = (rd_water_level <= 2);


endmodule
