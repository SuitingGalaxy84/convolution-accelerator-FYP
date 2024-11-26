module tb_AsyncFIFO;

    // Parameters (match these with your FIFO implementation)
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    // Clock signals
    logic wr_clk, rd_clk;
    logic rst;

    // Write interface
    logic wr_en;
    logic [DATA_WIDTH-1:0] wr_data;

    // Read interface
    logic rd_en;
    logic [DATA_WIDTH-1:0] rd_data;

    // Status signals
    logic full, empty;

    // Instantiate the FIFO (connect the testbench signals)
    AsyncFIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5  wr_clk = ~wr_clk;  // Write clock: 100 MHz
    always #7  rd_clk = ~rd_clk;  // Read clock: 71 MHz

    // Test sequence
    initial begin
        // Initialize signals
        wr_clk = 0;
        rd_clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Apply reset
        #20;
        rst = 0;

        // Start writing to FIFO
        $display("Start writing to FIFO...");
        repeat (FIFO_DEPTH) begin
            if (!full) begin
                wr_en = 1;
                wr_data = $random; // Random data
                $display("Write: %0d", wr_data);
                #10; // Wait for one write clock cycle
            end else begin
                wr_en = 0;
                #10; // Wait for full condition to clear
            end
        end
        wr_en = 0;

        // Start reading from FIFO
        $display("Start reading from FIFO...");
        repeat (FIFO_DEPTH) begin
            if (!empty) begin
                rd_en = 1;
                #10; // Wait for one read clock cycle
                $display("Read: %0d", rd_data);
            end else begin
                rd_en = 0;
                #10; // Wait for empty condition to clear
            end
        end
        rd_en = 0;

        // Finish simulation
        $display("Testbench completed.");
        $stop;
    end

endmodule